defmodule Photog.ModelHelpers.Date do
    import Ecto.Changeset

  @doc """
  Adds default datetime as now if nill
  """
  def default_datetime_now(changeset, attribute_key) do
    if is_nil(get_field(changeset, attribute_key)) do
      now = DateTime.utc_now() |> DateTime.truncate(:second)
      change(changeset, %{attribute_key => now})
    else
      changeset
    end
  end
end