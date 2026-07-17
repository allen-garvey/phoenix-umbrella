defmodule SupersearchWeb.EngineView do
  use SupersearchWeb, :view
  alias Supersearch.Admin.Engine

  def to_query_url(%Engine{} = engine, query) when is_binary(query) do
    String.replace(engine.url, "{$cleanedQuery}", URI.encode(query))
  end

  def render("engines.json", %{engines: engines}) do
    %{data: Enum.map(engines, &engine_to_map/1)}
  end

  def engine_to_map(engine) do
    %{
      id: engine.id,
      name: engine.name,
      url: engine.url
    }
  end
end
