defmodule MovielistWeb.MovieControllerTest do
  use MovielistWeb.ConnCase

  alias Movielist.Admin

  @create_attrs %{home_release_date: ~D[2010-04-17], is_active: true, pre_rating: 42, theater_release_date: ~D[2010-04-17], title: "some title"}
  @update_attrs %{home_release_date: ~D[2011-05-18], is_active: false, pre_rating: 43, theater_release_date: ~D[2011-05-18], title: "some updated title"}
  @invalid_attrs %{home_release_date: nil, is_active: nil, pre_rating: nil, theater_release_date: nil, title: nil}

  def fixture(:movie) do
    {:ok, movie} = Admin.create_movie(@create_attrs)
    movie
  end

  describe "index" do
    test "lists all movies", %{conn: conn} do
      conn = get(conn, Routes.movie_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Movies"
    end
  end

  describe "new movie" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.movie_path(conn, :new))
      assert html_response(conn, 200) =~ "New Movie"
    end
  end

  describe "create movie" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.movie_path(conn, :create), movie: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.movie_path(conn, :show, id)

      conn = get(conn, Routes.movie_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Movie"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.movie_path(conn, :create), movie: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Movie"
    end
  end

  describe "edit movie" do
    setup [:create_movie]

    test "renders form for editing chosen movie", %{conn: conn, movie: movie} do
      conn = get(conn, Routes.movie_path(conn, :edit, movie))
      assert html_response(conn, 200) =~ "Edit Movie"
    end
  end

  describe "update movie" do
    setup [:create_movie]

    test "redirects when data is valid", %{conn: conn, movie: movie} do
      conn = put(conn, Routes.movie_path(conn, :update, movie), movie: @update_attrs)
      assert redirected_to(conn) == Routes.movie_path(conn, :show, movie)

      conn = get(conn, Routes.movie_path(conn, :show, movie))
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, movie: movie} do
      conn = put(conn, Routes.movie_path(conn, :update, movie), movie: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Movie"
    end
  end

  describe "delete movie" do
    setup [:create_movie]

    test "deletes chosen movie", %{conn: conn, movie: movie} do
      conn = delete(conn, Routes.movie_path(conn, :delete, movie))
      assert redirected_to(conn) == Routes.movie_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.movie_path(conn, :show, movie))
      end
    end
  end

  defp create_movie(_) do
    movie = fixture(:movie)
    {:ok, movie: movie}
  end
end
