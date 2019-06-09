defmodule Movielist.Admin.ModelHelpers do
  import Ecto.Changeset

  @doc """
  Validates rating score is between 1-100
  """
  def validate_score(changeset, attribute_key) do
    score = get_field(changeset, attribute_key)
    if !is_integer(score) or score < 1 or score > 100 do
      add_error(changeset, attribute_key, "Score must be between 1-100")
    else
      changeset
    end
  end

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
