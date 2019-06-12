defmodule SerenWeb.ComposerController do
  use SerenWeb, :controller

  alias Seren.Player
  alias Seren.Player.Composer

  action_fallback SerenWeb.FallbackController

  def index(conn, _params) do
    composers = Player.list_composers()
    render(conn, "index.json", composers: composers)
  end

  def tracks_for(conn, %{"id" => id}) do
    tracks = Player.tracks_for_composer(id)
    conn
      |> put_view(SerenWeb.TrackView)
      |> SerenWeb.TrackController.index_page(tracks)
  end

  def create(conn, %{"composer" => composer_params}) do
    with {:ok, %Composer{} = composer} <- Player.create_composer(composer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", composer_path(conn, :show, composer))
      |> render("show.json", composer: composer)
    end
  end

  def show(conn, %{"id" => id}) do
    composer = Player.get_composer!(id)
    render(conn, "show.json", composer: composer)
  end

  def update(conn, %{"id" => id, "composer" => composer_params}) do
    composer = Player.get_composer!(id)

    with {:ok, %Composer{} = composer} <- Player.update_composer(composer, composer_params) do
      render(conn, "show.json", composer: composer)
    end
  end

  def delete(conn, %{"id" => id}) do
    composer = Player.get_composer!(id)
    with {:ok, %Composer{}} <- Player.delete_composer(composer) do
      send_resp(conn, :no_content, "")
    end
  end
end
