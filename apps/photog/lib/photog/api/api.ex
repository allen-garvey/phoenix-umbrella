defmodule Photog.Api do
  @moduledoc """
  The Api context.
  """

  import Ecto.Query, warn: false
  alias Photog.Repo

  alias Photog.Api.Album
  alias Photog.Api.AlbumImage
  alias Photog.Api.PersonImage
  alias Photog.Api.Image
  alias Photog.Api.Person
  alias Photog.Api.Import
  alias Photog.Api.Tag
  alias Photog.Api.AlbumTag

  @doc """
  Preloads image import
  """
  def image_preload_import(query) do
    query
    |> join(:inner, [image], import in assoc(image, :import))
    |> preload([image, import], [import: import])
  end

  @doc """
  Default preloads when getting retrieving images
  """
  def image_default_preloads(results) do
    results
    |> Repo.preload(albums: from(Album, order_by: :name))
    |> Repo.preload(persons: from(Person, order_by: :name))
  end

  @doc """
  Returns the list of images.

  ## Examples

      iex> list_images()
      [%Image{}, ...]

  """
  def list_images do
    from(Image, order_by: [desc: :creation_time, desc: :id])
    |> image_preload_import
    |> Repo.all
    |> image_default_preloads
  end

  @doc """
  Returns the list of images starting at offset, 
  where number of results is less than or equal to the limit.

  ## Examples

      iex> list_images()
      [%Image{}, ...]

  """
  def list_images(limit, offset) do
    from(
      Image, 
      order_by: [desc: :creation_time, desc: :id],
      limit: ^limit,
      offset: ^offset
    )
    |> image_preload_import
    |> Repo.all
    |> image_default_preloads
  end

  @doc """
  Returns the list of images taken in given year
  """
  def list_images_for_year(year) when is_integer(year) do
    from(
      image in Image,
      where: fragment("EXTRACT(year FROM ?)", image.creation_time) == ^year, 
      order_by: [:creation_time, :id]
    )
    |> Repo.all
  end

  def list_images_for_year(year, limit, offset) when is_integer(year) do
    from(
      image in Image,
      where: fragment("EXTRACT(year FROM ?)", image.creation_time) == ^year, 
      order_by: [:creation_time, :id],
      limit: ^limit,
      offset: ^offset
    )
    |> image_preload_import
    |> Repo.all
    |> image_default_preloads
  end

  @doc """
  Returns the count of images taken in given year
  """
  def images_count_for_year!(year) when is_integer(year) do
    from(
      image in Image,
      where: fragment("EXTRACT(year FROM ?)", image.creation_time) == ^year, 
      select: count(image.id)
    )
    |> Repo.one!
  end

  @doc """
  Returns total count of images
  """
  def images_count! do
    from(
      image in Image,
      select: count(image.id)
    )
    |> Repo.one!
  end

  def images_favorite_count!(is_favorite) when is_boolean(is_favorite) do
    from(
      image in Image,
      where: image.is_favorite == ^is_favorite, 
      select: count(image.id)
    )
    |> Repo.one!
  end

  def images_not_in_album_count! do
    from(
      image in Image,
      left_join: album_image in assoc(image, :album_images),
      where: is_nil(album_image.id), 
      select: count(image.id)
    )
    |> Repo.one!
  end

  @doc """
  Returns the list of images that are marked as favorite.

  ## Examples

      iex> list_image_favorites()
      [%Image{}, ...]

  """
  def list_image_favorites(is_favorite, limit, offset) when is_boolean(is_favorite) do
    from(
      image in Image, 
      where: image.is_favorite == ^is_favorite, 
      order_by: [desc: :creation_time, desc: :id],
      limit: ^limit,
      offset: ^offset
    )
    |> image_preload_import
    |> Repo.all
    |> image_default_preloads
  end

  @doc """
  Returns the list of images where master_path matches search query
  """
  def list_images_for_query(search_query) when is_binary(search_query) do
    from(
      image in Image,
      where: ilike(image.master_path, ^"%#{search_query}%"), 
      order_by: [:creation_time, :id],
      limit: 100
    )
    |> Repo.all
  end

  @doc """
  Returns the list of images that are not in any albums

  ## Examples

      iex> list_images_not_in_album(limit, offset)
      [%Image{}, ...]

  """
  def list_images_not_in_album(limit, offset) do
    from(
        image in Image,
        left_join: album_image in assoc(image, :album_images),
        where: is_nil(album_image),
        order_by: [desc: image.creation_time, desc: image.id],
        limit: ^limit,
        offset: ^offset
    )
    |> Repo.all
    |> image_default_preloads
  end

  @doc """
  Returns the list of images that have no amazon photos id

  ## Examples

      iex> list_images_with_no_amazon_photos_id()
      [%Image{}, ...]

  """
  def list_images_with_no_amazon_photos_id(limit, offset) do
    from(
      image in Image,
      where: is_nil(image.amazon_photos_id),
      order_by: [desc: :creation_time, desc: :id],
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all
    |> image_default_preloads
  end

  @doc """
  Gets a single image.

  Raises `Ecto.NoResultsError` if the Image does not exist.

  ## Examples

      iex> get_image!(123)
      %Image{}

      iex> get_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_image!(id) do
    from(image in Image, where: image.id == ^id)
    |> Repo.one!
  end

  def get_image!(id, :full) do
    from(
      image in Image, 
      where: image.id == ^id
    )
    |> image_preload_import
    |> Repo.one!
    |> image_default_preloads
    |> Repo.preload(versions: from(image in Image, select: [:id], order_by: [:id]))
  end

  @doc """
  Gets a single image with exif data preloaded.

  Raises `Ecto.NoResultsError` if the Image does not exist.

  ## Examples

      iex> get_image!(123)
      %Image{}

      iex> get_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_image_with_exif!(id) do
    from(
          i in Image,
          where: i.id == ^id,
          select: [:id, :master_path, :exif]
        )
    |> Repo.one!
  end

  @doc """
  Creates a image.

  ## Examples

      iex> create_image(%{field: value})
      {:ok, %Image{}}

      iex> create_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_image(attrs \\ %{}) do
    %Image{}
    |> Image.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a image.

  ## Examples

      iex> update_image(image, %{field: new_value})
      {:ok, %Image{}}

      iex> update_image(image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_image(%Image{} = image, attrs) do
    image
    |> Image.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Image.

  ## Examples

      iex> delete_image(image)
      {:ok, %Image{}}

      iex> delete_image(image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_image(%Image{} = image) do
    Repo.delete(image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking image changes.

  ## Examples

      iex> change_image(image)
      %Ecto.Changeset{source: %Image{}}

  """
  def change_image(%Image{} = image) do
    Image.changeset(image, %{})
  end

  def list_albums_query do
    from(album in Album,
      join: cover_image in assoc(album, :cover_image),
      left_join: album_image in assoc(album, :album_images),
      left_join: tag in assoc(album, :tags),
      group_by: [album.id, cover_image.id, tag.id],
      preload: [cover_image: cover_image, tags: tag],
      order_by: [desc: :id],
      select: %Album{album | images_count: count(album.id)}
    )
  end

  @doc """
  Returns the list of albums.

  ## Examples

      iex> list_albums()
      [%Album{}, ...]

  """
  def list_albums do
    list_albums_query()
    |> Repo.all
  end

  def list_albums(limit, offset) do
    list_albums()
    # need to do it this way since because of joins offset and limit don't work correctly
    |> Enum.slice(offset, limit)
  end

  @doc """
  Returns the list of albums based on whether or not they are favorited
  """
  def list_album_favorites(is_favorite, limit, offset) when is_boolean(is_favorite) do
    list_albums_query()
    |> where([album], album.is_favorite == ^is_favorite)
    |> exclude(:order_by)
    |> order_by([:name, :id])
    |> Repo.all
    # need to do it this way since because of joins offset and limit don't work correctly
    |> Enum.slice(offset, limit)
  end

  @doc """
  Returns the list of albums for the given year.
  """
  def list_albums_for_year(year, limit, offset) do
    list_albums_query()
    |> where([album], album.year == ^year)
    |> Repo.all
    # need to do it this way since because of joins offset and limit don't work correctly
    |> Enum.slice(offset, limit)
  end

  @doc """
  Returns the string list of years where there are albums
  """
  def distinct_album_years do
    from(
      album in Album,
      distinct: [desc: :year],
      order_by: [desc: :year],
      select: album.year
    )
    |> Repo.all
  end


  @doc """
  Returns the list of albums.
  Used for forms when we only need name and id
  """
  def list_albums_excerpt do
    from(
      Album,
      order_by: [desc: :id],
      select: [:id, :name, :is_favorite]
    )
    |> Repo.all
  end

  def albums_count! do
    from(
      album in Album,
      select: count(album.id)
    )
    |> Repo.one!
  end

  def albums_count_for_year!(year) do
    from(
      album in Album,
      where: album.year == ^year,
      select: count(album.id)
    )
    |> Repo.one!
  end

  def albums_favorite_count!(is_favorite) when is_boolean(is_favorite) do
    from(
      album in Album,
      where: album.is_favorite == ^is_favorite, 
      select: count(album.id)
    )
    |> Repo.one!
  end

  @doc """
  Gets images for an album
  """
  def get_images_for_album(id) do
    image_albums_query = from(Album, order_by: :name)
    image_persons_query = from(Person, order_by: :name)

    from(
      image in Image,
      join: album_image in assoc(image, :album_images),
      where: album_image.album_id == ^id,
      preload: [albums: ^image_albums_query, persons: ^image_persons_query],
      order_by: [album_image.image_order, album_image.id]
    )
    |> Repo.all
  end

  def get_images_for_album(id, limit, offset) do
    get_images_for_album(id)
    |> Enum.slice(offset, limit)
  end

  def get_images_for_album(id, :excerpt) do
    from(
      image in Image,
      join: album_image in assoc(image, :album_images),
      where: album_image.album_id == ^id,
      order_by: [album_image.image_order, album_image.id]
    )
    |> Repo.all
  end

  @doc """
  Gets a single album.

  Raises `Ecto.NoResultsError` if the Album does not exist.

  ## Examples

      iex> get_album!(123)
      %Album{}

      iex> get_album!(456)
      ** (Ecto.NoResultsError)

  """
  def get_album!(id) do
    tags_query = from(
      tag in Tag,
      join: album_tag in assoc(tag, :album_tags),
      where: album_tag.album_id == ^id,
      order_by: [asc: tag.name, desc: tag.id]
    )

    album = from(
      album in Album,
      join: cover_image in assoc(album, :cover_image),
      where: album.id == ^id,
      preload: [cover_image: cover_image, tags: ^tags_query]
    )
      |> Repo.one!

    images_count = from(
      album_image in AlbumImage,
      where: album_image.album_id == ^id,
      select: count(album_image.id)
    )
      |> Repo.one!

    %Album{album | images_count: images_count}
  end

  @doc """
  Creates a album.

  ## Examples

      iex> create_album(%{field: value})
      {:ok, %Album{}}

      iex> create_album(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_album(attrs \\ %{}) do
    %Album{}
    |> Album.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a album.

  ## Examples

      iex> update_album(album, %{field: new_value})
      {:ok, %Album{}}

      iex> update_album(album, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_album(%Album{} = album, attrs) do
    album
    |> Album.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Album.

  ## Examples

      iex> delete_album(album)
      {:ok, %Album{}}

      iex> delete_album(album)
      {:error, %Ecto.Changeset{}}

  """
  def delete_album(%Album{} = album) do
    Repo.delete(album)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking album changes.

  ## Examples

      iex> change_album(album)
      %Ecto.Changeset{source: %Album{}}

  """
  def change_album(%Album{} = album) do
    Album.changeset(album, %{})
  end

  @doc """
  Reorders the images in an album
  """
  def reorder_images_for_album(album_id, image_ids) when is_list(image_ids) do
    Repo.transaction(fn ->
      for {image_id, i} <- image_ids |> Enum.with_index do
        now = DateTime.utc_now() |> DateTime.truncate(:second)
        {1, nil} = from(
              album_image in AlbumImage,
              where: album_image.album_id == ^album_id and album_image.image_id == ^image_id
            )
          |> Repo.update_all(set: [image_order: i, updated_at: now])
      end
    end)
  end

  @doc """
  Replaces the current tags for an album with given list of tag ids
  """
  def replace_tags_for_album(album_id, tag_ids) when is_list(tag_ids) do
    Repo.transaction(fn ->
      {_, nil} = from(album_tag in AlbumTag, where: album_tag.album_id == ^album_id)
        |> Repo.delete_all

      for tag_id <- tag_ids do
        create_album_tag!(%{album_id: album_id, tag_id: tag_id})
      end

    end)
  end

  @doc """
  Returns the list of persons.

  ## Examples

      iex> list_persons()
      [%Person{}, ...]

  """
  def list_persons do
    from(
      person in Person,
      join: cover_image in assoc(person, :cover_image),
      left_join: person_image in assoc(person, :person_images),
      group_by: [person.id, cover_image.id],
      preload: [cover_image: cover_image],
      order_by: :name,
      select: %Person{person | images_count: count(person.id)}
    )
    |> Repo.all
  end

  @doc """
  Returns the list of persons.
  Used for such things as forms, when just need name and id
  """
  def list_persons_excerpt do
    from(
      Person,
      order_by: :name,
      select: [:id, :name]
    )
    |> Repo.all
  end

  @doc """
  Gets a single person.

  Raises `Ecto.NoResultsError` if the Person does not exist.

  ## Examples

      iex> get_person!(123)
      %Person{}

      iex> get_person!(456)
      ** (Ecto.NoResultsError)

  """
  def get_person!(id) do
    person = from(
      person in Person,
      join:  cover_image in assoc(person, :cover_image),
      where: person.id == ^id,
      preload: [cover_image: cover_image]
    )
    |> Repo.one!

    images_count = from(
      person_image in PersonImage,
      where: person_image.person_id == ^id,
      select: count(person_image.id)
    )
    |> Repo.one!

    %Person{person | images_count: images_count}
  end

  @doc """
  Gets images for a person
  """
  def get_images_for_person(id) do
    # for some reason, if you put subquery directly in preload, it causes an error
    image_albums_query = from(Album, order_by: :name)
    image_persons_query = from(Person, order_by: :name)

    from(
      image in Image,
      join: person_image in assoc(image, :person_images),
      where: person_image.person_id == ^id,
      preload: [albums: ^image_albums_query, persons: ^image_persons_query],
      order_by: [desc: image.creation_time]
    )
    |> Repo.all
  end

  def get_images_for_person(id, limit, offset) do
    get_images_for_person(id)
    |> Enum.slice(offset, limit)
  end

  @doc """
  Creates a person.

  ## Examples

      iex> create_person(%{field: value})
      {:ok, %Person{}}

      iex> create_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_person(attrs \\ %{}) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a person.

  ## Examples

      iex> update_person(person, %{field: new_value})
      {:ok, %Person{}}

      iex> update_person(person, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_person(%Person{} = person, attrs) do
    person
    |> Person.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Person.

  ## Examples

      iex> delete_person(person)
      {:ok, %Person{}}

      iex> delete_person(person)
      {:error, %Ecto.Changeset{}}

  """
  def delete_person(%Person{} = person) do
    Repo.delete(person)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking person changes.

  ## Examples

      iex> change_person(person)
      %Ecto.Changeset{source: %Person{}}

  """
  def change_person(%Person{} = person) do
    Person.changeset(person, %{})
  end

  @doc """
  Returns the list of person_images.

  ## Examples

      iex> list_person_images()
      [%PersonImage{}, ...]

  """
  def list_person_images do
    Repo.all(PersonImage)
  end

  @doc """
  Gets a single person_image.

  Raises `Ecto.NoResultsError` if the Person image does not exist.

  ## Examples

      iex> get_person_image!(123)
      %PersonImage{}

      iex> get_person_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_person_image!(id), do: Repo.get!(PersonImage, id)

  @doc """
  Creates a person_image.

  ## Examples

      iex> create_person_image(%{field: value})
      {:ok, %PersonImage{}}

      iex> create_person_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_person_image(attrs \\ %{}) do
    %PersonImage{}
    |> PersonImage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a person_image.

  ## Examples

      iex> update_person_image(person_image, %{field: new_value})
      {:ok, %PersonImage{}}

      iex> update_person_image(person_image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_person_image(%PersonImage{} = person_image, attrs) do
    person_image
    |> PersonImage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PersonImage.

  ## Examples

      iex> delete_person_image(person_image)
      {:ok, %PersonImage{}}

      iex> delete_person_image(person_image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_person_image(%PersonImage{} = person_image) do
    Repo.delete(person_image)
  end

  def delete_person_image(person_id, image_id) do
    from(
      person_image in PersonImage,
      where: person_image.person_id == ^person_id and person_image.image_id == ^image_id
    )
    |> Repo.delete_all
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking person_image changes.

  ## Examples

      iex> change_person_image(person_image)
      %Ecto.Changeset{source: %PersonImage{}}

  """
  def change_person_image(%PersonImage{} = person_image) do
    PersonImage.changeset(person_image, %{})
  end

  @doc """
  Returns the list of album_images.

  ## Examples

      iex> list_album_images()
      [%AlbumImage{}, ...]

  """
  def list_album_images do
    Repo.all(AlbumImage)
  end

  @doc """
  Gets a single album_image.

  Raises `Ecto.NoResultsError` if the Album image does not exist.

  ## Examples

      iex> get_album_image!(123)
      %AlbumImage{}

      iex> get_album_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_album_image!(id), do: Repo.get!(AlbumImage, id)

  @doc """
  Creates a album_image.

  ## Examples

      iex> create_album_image(%{field: value})
      {:ok, %AlbumImage{}}

      iex> create_album_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_album_image(attrs \\ %{}) do
    %AlbumImage{}
    |> AlbumImage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a album_image.

  ## Examples

      iex> update_album_image(album_image, %{field: new_value})
      {:ok, %AlbumImage{}}

      iex> update_album_image(album_image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_album_image(%AlbumImage{} = album_image, attrs) do
    album_image
    |> AlbumImage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a AlbumImage.

  ## Examples

      iex> delete_album_image(album_image)
      {:ok, %AlbumImage{}}

      iex> delete_album_image(album_image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_album_image(%AlbumImage{} = album_image) do
    Repo.delete(album_image)
  end

  def delete_album_image(album_id, image_id) do
    from(
      album_image in AlbumImage,
      where: album_image.album_id == ^album_id and album_image.image_id == ^image_id
    )
    |> Repo.delete_all
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking album_image changes.

  ## Examples

      iex> change_album_image(album_image)
      %Ecto.Changeset{source: %AlbumImage{}}

  """
  def change_album_image(%AlbumImage{} = album_image) do
    AlbumImage.changeset(album_image, %{})
  end

  @doc """
  Manually camera model for imports
  """
  def manually_preload_camera_model(results) do
    results
    |> Enum.map(fn { import, {camera_make, camera_model} } -> 
      %Import{import | camera_model: Import.determine_camera_model(camera_make, camera_model)}
    end)
  end

  @doc """
  Returns the list of imports.

  ## Examples

      iex> list_imports()
      [%Import{}, ...]

  """
  def list_imports do
    Repo.all(from(Import, order_by: [desc: :import_time, desc: :id]))
  end

  @doc """
  Returns the total number of imports

  ## Examples

      iex> imports_count()
      10

  """
  def imports_count! do
    from(
      import in Import,
      select: count(import.id)
    )
    |> Repo.one!
  end

  def list_imports_with_count_and_limited_images_query do
    from(
        import in Import,
        join: cover_image in assoc(import, :cover_image),
        left_join: image in assoc(import, :images),
        group_by: [import.id, cover_image.id],
        order_by: [desc: import.import_time, desc: import.id],
        select: {%Import{import | images_count: count(import.id), images: [cover_image]},
        {cover_image.exif["Make"], cover_image.exif["Model"]}}
    )
  end

  @doc """
  Returns the list of imports
  Also preloads a limited amount of images
  """
  def list_imports_with_count_and_limited_images do
    list_imports_with_count_and_limited_images_query()
    |> Repo.all
    |> manually_preload_camera_model
  end

  def list_imports_with_count_and_limited_images(limit, offset) do
    list_imports_with_count_and_limited_images_query()
    |> limit(^limit)
    |> offset(^offset)
    |> Repo.all
    |> manually_preload_camera_model
  end

  @doc """
  Gets a single import.

  Raises `Ecto.NoResultsError` if the Import does not exist.

  ## Examples

      iex> get_import!(123)
      %Import{}

      iex> get_import!(456)
      ** (Ecto.NoResultsError)

  """
  def get_import!(id) do
    import_task = Task.async(fn -> Repo.get!(Import, id) end)
    images_count_task = Task.async(fn -> import_images_count!(id) end)

    import = Task.await(import_task)
    images_count = Task.await(images_count_task)

    %Import{import | images_count: images_count}
  end

  @doc """
  Gets the last import.

  Raises `Ecto.NoResultsError` if there are no imports.
  """
  def get_last_import!() do
    import = from(
      import in Import, 
      order_by: [desc: :import_time, desc: :id],
      limit: 1
    )
    |> Repo.one!

    %Import{import | images_count: import_images_count!(import.id)}
  end

  def import_images_count!(import_id) do
    from(
      image in Image,
      where: image.import_id == ^import_id,
      select: count(image.id)
    )
    |> Repo.one!
  end

  def get_images_for_import(id) do
    # for some reason, if you put subquery directly in preload, it causes an error
    image_albums_query = from(Album, order_by: :name)
    image_persons_query = from(Person, order_by: :name)
    
    from(
      image in Image,
      where: image.import_id == ^id,
      preload: [albums: ^image_albums_query, persons: ^image_persons_query],
      order_by: [image.creation_time, image.id]
    )
    |> Repo.all
  end

  def get_images_for_import(id, limit, offset) do
    get_images_for_import(id)
    |> Enum.slice(offset, limit)
  end

  @doc """
  Creates a import.

  ## Examples

      iex> create_import(%{field: value})
      {:ok, %Import{}}

      iex> create_import(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_import(attrs \\ %{}) do
    %Import{}
    |> Import.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a import.

  ## Examples

      iex> update_import(import, %{field: new_value})
      {:ok, %Import{}}

      iex> update_import(import, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_import(%Import{} = import, attrs) do
    import
    |> Import.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Import.

  ## Examples

      iex> delete_import(import)
      {:ok, %Import{}}

      iex> delete_import(import)
      {:error, %Ecto.Changeset{}}

  """
  def delete_import(%Import{} = import) do
    Repo.delete(import)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking import changes.

  ## Examples

      iex> change_import(import)
      %Ecto.Changeset{source: %Import{}}

  """
  def change_import(%Import{} = import) do
    Import.changeset(import, %{})
  end

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags([desc: :id])
      [%Tag{}, ...]

  """
  def list_tags(order_by_list) do
    from(Tag, order_by: ^order_by_list)
    |> Repo.all
  end

  @doc """
  Returns the list of maps with tag and cover image with the cover image of the last album added as the cover image
  """
  def list_tags do
    from(
        tag in Tag,
        left_lateral_join: album_tag in fragment("SELECT album_id FROM album_tags WHERE tag_id = ? ORDER BY id DESC LIMIT 1", tag.id),
        on: true,
        left_join: album in Album,
        on: album.id == album_tag.album_id,
        left_join: image in assoc(album, :cover_image),
        left_join: album_tag_2 in assoc(tag, :album_tags),
        left_join: cover_album in assoc(tag, :cover_album),
        left_join: cover_album_image in assoc(cover_album, :cover_image),
        group_by: [tag.id, image.id, album.id, cover_album.id, cover_album_image.id],
        order_by: tag.name,
        select: {tag, image, cover_album_image, count(tag.id)}
    )
    |> Repo.all
    |> Enum.map(fn {tag, image, cover_album_image, albums_count} -> 
      cover_image = case cover_album_image do
        nil -> image
        _   -> cover_album_image
      end
      %Tag{tag | cover_image: cover_image, albums_count: albums_count} 
    end)
  end

  def list_tags_by_favorite(is_favorite) when is_boolean(is_favorite) do
    list_tags()
    |> Enum.filter(fn tag -> tag.is_favorite == is_favorite end)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id) do
    tag = Repo.get!(Tag, id)

    albums_count = from(
      album_tag in AlbumTag,
      where: album_tag.tag_id == ^id,
      select: count(album_tag.id)
    )
    |> Repo.one!

    %Tag{tag | albums_count: albums_count}
  end

  @doc """
  Gets albums for a tag
  """
  def get_albums_for_tag(id) do
    from(
      album in Album,
      join: cover_image in assoc(album, :cover_image),
      left_join: album_image in assoc(album, :album_images),
      join: album_tag in assoc(album, :album_tags),
      where: album_tag.tag_id == ^id,
      group_by: [album.id, cover_image.id, album_tag.id, album_tag.album_order],
      order_by: [asc: album_tag.album_order, desc: album_tag.id],
      preload: [cover_image: cover_image],
      select: %Album{album | images_count: count(album.id)}
    )
    |> Repo.all
  end

  def get_albums_for_tag(id, limit, offset) do
    get_albums_for_tag(id)
    |> Enum.slice(offset, limit)
  end

  @doc """
  Gets images for a tag
  """
  def get_images_for_tag(id, :excerpt) do
    from(
      image in Image,
      join: album_image in assoc(image, :album_images),
      join: album_tag in AlbumTag,
      on: album_tag.album_id == album_image.album_id,
      where: album_tag.tag_id == ^id,
      order_by: [album_tag.album_order, album_image.image_order, album_image.id]
    )
    |> Repo.all
  end

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{source: %Tag{}}

  """
  def change_tag(%Tag{} = tag) do
    Tag.changeset(tag, %{})
  end

  @doc """
  Reorders the albums in an tag
  """
  def reorder_albums_for_tag(tag_id, album_ids) when is_list(album_ids) do
    Repo.transaction(fn ->
      for {album_id, i} <- album_ids |> Enum.with_index do
        now = DateTime.utc_now() |> DateTime.truncate(:second)
        {1, nil} = from(
              album_tag in AlbumTag,
              where: album_tag.tag_id == ^tag_id and album_tag.album_id == ^album_id
            )
          |> Repo.update_all(set: [album_order: i, updated_at: now])
      end
    end)
  end

  @doc """
  Returns the list of album_tags.

  ## Examples

      iex> list_album_tags()
      [%AlbumTag{}, ...]

  """
  def list_album_tags do
    Repo.all(AlbumTag)
  end

  @doc """
  Gets a single album_tag.

  Raises `Ecto.NoResultsError` if the Album tag does not exist.

  ## Examples

      iex> get_album_tag!(123)
      %AlbumTag{}

      iex> get_album_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_album_tag!(id), do: Repo.get!(AlbumTag, id)

  @doc """
  Creates a album_tag.

  ## Examples

      iex> create_album_tag(%{field: value})
      {:ok, %AlbumTag{}}

      iex> create_album_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_album_tag(attrs \\ %{}) do
    %AlbumTag{}
    |> AlbumTag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a album_tag with exception on error
  """
  def create_album_tag!(attrs \\ %{}) do
    %AlbumTag{}
    |> AlbumTag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a album_tag.

  ## Examples

      iex> update_album_tag(album_tag, %{field: new_value})
      {:ok, %AlbumTag{}}

      iex> update_album_tag(album_tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_album_tag(%AlbumTag{} = album_tag, attrs) do
    album_tag
    |> AlbumTag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a AlbumTag.

  ## Examples

      iex> delete_album_tag(album_tag)
      {:ok, %AlbumTag{}}

      iex> delete_album_tag(album_tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_album_tag(%AlbumTag{} = album_tag) do
    Repo.delete(album_tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking album_tag changes.

  ## Examples

      iex> change_album_tag(album_tag)
      %Ecto.Changeset{source: %AlbumTag{}}

  """
  def change_album_tag(%AlbumTag{} = album_tag) do
    AlbumTag.changeset(album_tag, %{})
  end

end
