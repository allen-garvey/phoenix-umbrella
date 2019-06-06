defmodule BooklistWeb.BookLocationControllerTest do
  use BooklistWeb.ConnCase

  alias Booklist.Admin

  @create_attrs %{call_number: "some call_number"}
  @update_attrs %{call_number: "some updated call_number"}
  @invalid_attrs %{call_number: nil}

  def fixture(:book_location) do
    {:ok, book_location} = Admin.create_book_location(@create_attrs)
    book_location
  end

  describe "index" do
    test "lists all book_locations", %{conn: conn} do
      conn = get(conn, Routes.book_location_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Book locations"
    end
  end

  describe "new book_location" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.book_location_path(conn, :new))
      assert html_response(conn, 200) =~ "New Book location"
    end
  end

  describe "create book_location" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.book_location_path(conn, :create), book_location: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.book_location_path(conn, :show, id)

      conn = get(conn, Routes.book_location_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Book location"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.book_location_path(conn, :create), book_location: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Book location"
    end
  end

  describe "edit book_location" do
    setup [:create_book_location]

    test "renders form for editing chosen book_location", %{conn: conn, book_location: book_location} do
      conn = get(conn, Routes.book_location_path(conn, :edit, book_location))
      assert html_response(conn, 200) =~ "Edit Book location"
    end
  end

  describe "update book_location" do
    setup [:create_book_location]

    test "redirects when data is valid", %{conn: conn, book_location: book_location} do
      conn = put(conn, Routes.book_location_path(conn, :update, book_location), book_location: @update_attrs)
      assert redirected_to(conn) == Routes.book_location_path(conn, :show, book_location)

      conn = get(conn, Routes.book_location_path(conn, :show, book_location))
      assert html_response(conn, 200) =~ "some updated call_number"
    end

    test "renders errors when data is invalid", %{conn: conn, book_location: book_location} do
      conn = put(conn, Routes.book_location_path(conn, :update, book_location), book_location: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Book location"
    end
  end

  describe "delete book_location" do
    setup [:create_book_location]

    test "deletes chosen book_location", %{conn: conn, book_location: book_location} do
      conn = delete(conn, Routes.book_location_path(conn, :delete, book_location))
      assert redirected_to(conn) == Routes.book_location_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.book_location_path(conn, :show, book_location))
      end
    end
  end

  defp create_book_location(_) do
    book_location = fixture(:book_location)
    {:ok, book_location: book_location}
  end
end
