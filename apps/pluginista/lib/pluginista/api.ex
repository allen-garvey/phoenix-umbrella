defmodule Pluginista.Api do
    @moduledoc """
    The Api context.
    """
  
    import Ecto.Query, warn: false
    alias Pluginista.Repo
  
    alias Pluginista.Admin.Category
  
    @doc """
    Returns the list of categories.
  
    ## Examples
  
        iex> list_categories()
        [%Category{}, ...]
  
    """
    def list_categories do
      from(Category)
      |> Repo.all
    end
  
    alias Pluginista.Admin.Plugin

  
    @doc """
    Returns the list of plugins.
  
    ## Examples
  
        iex> list_plugins()
        [%Plugin{}, ...]
  
    """
    def list_plugins do
      from(
        plugin in Plugin,
        left_join: plugin_categories in assoc(plugin, :plugin_categories),
        preload: [plugin_categories: plugin_categories],
      )
      |> Repo.all
    end
  end
  