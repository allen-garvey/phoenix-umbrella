defmodule Habits.AdminFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Habits.Admin` context.
  """

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        color: "some color",
        name: "some name"
      })
      |> Habits.Admin.create_category()

    category
  end
end
