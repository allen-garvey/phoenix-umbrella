defmodule HabitsWeb.ActivityController do
  use HabitsWeb, :controller

  alias Habits.Admin
  alias Habits.Api
  alias Habits.Admin.Activity
  alias Habits.Admin.Tag
  alias Common.NumberHelpers

  defp preload_categories(activities, categories) do
    category_map = Map.new(categories, fn category -> {category.id, category} end)

    Enum.map(activities, fn activity ->
      tag = %Tag{activity.tag | category: Map.get(category_map, activity.tag.category_id)}
      %Activity{activity | tag: tag}
    end)
  end

  def search(conn, %{"q" => ""}) do
    search_default_page(conn)
  end

  def search(conn, %{"q" => query, "category_id" => category_id}) do
    categories = Admin.list_categories()

    activities =
      Admin.activities_for_query(query, category_id)
      |> preload_categories(categories)

    render(conn, "search.html",
      activities: activities,
      query: query,
      category_id: category_id,
      categories: categories
    )
  end

  def search(conn, _params) do
    search_default_page(conn)
  end

  defp search_default_page(conn) do
    categories = Admin.list_categories()

    render(conn, "search.html", query: "", categories: categories, category_id: nil)
  end

  def related_fields() do
    [
      categories: Admin.list_categories()
    ]
  end

  def index(conn, %{"limit" => limit}) do
    activities = Admin.list_activities(NumberHelpers.string_to_integer_with_min(limit, 30, 1))
    render(conn, "index.html", activities: activities, has_limit: true)
  end

  def index(conn, _params) do
    activities = Admin.list_activities()
    render(conn, "index.html", activities: activities)
  end

  def new(conn, %{"duplicate" => id}) do
    activity = Admin.get_activity!(id)

    Admin.change_activity(%Activity{
      tag: activity.tag,
      tag_id: activity.tag_id,
      description: activity.description,
      date: Common.ModelHelpers.Date.today()
    })
    |> new_route(conn)
  end

  def new(conn, %{"category" => category_id}) do
    tag = %Tag{id: Admin.get_recent_popular_tag_id(category_id), category_id: category_id}

    Admin.change_activity(%Activity{
      tag_id: tag.id,
      tag: tag
    })
    |> new_route(conn)
  end

  def new(conn, params) do
    date =
      case Date.from_iso8601(params["date"] || "") do
        {:ok, date} -> date
        {:error, _} -> Common.ModelHelpers.Date.today()
      end

    category_id = Admin.get_recent_popular_category_id()
    tag = %Tag{id: Admin.get_recent_popular_tag_id(category_id), category_id: category_id}

    Admin.change_activity(%Activity{
      tag: tag,
      tag_id: tag.id,
      date: date
    })
    |> new_route(conn)
  end

  defp new_route(changeset, conn) do
    tag = Ecto.Changeset.get_field(changeset, :tag)
    IO.inspect(tag)
    tags = Api.list_tags_for_category(tag.category_id)

    render(conn, "new.html", [changeset: changeset, tags: tags] ++ related_fields())
  end

  defp create_succeeded(conn, activity, "true") do
    tag = Admin.get_tag!(activity.tag_id)
    tags = Admin.list_tags_for_category(tag.category_id)

    changeset =
      Admin.change_activity(%Activity{
        tag: tag,
        date: activity.date,
        tag_id: activity.tag_id,
        description: activity.description
      })

    render(conn, "new.html", [changeset: changeset, tags: tags] ++ related_fields())
  end

  defp create_succeeded(conn, activity, _save_another) do
    tag = Admin.get_tag!(activity.tag_id)

    redirect(conn, to: Routes.category_path(conn, :show, tag.category_id))
  end

  def create(conn, %{"activity" => activity_params} = params) do
    case Admin.create_activity(activity_params) do
      {:ok, activity} ->
        conn
        |> put_flash(:info, "Activity created successfully.")
        |> create_succeeded(activity, params["save_another"])

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", [changeset: changeset, tags: []] ++ related_fields())
    end
  end

  def show(conn, %{"id" => id}) do
    activity = Admin.get_activity!(id)
    render(conn, "show.html", activity: activity)
  end

  def edit(conn, %{"id" => id, "redirect" => redirect_action}) do
    edit_page_initial(conn, id, redirect_action)
  end

  def edit(conn, %{"id" => id}) do
    edit_page_initial(conn, id, nil)
  end

  defp edit_page_initial(conn, id, redirect_action) do
    activity = Admin.get_activity!(id)
    changeset = Admin.change_activity(activity)

    edit_page(conn, activity, changeset, redirect_action)
  end

  defp edit_page(conn, activity, changeset, redirect_action) do
    tags = Api.list_tags_for_category(activity.tag.category_id)

    render(
      conn,
      "edit.html",
      [activity: activity, changeset: changeset, redirect: redirect_action, tags: tags] ++
        related_fields()
    )
  end

  def update(conn, %{"id" => id, "activity" => activity_params, "redirect" => redirect_action}) do
    update_action(conn, id, activity_params, redirect_action)
  end

  def update(conn, %{"id" => id, "activity" => activity_params}) do
    update_action(conn, id, activity_params, nil)
  end

  defp update_action(conn, id, activity_params, redirect_action) do
    activity = Admin.get_activity!(id)

    case Admin.update_activity(activity, activity_params) do
      {:ok, _activity} ->
        conn
        |> put_flash(:info, "Activity updated successfully.")
        |> redirect(to: update_redirect_path(conn, activity, redirect_action))

      {:error, %Ecto.Changeset{} = changeset} ->
        edit_page(conn, activity, changeset, redirect_action)
    end
  end

  defp update_redirect_path(conn, activity, redirect_action) do
    case redirect_action do
      "category" -> Routes.category_path(conn, :activities_list, activity.tag.category_id)
      "tag" -> Routes.tag_path(conn, :activities_list, activity.tag_id)
      "home" -> Routes.category_path(conn, :create_category_activity_index)
      _ -> Routes.activity_path(conn, :index)
    end
  end

  def delete(conn, %{"id" => id}) do
    activity = Admin.get_activity!(id)
    {:ok, _activity} = Admin.delete_activity(activity)

    conn
    |> put_flash(:info, "Activity deleted successfully.")
    |> redirect(to: Routes.activity_path(conn, :index))
  end
end
