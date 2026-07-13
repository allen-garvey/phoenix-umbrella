defmodule SupersearchWeb.EngineView do
  use SupersearchWeb, :view
  alias Supersearch.Admin.Engine

  def to_query_url(%Engine{} = engine, query) when is_binary(query) do
    String.replace(engine.url, "{$cleanedQuery}", URI.encode(query))
  end
end
