defmodule Artour.ApiPostImageController do
  use Artour.Web, :controller

  plug(:put_view, json: CommonWeb.ApiGenericView)

  def delete(conn, %{"id" => id}) do
    Artour.Admin.delete_post_image_by_id(id)

    conn
    |> render("ok.json", message: "Post image #{id} deleted.")
  end
end
