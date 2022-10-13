defmodule Pluginista.AdminFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pluginista.Admin` context.
  """

  @doc """
  Generate a group.
  """
  def group_fixture(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Pluginista.Admin.create_group()

    group
  end

  @doc """
  Generate a maker.
  """
  def maker_fixture(attrs \\ %{}) do
    {:ok, maker} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Pluginista.Admin.create_maker()

    maker
  end

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Pluginista.Admin.create_category()

    category
  end

  @doc """
  Generate a plugin.
  """
  def plugin_fixture(attrs \\ %{}) do
    {:ok, plugin} =
      attrs
      |> Enum.into(%{
        acquisition_date: ~D[2022-10-12],
        cost: "120.5",
        name: "some name"
      })
      |> Pluginista.Admin.create_plugin()

    plugin
  end
end
