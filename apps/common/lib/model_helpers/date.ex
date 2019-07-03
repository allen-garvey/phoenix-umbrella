defmodule Common.ModelHelpers.Date do
  alias Ecto.Changeset

  @doc """
  Adds default date as today if nil
  """
  def default_date_today(changeset, attribute_key) do
    date_value = Changeset.get_field(changeset, attribute_key)
    if is_nil(date_value) do
      Changeset.change(changeset, %{attribute_key => Date.utc_today})
    else
      changeset
    end
  end

  @doc """
  Adds default datetime as now if nill
  """
  def default_datetime_now(changeset, attribute_key) do
    if is_nil(Changeset.get_field(changeset, attribute_key)) do
      now = DateTime.utc_now() |> DateTime.truncate(:second)
      Changeset.change(changeset, %{attribute_key => now})
    else
      changeset
    end
  end

end
