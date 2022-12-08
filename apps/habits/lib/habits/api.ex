defmodule Habits.Api do
  @moduledoc """
  The Api context.
  """

  import Ecto.Query, warn: false
  alias Habits.Repo

  alias Habits.Admin.Activity

  @doc """
  Returns the list of activities between to and from dates.
  """
  def list_activities(from_date, to_date) do
    from(
      activity in Activity,
      join: category in assoc(activity, :category),
      where: activity.date >= ^from_date and activity.date <= ^to_date,
      order_by: [activity.date, category.name]
    )
    |> Repo.all
  end
end
  