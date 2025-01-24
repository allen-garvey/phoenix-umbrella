defmodule BlockquoteWeb.ApiDailyQuoteController do
  use BlockquoteWeb, :controller

  alias Blockquote.Api

  def get_daily_quote(conn, _params) do
    quote = get_todays_quote()
    render(conn, "show.json", quote: quote)
  end

  @doc """
  Gets today's daily quote quote
  Note if changing this function it is also used by the startpage app
  """
  def get_todays_quote do
    case Api.get_todays_daily_quote() do
      # no quote for today yet
      nil ->
        quote = Api.get_random_quote!()
        daily_quote_params = %{quote_id: quote.id, date_used: Common.ModelHelpers.Date.today()}

        case Blockquote.Admin.create_daily_quote(daily_quote_params) do
          # not really important if insert fails or not (such as due to race condition with someone else)
          # since if it does fail, we still have a quote to show (even if it is the "wrong" one),
          # and on refresh the "right" one will be retrieved anyway
          _ -> quote
        end

      # daily quote already saved
      daily_quote ->
        daily_quote.quote
    end
  end
end
