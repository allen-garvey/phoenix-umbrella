defmodule Booklist.Admin.Loan do
  use Ecto.Schema
  import Ecto.Changeset


  schema "loans" do
    field :due_date, :date
    field :item_count, :integer, default: 1
    
    belongs_to :library, Booklist.Admin.Library

    timestamps()
  end

  @doc """
  Validates attribute in changeset is positive integer (greater than 0)
  """
  def validate_positive_integer(changeset, attribute_key) do
    if is_positive_integer(get_field(changeset, attribute_key)) do
      changeset
    else
      add_error(changeset, attribute_key, "Item count must be a positive number (greater than 0)")
    end
  end

  def is_positive_integer(nil) do
    false
  end

  def is_positive_integer(integer) do
    integer > 0
  end

  @doc """
  Adds default loan date as 3 weeks from today today if nil
  """
  def default_loan_date(changeset, attribute_key) do
    date_value = get_field(changeset, attribute_key)
    if is_nil(date_value) do
      change(changeset, %{attribute_key => Date.add(Date.utc_today, 7 * 3)})
    else
      changeset
    end
  end

  @doc false
  def changeset(loan, attrs) do
    loan
    |> cast(attrs, [:library_id, :due_date, :item_count])
    |> default_loan_date(:due_date)
    |> validate_required([:library_id, :due_date, :item_count])
    |> assoc_constraint(:library)
    |> validate_positive_integer(:item_count)
  end
end
