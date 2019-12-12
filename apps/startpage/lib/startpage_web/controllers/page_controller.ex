defmodule StartpageWeb.PageController do
  use StartpageWeb, :controller

  def index(conn, _params) do
    folders = Startpage.Admin.list_folders_in_order()
    quote = BlockquoteWeb.ApiDailyQuoteController.get_todays_quote()
    daily_quote = BlockquoteWeb.ApiDailyQuoteView.render("quote.json", %{quote: quote})
    render(conn, "index.html", folders: folders, daily_quote: daily_quote)
  end
end
