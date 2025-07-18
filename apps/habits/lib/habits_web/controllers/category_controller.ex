defmodule HabitsWeb.CategoryController do
  use HabitsWeb, :controller

  alias Habits.Admin
  alias Habits.Admin.Activity
  alias Habits.Admin.Category
  alias HabitsWeb.CategoryView
  alias Common.NumberHelpers

  def index(conn, _params) do
    categories = Admin.list_categories()
    render(conn, "index.html", categories: categories)
  end

  defp split_activities_by_day(activities, days_map) do
    Enum.chunk_by(activities, fn activity -> activity.date end)
    |> Map.new(fn activities -> {Map.get(days_map, Enum.at(activities, 0).date), activities} end)
  end

  defp preload_category(activities, category_map) do
    Enum.map(activities, fn activity ->
      %Activity{activity | category: Map.get(category_map, activity.category_id)}
    end)
  end

  def create_category_activity_index(conn, _params) do
    today = Common.ModelHelpers.Date.today()
    yesterday = today |> Date.add(-1)
    day_before_yesterday = today |> Date.add(-2)

    activities_map =
      Admin.list_activities_after(day_before_yesterday)
      |> split_activities_by_day(
        Map.new([
          {today, :today},
          {yesterday, :yesterday},
          {day_before_yesterday, :day_before_yesterday}
        ])
      )

    todays_categorys_set =
      MapSet.new(Map.get(activities_map, :today, []), fn activity -> activity.category_id end)

    categories =
      Admin.list_categories()
      |> Enum.map(fn category ->
        %Category{
          category
          | has_daily_activity: MapSet.member?(todays_categorys_set, category.id)
        }
      end)

    category_map = Map.new(categories, fn category -> {category.id, category} end)

    render(conn, "create_category_activity_index.html",
      categories: categories,
      no_main_padding: true,
      body_class: "create-category-activity-index-page",
      todays_activities: preload_category(Map.get(activities_map, :today, []), category_map),
      yesterdays_activities:
        preload_category(Map.get(activities_map, :yesterday, []), category_map),
      day_before_yesterdays_activities:
        preload_category(Map.get(activities_map, :day_before_yesterday, []), category_map)
    )
  end

  def new(conn, _params) do
    changeset = Admin.change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    case Admin.create_category(category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "#{CategoryView.to_s(category)} created successfully.")
        |> redirect(to: Routes.category_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Admin.get_category!(id)

    today = Common.ModelHelpers.Date.today()

    start_date =
      today
      |> Date.shift(month: -3)
      |> Date.beginning_of_week(:monday)

    activities = Admin.activities_for_category(id, 12)

    activity_streak_activities =
      Admin.activity_streak_for_category(id, start_date)

    activity_streak =
      Date.range(start_date, today)
      |> Enum.reduce({[], activity_streak_activities}, fn date, {total, activities} ->
        activity = Enum.at(activities, 0, nil)

        cond do
          activity[:date] == date -> {total ++ [{date, activity.count}], Enum.drop(activities, 1)}
          true -> {total ++ [{date, 0}], activities}
        end
      end)
      |> elem(0)
      |> Enum.chunk_every(7)
      |> Enum.reverse()

    render(conn, "show.html",
      category: category,
      activity_streak: activity_streak,
      activities: activities
    )
  end

  def edit(conn, %{"id" => id}) do
    category = Admin.get_category!(id)
    changeset = Admin.change_category(category)
    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Admin.get_category!(id)

    case Admin.update_category(category, category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "#{CategoryView.to_s(category)} updated successfully.")
        |> redirect(to: Routes.category_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Admin.get_category!(id)
    {:ok, _category} = Admin.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: Routes.category_path(conn, :index))
  end

  def activities_list(conn, %{"id" => id, "limit" => limit}) do
    category = Admin.get_category!(id)

    activities =
      Admin.activities_for_category(id, NumberHelpers.string_to_integer_with_min(limit, 30, 1))

    render(conn, "activities_list.html",
      category: category,
      activities: activities,
      has_limit: true
    )
  end

  def activities_list(conn, %{"id" => id}) do
    category = Admin.get_category!(id)
    activities = Admin.activities_for_category(id)

    render(conn, "activities_list.html", category: category, activities: activities)
  end

  def calendar(conn, %{"id" => id}) do
    category = Admin.get_category!(id)

    today = Common.ModelHelpers.Date.today()

    start_date =
      today
      |> Date.shift(month: -12)
      |> Date.beginning_of_week(:monday)

    activity_streak =
      Admin.activity_streak_counts_for_category(id, start_date, today)
      |> Enum.chunk_every(7)
      |> Enum.reverse()

    render(conn, "show.html",
      category: category,
      activity_streak: activity_streak,
      is_calendar: true
    )
  end
end
