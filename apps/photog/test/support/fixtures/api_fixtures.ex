defmodule Photog.ApiFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Photog.Api` context.
  """

  @doc """
  Generate a clan.
  """
  def clan_fixture(attrs \\ %{}) do
    {:ok, clan} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Photog.Api.create_clan()

    clan
  end
end
