defmodule BlockquoteWeb.ApiDailyQuoteController do
  use BlockquoteWeb, :controller

  alias Blockquote.Api

  def get_daily_quote(conn, _params) do
    case Api.get_todays_daily_quote() do
      # no quote for today yet
      nil ->
        quote = Api.get_random_quote!()
        daily_quote_params = %{quote_id: quote.id, date_used: Date.utc_today}
        case Blockquote.Admin.create_daily_quote(daily_quote_params) do
          # not really important if insert fails or not (such as due to race condition with someone else)
          # since if it does fail, we still have a quote to show (even if it is the "wrong" one), 
          # and on refresh the "right" one will be retrieved anyway
          _ -> render(conn, "show.json", quote: quote)
        end
      # daily quote already saved
      daily_quote ->
        render(conn, "show.json", quote: daily_quote.quote)
    end
  end
end
