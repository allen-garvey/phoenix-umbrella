defmodule Photog.ApiFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Photog.Api` context.
  """

  @doc """
  Generate a year_image.
  """
  def year_image_fixture(attrs \\ %{}) do
    {:ok, year_image} =
      attrs
      |> Enum.into(%{
        year: 42
      })
      |> Photog.Api.create_year_image()

    year_image
  end
end
