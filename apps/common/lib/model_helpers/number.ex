defmodule Common.ModelHelpers.Number do
  alias Ecto.Changeset

  @doc """
  Validates rating score is between 1-100
  """
  def validate_score(changeset, attribute_key) do
    score = Changeset.get_field(changeset, attribute_key)
    if !is_integer(score) or score < 1 or score > 100 do
      Changeset.add_error(changeset, attribute_key, "Score must be between 1-100")
    else
      changeset
    end
  end

end
