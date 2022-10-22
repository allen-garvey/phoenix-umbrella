defmodule Pluginista.Reports do
    @moduledoc """
    The Reports context.
    """
  
    import Ecto.Query, warn: false
    alias Pluginista.Repo

    alias Pluginista.Admin.Plugin

    def years_summary() do
        from(
            plugin in Plugin,
            group_by: fragment("EXTRACT(year FROM ?)", plugin.acquisition_date),
            select: %{year: fragment("EXTRACT(year FROM ?)", plugin.acquisition_date), total: sum(plugin.cost), count: count(plugin.id)},
            order_by: [desc: fragment("EXTRACT(year FROM ?)", plugin.acquisition_date)]
        )
        |> Repo.all
    end

    def year_summary(year) when is_integer(year) do
        from(
            plugin in Plugin,
            where: fragment("EXTRACT(year FROM ?)", plugin.acquisition_date) == ^year,
            select: %{total: sum(plugin.cost), count: count(plugin.id)}
        )
        |> Repo.one!
    end

    def sum_plugins_cost(plugins) do
        plugins 
        |> Enum.reduce(Decimal.new(0), fn plugin, total -> Decimal.add(total, plugin.cost) end)
    end

end