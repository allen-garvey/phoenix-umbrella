defmodule Pluginista.Api do
    @moduledoc """
    The Api context.
    """
  
    import Ecto.Query, warn: false
    alias Grenadier.Repo
  
    alias Pluginista.Admin.Category
  
    @doc """
    Returns the list of categories.
  
    ## Examples
  
        iex> list_categories()
        [%Category{}, ...]
  
    """
    def list_categories do
      from(Category, order_by: :name)
      |> Repo.all
    end
  
    alias Pluginista.Admin.Plugin

    defp list_plugins_query do
      from(
        plugin in Plugin,
        left_join: plugin_categories in assoc(plugin, :plugin_categories),
        preload: [plugin_categories: plugin_categories]
      )
    end

  
    @doc """
    Returns the list of plugins.
  
    ## Examples
  
        iex> list_plugins()
        [%Plugin{}, ...]
  
    """
    def list_plugins do
      list_plugins_query()
      |> Repo.all
    end

    def list_plugins_for_maker(maker_id) do
      list_plugins_query()
      |> where([plugin], plugin.maker_id == ^maker_id)
      |> Repo.all
    end

    def list_plugins_for_group(group_id) do
      list_plugins_query()
      |> where([plugin], plugin.group_id == ^group_id)
      |> Repo.all
    end

    def list_plugins_for_category(category_id) do
      from(
        plugin in Plugin,
        join: plugin_categories in assoc(plugin, :plugin_categories),
        preload: [plugin_categories: plugin_categories],
        where: plugin_categories.category_id == ^category_id
      )
      |> Repo.all
    end
  end
  