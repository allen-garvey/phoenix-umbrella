defmodule HabitsWeb.ActivityControllerTest do
  use HabitsWeb.ConnCase

  import Habits.AdminFixtures

  @create_attrs %{date: ~D[2022-12-04], description: "some description", title: "some title"}
  @update_attrs %{date: ~D[2022-12-05], description: "some updated description", title: "some updated title"}
  @invalid_attrs %{date: nil, description: nil, title: nil}

  describe "index" do
    test "lists all activities", %{conn: conn} do
      conn = get(conn, Routes.activity_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Activities"
    end
  end

  describe "new activity" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.activity_path(conn, :new))
      assert html_response(conn, 200) =~ "New Activity"
    end
  end

  describe "create activity" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.activity_path(conn, :create), activity: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.activity_path(conn, :show, id)

      conn = get(conn, Routes.activity_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Activity"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.activity_path(conn, :create), activity: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Activity"
    end
  end

  describe "edit activity" do
    setup [:create_activity]

    test "renders form for editing chosen activity", %{conn: conn, activity: activity} do
      conn = get(conn, Routes.activity_path(conn, :edit, activity))
      assert html_response(conn, 200) =~ "Edit Activity"
    end
  end

  describe "update activity" do
    setup [:create_activity]

    test "redirects when data is valid", %{conn: conn, activity: activity} do
      conn = put(conn, Routes.activity_path(conn, :update, activity), activity: @update_attrs)
      assert redirected_to(conn) == Routes.activity_path(conn, :show, activity)

      conn = get(conn, Routes.activity_path(conn, :show, activity))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, activity: activity} do
      conn = put(conn, Routes.activity_path(conn, :update, activity), activity: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Activity"
    end
  end

  describe "delete activity" do
    setup [:create_activity]

    test "deletes chosen activity", %{conn: conn, activity: activity} do
      conn = delete(conn, Routes.activity_path(conn, :delete, activity))
      assert redirected_to(conn) == Routes.activity_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.activity_path(conn, :show, activity))
      end
    end
  end

  defp create_activity(_) do
    activity = activity_fixture()
    %{activity: activity}
  end
end
