defmodule HabitsWeb.ActivityController do
  use HabitsWeb, :controller

  alias Habits.Admin
  alias Habits.Admin.Activity

  def related_fields() do
    [
      categories: Admin.list_categories() |> HabitsWeb.CategoryView.map_for_form,
    ]
  end

  def index(conn, _params) do
    activities = Admin.list_activities()
    render(conn, "index.html", activities: activities)
  end

  def new(conn, %{"duplicate" => id}) do
    activity = Admin.get_activity!(id)
    changeset = Admin.change_activity(%Activity{
      category_id: activity.category_id,
      title: activity.title,
      description: activity.description,
      date: Common.ModelHelpers.Date.today(),
    })
    render(conn, "new.html", [changeset: changeset] ++ related_fields())
  end

  def new(conn, _params) do
    changeset = Admin.change_activity(%Activity{})
    render(conn, "new.html", [changeset: changeset] ++ related_fields())
  end

  def create_succeeded(conn, activity, "true") do
    changeset = Admin.change_activity(%Activity{ 
      category_id: activity.category_id,
      date: activity.date,
      title: activity.title, 
    })
    render(conn, "new.html", [changeset: changeset] ++ related_fields())
  end

  def create_succeeded(conn, _activity, _save_another) do
    redirect(conn, to: Routes.activity_path(conn, :index))
  end

  def create(conn, %{"activity" => activity_params} = params) do
    case Admin.create_activity(activity_params) do
      {:ok, activity} ->
        conn
        |> put_flash(:info, "Activity created successfully.")
        |> create_succeeded(activity, params["save_another"])

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", [changeset: changeset] ++ related_fields())
    end
  end

  def show(conn, %{"id" => id}) do
    activity = Admin.get_activity!(id)
    render(conn, "show.html", activity: activity)
  end

  def edit(conn, %{"id" => id}) do
    activity = Admin.get_activity!(id)
    changeset = Admin.change_activity(activity)
    render(conn, "edit.html", [activity: activity, changeset: changeset] ++ related_fields())
  end

  def update(conn, %{"id" => id, "activity" => activity_params}) do
    activity = Admin.get_activity!(id)

    case Admin.update_activity(activity, activity_params) do
      {:ok, _activity} ->
        conn
        |> put_flash(:info, "Activity updated successfully.")
        |> redirect(to: Routes.activity_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", [activity: activity, changeset: changeset] ++ related_fields())
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
