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
  Returns the list of images that are marked as favorite.

  ## Examples

      iex> list_image_favorites()
      [%Image{}, ...]

  """
  def list_image_favorites(is_favorite) do
    from(image in Image, where: image.is_favorite == ^is_favorite, order_by: [desc: :creation_time, desc: :id])
    |> image_preload_import
    |> Repo.all
    |> image_default_preloads
  end

  @doc """
  Returns the list of images that are not in any albums

  ## Examples

      iex> list_images_not_in_album()
      [%Image{}, ...]

  """
  def list_images_not_in_album() do
    from(
        image in Image,
        join: import in assoc(image, :import),
        left_join: album_image in assoc(image, :album_images),
        where: is_nil(album_image.image_id),
        preload: [import: import],
        order_by: [desc: image.creation_time, desc: image.id]
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
  def list_images_with_no_amazon_photos_id() do
    from(
      image in Image,
      where: is_nil(image.amazon_photos_id),
      order_by: [desc: :creation_time, desc: :id])
    |> image_preload_import
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
    |> image_preload_import
    |> Repo.one!
    |> image_default_preloads
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
  Gets albums not used by an image given by id
  """
  def list_image_albums_unused(image_id) do
    album_images_suquery = from(
                                album_image in AlbumImage,
                                where: album_image.image_id == ^image_id,
                                distinct: album_image.album_id,
                                select: %{album_id: album_image.album_id}
                            )

    from(
        album in Album,
        left_join: album_image in subquery(album_images_suquery),
        on: album.id == album_image.album_id,
        where: is_nil(album_image.album_id),
        order_by: [album.name, album.id]
    )
    |> Repo.all
  end

  @doc """
  Gets persons not used by an image given by id
  """
  def list_image_persons_unused(image_id) do
    person_images_suquery = from(
                                person_image in PersonImage,
                                where: person_image.image_id == ^image_id,
                                distinct: person_image.person_id,
                                select: %{person_id: person_image.person_id}
                            )

    from(
        person in Person,
        left_join: person_image in subquery(person_images_suquery),
        on: person.id == person_image.person_id,
        where: is_nil(person_image.person_id),
        order_by: [person.name, person.id]
    )
    |> Repo.all
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

  @doc """
  Returns the list of albums.

  ## Examples

      iex> list_albums()
      [%Album{}, ...]

  """
  def list_albums do
    from(album in Album,
      join: cover_image in assoc(album, :cover_image),
      left_join: album_image in assoc(album, :album_images),
      group_by: [album.id, cover_image.id],
      preload: [cover_image: cover_image],
      order_by: [desc: :id],
      select: %Album{album | images_count: count(album.id)}
    )
    |> Repo.all
  end

  @doc """
  Returns the list of albums.
  Used for forms when we only need name and id
  """
  def list_albums_excerpt do
    Repo.all from album in Album,
          order_by: [desc: :id]
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
    # for some reason, if you put subquery directly in preload, it causes an error
    image_albums_query = from(Album, order_by: :name)
    image_persons_query = from(Person, order_by: :name)
    images_query = from image in Image,
                      join: album_image in assoc(image, :album_images),
                      join: import in assoc(image, :import),
                      where: album_image.album_id == ^id,
                      preload: [albums: ^image_albums_query, persons: ^image_persons_query, import: import],
                      order_by: [album_image.image_order, album_image.id]
    tags_query = from tag in Tag,
                      join: album_tag in assoc(tag, :album_tags),
                      where: album_tag.album_id == ^id,
                      order_by: [asc: tag.name, desc: tag.id]

    Repo.one!(from album in Album,
                      join: cover_image in assoc(album, :cover_image),
                      where: album.id == ^id,
                      preload: [cover_image: cover_image, images: ^images_query, tags: ^tags_query],
                      limit: 1)
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
    Repo.all from person in Person,
          order_by: :name
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
    #better than using separate preload, since only uses 1 query
    #https://hexdocs.pm/ecto/Ecto.Query.html#preload/3
    # for some reason, if you put subquery directly in preload, it causes an error
    image_albums_query = from(Album, order_by: :name)
    image_persons_query = from(Person, order_by: :name)
    images_query = from image in Image,
                      join: person_image in assoc(image, :person_images),
                      join: import in assoc(image, :import),
                      where: person_image.person_id == ^id,
                      preload: [albums: ^image_albums_query, persons: ^image_persons_query, import: import],
                      order_by: [desc: image.creation_time]

    Repo.one! from person in Person,
           join:  cover_image in assoc(person, :cover_image),
           where: person.id == ^id,
           preload: [images: ^images_query, cover_image: cover_image],
           limit: 1
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
  Returns the list of imports.

  ## Examples

      iex> list_imports()
      [%Import{}, ...]

  """
  def list_imports do
    Repo.all(from(Import, order_by: [desc: :import_time, desc: :id]))
  end

  @doc """
  Returns the list of imports
  Also preloads a limited amount of images
  """
  def list_imports_with_count_and_limited_images do
    # Just gets all the images and then throws out what is needed,
    # since it ends up only taking 2 sec average to do this
    # compared with 4 for using lateral join or window function
    from(
        import in Import,
        join: image in assoc(import, :images),
        preload: [images: image],
        order_by: [desc: import.import_time, desc: import.id]
    )
    |> Repo.all
    |> Enum.map(fn import -> 
      %Import{import | images_count: Enum.count(import.images), images: Enum.take(import.images, 4)}
    end)
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
    # for some reason, if you put subquery directly in preload, it causes an error
    image_albums_query = from(Album, order_by: :name)
    image_persons_query = from(Person, order_by: :name)
    images_query = from image in Image,
                      join: import in assoc(image, :import),
                      preload: [albums: ^image_albums_query, persons: ^image_persons_query, import: import],
                      order_by: [image.creation_time, image.id]

    Repo.get!(Import, id)
    |> Repo.preload(images: images_query)
  end

  @doc """
  Gets the last import.

  Raises `Ecto.NoResultsError` if there are no imports.
  """
  def get_last_import!() do
    # for some reason, if you put subquery directly in preload, it causes an error
    image_albums_query = from(Album, order_by: :name)
    image_persons_query = from(Person, order_by: :name)
    images_query = from image in Image,
                      join: import in assoc(image, :import),
                      preload: [albums: ^image_albums_query, persons: ^image_persons_query, import: import],
                      order_by: [image.creation_time, image.id]

    Repo.one!(from(import in Import, order_by: [desc: :import_time, desc: :id], limit: 1))
    |> Repo.preload(images: images_query)
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
        group_by: [tag.id, image.id, album.id],
        order_by: tag.name,
        select: {tag, image, count(tag.id)}
    )
    |> Repo.all
    |> Enum.map(fn {tag, image, albums_count} -> %Tag{tag | cover_image: image, albums_count: albums_count} end)
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

    albums = from(album in Album,
      join: cover_image in assoc(album, :cover_image),
      left_join: album_image in assoc(album, :album_images),
      join: album_tag in assoc(album, :album_tags),
      where: album_tag.tag_id == ^id,
      group_by: [album.id, cover_image.id, album_tag.id, album_tag.album_order],
      order_by: [album_tag.album_order, album_tag.id],
      preload: [cover_image: cover_image],
      select: %Album{album | images_count: count(album.id)}
    )
    |> Repo.all

    %Tag{tag | albums: albums}
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
