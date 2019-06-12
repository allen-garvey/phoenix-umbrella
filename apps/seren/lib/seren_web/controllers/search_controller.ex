defmodule SerenWeb.SearchController do
  use SerenWeb, :controller

  alias Seren.Player

  action_fallback SerenWeb.FallbackController

  def tracks_for(conn, %{"q" => query}) do
    tracks = Player.tracks_for_search(query, 1000)
    conn
      |> put_view(SerenWeb.TrackView)
      |> SerenWeb.TrackController.index_page(tracks)
  end

end
