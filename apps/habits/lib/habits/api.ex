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
      where: activity.date >= ^from_date and activity.date < ^to_date,
      order_by: [asc: activity.date]
    )
    |> Repo.all
  end
end
  