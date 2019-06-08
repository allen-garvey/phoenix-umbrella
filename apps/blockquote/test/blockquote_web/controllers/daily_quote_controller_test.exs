defmodule BlockquoteWeb.DailyQuoteControllerTest do
  use BlockquoteWeb.ConnCase

  alias Blockquote.Admin

  @create_attrs %{date_used: ~D[2010-04-17]}
  @update_attrs %{date_used: ~D[2011-05-18]}
  @invalid_attrs %{date_used: nil}

  def fixture(:daily_quote) do
    {:ok, daily_quote} = Admin.create_daily_quote(@create_attrs)
    daily_quote
  end

  describe "index" do
    test "lists all daily_quotes", %{conn: conn} do
      conn = get conn, daily_quote_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Daily quotes"
    end
  end

  describe "new daily_quote" do
    test "renders form", %{conn: conn} do
      conn = get conn, daily_quote_path(conn, :new)
      assert html_response(conn, 200) =~ "New Daily quote"
    end
  end

  describe "create daily_quote" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, daily_quote_path(conn, :create), daily_quote: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == daily_quote_path(conn, :show, id)

      conn = get conn, daily_quote_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Daily quote"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, daily_quote_path(conn, :create), daily_quote: @invalid_attrs
      assert html_response(conn, 200) =~ "New Daily quote"
    end
  end

  describe "edit daily_quote" do
    setup [:create_daily_quote]

    test "renders form for editing chosen daily_quote", %{conn: conn, daily_quote: daily_quote} do
      conn = get conn, daily_quote_path(conn, :edit, daily_quote)
      assert html_response(conn, 200) =~ "Edit Daily quote"
    end
  end

  describe "update daily_quote" do
    setup [:create_daily_quote]

    test "redirects when data is valid", %{conn: conn, daily_quote: daily_quote} do
      conn = put conn, daily_quote_path(conn, :update, daily_quote), daily_quote: @update_attrs
      assert redirected_to(conn) == daily_quote_path(conn, :show, daily_quote)

      conn = get conn, daily_quote_path(conn, :show, daily_quote)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, daily_quote: daily_quote} do
      conn = put conn, daily_quote_path(conn, :update, daily_quote), daily_quote: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Daily quote"
    end
  end

  describe "delete daily_quote" do
    setup [:create_daily_quote]

    test "deletes chosen daily_quote", %{conn: conn, daily_quote: daily_quote} do
      conn = delete conn, daily_quote_path(conn, :delete, daily_quote)
      assert redirected_to(conn) == daily_quote_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, daily_quote_path(conn, :show, daily_quote)
      end
    end
  end

  defp create_daily_quote(_) do
    daily_quote = fixture(:daily_quote)
    {:ok, daily_quote: daily_quote}
  end
end
