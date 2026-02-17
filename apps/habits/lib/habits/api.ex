defmodule Habits.Api do
  @moduledoc """
  The Api context.
  """

  import Ecto.Query, warn: false
  alias Grenadier.Repo

  alias Habits.Admin.Activity
  alias Habits.Admin.Tag

  @doc """
  Returns the list of activities between to and from dates.
  """
  def list_activities(from_date, to_date) do
    from(
      activity in Activity,
      join: category in assoc(activity, :category),
      join: tag in assoc(activity, :tag),
      where: activity.date >= ^from_date and activity.date <= ^to_date,
      preload: [tag: tag],
      order_by: [activity.date, category.name]
    )
    |> Repo.all()
  end

  def list_tags_for_category(category_id) do
    from(
      tag in Tag,
      where: tag.category_id == ^category_id,
      order_by: [:name]
    )
    |> Repo.all()
  end
end
