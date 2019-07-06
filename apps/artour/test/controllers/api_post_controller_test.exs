defmodule Artour.ApiPostControllerTest do
  use Artour.ConnCase

  alias Artour.ApiPost
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_post_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    api_post = Repo.insert! %ApiPost{}
    conn = get conn, api_post_path(conn, :show, api_post)
    assert json_response(conn, 200)["data"] == %{"id" => api_post.id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_post_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, api_post_path(conn, :create), api_post: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ApiPost, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, api_post_path(conn, :create), api_post: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    api_post = Repo.insert! %ApiPost{}
    conn = put conn, api_post_path(conn, :update, api_post), api_post: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ApiPost, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    api_post = Repo.insert! %ApiPost{}
    conn = put conn, api_post_path(conn, :update, api_post), api_post: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    api_post = Repo.insert! %ApiPost{}
    conn = delete conn, api_post_path(conn, :delete, api_post)
    assert response(conn, 204)
    refute Repo.get(ApiPost, api_post.id)
  end
end
