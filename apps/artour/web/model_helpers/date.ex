defmodule Artour.ModelHelpers.Date do
    import Ecto.Changeset

  @doc """
  Adds default date as today if nil
  """
  def default_date_today(changeset, attribute_key) do
    date_value = get_field(changeset, attribute_key)
    if is_nil(date_value) do
      change(changeset, %{attribute_key => Date.utc_today})
    else
      changeset
    end
  end
end