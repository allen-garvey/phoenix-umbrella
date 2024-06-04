defmodule Photog.Api.ClanPerson do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.photog()
  @primary_key false
  schema "clan_persons" do

    belongs_to :clan, Photog.Api.Clan, primary_key: true
    belongs_to :person, Photog.Api.Person, primary_key: true
  end

  @doc false
  def changeset(clan_person, attrs) do
    clan_person
    |> cast(attrs, [:clan_id, :person_id])
    |> validate_required([:clan_id, :person_id])
    |> assoc_constraint(:clan)
    |> assoc_constraint(:person)
  end
end
