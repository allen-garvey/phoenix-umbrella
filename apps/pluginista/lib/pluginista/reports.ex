defmodule Pluginista.Reports do
    @moduledoc """
    The Reports context.
    """
  
    import Ecto.Query, warn: false
    alias Grenadier.Repo

    alias Pluginista.Admin.Plugin
    alias Pluginista.Admin.Maker

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

    def plugin_stats_for_maker(maker_id) do
        from(
            plugin in Plugin,
            where: plugin.maker_id == ^maker_id,
            select: %{total_spent: sum(plugin.cost), count: count(plugin.id)}
        )
        |> Repo.one!
    end

    def plugin_stats_for_group(group_id) do
        from(
            plugin in Plugin,
            where: plugin.group_id == ^group_id,
            select: %{total_spent: sum(plugin.cost), count: count(plugin.id)}
        )
        |> Repo.one!
    end

    def plugin_stats_for_category(category_id) do
        from(
            plugin in Plugin,
            join: plugin_categories in assoc(plugin, :plugin_categories),
            where: plugin_categories.category_id == ^category_id,
            select: %{total_spent: sum(plugin.cost), count: count(plugin.id)}
        )
        |> Repo.one!
    end

    def makers_stats() do
        from(
            maker in Maker,
            join: plugin in assoc(maker, :plugins),
            group_by: [maker.id, maker.name],
            order_by: [maker.name],
            select: %{
                id: maker.id, 
                name: maker.name, 
                count: count(plugin.id),
                total: sum(plugin.cost)
            }
        )
        |> Repo.all
    end

end