defmodule Habits.Admin do
  @moduledoc """
  The Admin context.
  """

  import Ecto.Query, warn: false
  alias Grenadier.Repo

  alias Habits.Admin.Category
  alias Habits.Admin.Activity

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    from(
      category in Category,
      order_by: category.name
    )
    |> Repo.all()
  end

  def list_favorite_categories(nil) do
    from(
      category in Category,
      where: category.is_favorite == true,
      order_by: category.name
    )
    |> Repo.all()
  end

  def list_favorite_categories(categories) do
    Enum.filter(categories, fn category -> category.is_favorite end)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  defp activities_for_category_query(category_id) do
    from(
      activity in Activity,
      where: activity.category_id == ^category_id,
      order_by: [desc: :date, desc: :id]
    )
  end

  def activities_for_category(category_id) do
    activities_for_category_query(category_id)
    |> Repo.all()
  end

  def activities_for_category(category_id, limit) do
    activities_for_category_query(category_id)
    |> limit(^limit)
    |> Repo.all()
  end

  def activity_streak_for_category(category_id, start_date, end_date) do
    from(
      activity in Activity,
      where:
        activity.category_id == ^category_id and activity.date >= ^start_date and
          activity.date <= ^end_date,
      group_by: [activity.date],
      order_by: [desc: activity.date],
      select: %{count: count(), date: activity.date}
    )
    |> Repo.all()
  end

  @doc """
  Gets a single category id or nil.

  Looks at the last 10 activities
  and finds the most popular category id.
  """
  def get_recent_popular_category_id() do
    activities_query =
      from(
        Activity,
        order_by: [desc: :inserted_at, desc: :id],
        limit: 10
      )

    from(
      activity in subquery(activities_query),
      group_by: [activity.category_id],
      order_by: [desc: count(activity.category_id)],
      select: activity.category_id,
      limit: 1
    )
    |> Repo.one()
  end

  defp list_activities_query do
    from(
      activity in Activity,
      join: category in assoc(activity, :category),
      preload: [category: category],
      order_by: [desc: activity.id]
    )
  end

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities()
      [%Activity{}, ...]

  """
  def list_activities do
    list_activities_query()
    |> Repo.all()
  end

  def list_activities(limit) do
    list_activities_query()
    |> limit(^limit)
    |> Repo.all()
  end

  def list_activities_after(date) do
    from(
      activity in Activity,
      where: activity.date >= ^date,
      order_by: [desc: activity.date, asc: activity.id]
    )
    |> Repo.all()
  end

  def recent_activity_titles_for(category_id) do
    from(
      activity in Activity,
      group_by: [:title],
      order_by: [desc: max(activity.id)],
      where: activity.category_id == ^category_id,
      limit: 5,
      select: [:title]
    )
    |> Repo.all()
  end

  defp activities_for_query_query(query) do
    like_query = "%#{query}%"

    from(
      activity in Activity,
      where: ilike(activity.title, ^like_query) or ilike(activity.description, ^like_query),
      order_by: [desc: activity.date, desc: activity.id]
    )
  end

  def activities_for_query(query, "") do
    activities_for_query_query(query)
    |> Repo.all()
  end

  def activities_for_query(query, category_id) do
    activities_for_query_query(query)
    |> where([activity], activity.category_id == ^category_id)
    |> Repo.all()
  end

  @doc """
  Gets a single activity.

  Raises `Ecto.NoResultsError` if the Activity does not exist.

  ## Examples

      iex> get_activity!(123)
      %Activity{}

      iex> get_activity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity!(id) do
    from(
      activity in Activity,
      join: category in assoc(activity, :category),
      preload: [category: category],
      where: activity.id == ^id
    )
    |> Repo.one!()
  end

  @doc """
  Creates a activity.

  ## Examples

      iex> create_activity(%{field: value})
      {:ok, %Activity{}}

      iex> create_activity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity(attrs \\ %{}) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a activity.

  ## Examples

      iex> update_activity(activity, %{field: new_value})
      {:ok, %Activity{}}

      iex> update_activity(activity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity(%Activity{} = activity, attrs) do
    activity
    |> Activity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a activity.

  ## Examples

      iex> delete_activity(activity)
      {:ok, %Activity{}}

      iex> delete_activity(activity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity(%Activity{} = activity) do
    Repo.delete(activity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity changes.

  ## Examples

      iex> change_activity(activity)
      %Ecto.Changeset{data: %Activity{}}

  """
  def change_activity(%Activity{} = activity, attrs \\ %{}) do
    Activity.changeset(activity, attrs)
  end
end
