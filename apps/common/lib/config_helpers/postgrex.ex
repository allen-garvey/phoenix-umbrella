defmodule Common.ConfigHelpers.Postgrex do
  Postgrex.Types.define(
    Common.PostgrexTypes,
    [] ++ Ecto.Adapters.Postgres.extensions(),
    json: Jason
  )
end
