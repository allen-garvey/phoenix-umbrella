defmodule MovielistWeb.RatingControllerTest do
  use MovielistWeb.ConnCase

  alias Movielist.Admin

  @create_attrs %{date_scored: ~D[2010-04-17], score: 42}
  @update_attrs %{date_scored: ~D[2011-05-18], score: 43}
  @invalid_attrs %{date_scored: nil, score: nil}

  def fixture(:rating) do
    {:ok, rating} = Admin.create_rating(@create_attrs)
    rating
  end

  describe "index" do
    test "lists all ratings", %{conn: conn} do
      conn = get(conn, Routes.rating_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Ratings"
    end
  end

  describe "new rating" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.rating_path(conn, :new))
      assert html_response(conn, 200) =~ "New Rating"
    end
  end

  describe "create rating" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.rating_path(conn, :create), rating: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.rating_path(conn, :show, id)

      conn = get(conn, Routes.rating_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Rating"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.rating_path(conn, :create), rating: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Rating"
    end
  end

  describe "edit rating" do
    setup [:create_rating]

    test "renders form for editing chosen rating", %{conn: conn, rating: rating} do
      conn = get(conn, Routes.rating_path(conn, :edit, rating))
      assert html_response(conn, 200) =~ "Edit Rating"
    end
  end

  describe "update rating" do
    setup [:create_rating]

    test "redirects when data is valid", %{conn: conn, rating: rating} do
      conn = put(conn, Routes.rating_path(conn, :update, rating), rating: @update_attrs)
      assert redirected_to(conn) == Routes.rating_path(conn, :show, rating)

      conn = get(conn, Routes.rating_path(conn, :show, rating))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, rating: rating} do
      conn = put(conn, Routes.rating_path(conn, :update, rating), rating: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Rating"
    end
  end

  describe "delete rating" do
    setup [:create_rating]

    test "deletes chosen rating", %{conn: conn, rating: rating} do
      conn = delete(conn, Routes.rating_path(conn, :delete, rating))
      assert redirected_to(conn) == Routes.rating_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.rating_path(conn, :show, rating))
      end
    end
  end

  defp create_rating(_) do
    rating = fixture(:rating)
    {:ok, rating: rating}
  end
end
