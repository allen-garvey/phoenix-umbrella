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
      %Activity{activity | category: Map.get(category_map, activity.tag.category_id)}
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
      MapSet.new(Map.get(activities_map, :today, []), fn activity -> activity.tag.category_id end)

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
    tags = Admin.list_tags_for_category(id)

    today = Common.ModelHelpers.Date.today()

    start_date =
      today
      |> Date.shift(month: -2)

    activities = Admin.activities_for_category(id, 12)

    {activity_streak, _adjusted_start_date} =
      get_activity_streak(id, start_date, today)

    render(conn, "show.html",
      category: category,
      activity_streak: activity_streak,
      activities: activities,
      tags: tags
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
      all_activities_path: Routes.category_path(conn, :activities_list, category),
      edit_redirect: "category",
      title: HabitsWeb.CategoryView.category_link_title(conn, category)
    )
  end

  def activities_list(conn, %{"id" => id}) do
    category = Admin.get_category!(id)
    activities = Admin.activities_for_category(id)

    render(conn, "activities_list.html",
      category: category,
      activities: activities,
      edit_redirect: "category",
      title: HabitsWeb.CategoryView.category_link_title(conn, category)
    )
  end

  def summary(conn, %{"id" => category_id, "from" => from, "to" => to, "tags" => checked_tags}) do
    case {Date.from_iso8601(from), Date.from_iso8601(to)} do
      {{:ok, start_date}, {:ok, end_date}} ->
        tags = Habits.Api.list_tags_for_category(category_id)

        checked_tags_set =
          Enum.map(checked_tags, fn id ->
            case Integer.parse(id) do
              {number, ""} -> number
              _ -> nil
            end
          end)
          |> Enum.filter(fn value -> !is_nil(value) end)
          |> MapSet.new()

        summary_page(conn, category_id, start_date, end_date, checked_tags_set, tags)

      _ ->
        summary(conn, %{"id" => category_id})
    end
  end

  def summary(conn, %{"id" => category_id}) do
    today = Common.ModelHelpers.Date.today()
    tags = Habits.Api.list_tags_for_category(category_id)
    checked_tags = tags_to_set(tags)

    start_date =
      today
      |> Date.shift(month: -12)

    summary_page(conn, category_id, start_date, today, checked_tags, tags)
  end

  defp summary_page(
         conn,
         category_id,
         %Date{} = start_date,
         %Date{} = end_date,
         %MapSet{} = checked_tags,
         tags
       ) do
    category = Admin.get_category!(category_id)

    {activity_streak, adjusted_start_date} =
      get_activity_streak(
        category_id,
        start_date,
        end_date,
        checked_tags,
        MapSet.equal?(checked_tags, tags_to_set(tags))
      )

    render(conn, "show.html",
      category: category,
      activity_streak: activity_streak,
      is_summary: true,
      summary_tags: tags,
      checked_summary_tags: checked_tags,
      start_date: adjusted_start_date,
      end_date: end_date
    )
  end

  defp tags_to_set(tags) do
    MapSet.new(tags, fn tag -> tag.id end)
  end

  defp get_activity_streak(
         category_id,
         %Date{} = start_date,
         %Date{} = end_date
       ) do
    get_activity_streak(category_id, start_date, end_date, MapSet.new(), true)
  end

  defp get_activity_streak(
         category_id,
         %Date{} = start_date,
         %Date{} = end_date,
         %MapSet{} = checked_tags,
         are_all_tags_selected
       ) do
    adjusted_start_date =
      start_date
      |> Date.beginning_of_week(:monday)

    activity_streak_activities =
      case are_all_tags_selected do
        true ->
          Admin.activity_streak_for_category(category_id, adjusted_start_date, end_date)

        false ->
          Admin.activity_streak_for_category(
            category_id,
            adjusted_start_date,
            end_date,
            MapSet.to_list(checked_tags)
          )
      end

    activity_streak =
      Date.range(end_date, adjusted_start_date, -1)
      |> Enum.reduce({[], activity_streak_activities}, fn date, {date_counts, activities} ->
        activity = Enum.at(activities, 0, nil)

        case activity[:date] == date do
          true -> {[{date, activity.count}] ++ date_counts, Enum.drop(activities, 1)}
          false -> {[{date, 0}] ++ date_counts, activities}
        end
      end)
      |> elem(0)
      |> Enum.chunk_every(7)
      |> Enum.reverse()

    {activity_streak, adjusted_start_date}
  end
end
