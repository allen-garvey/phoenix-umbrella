defmodule Teamster.Models.LegacyLoan do
  use Ecto.Schema

  alias Booklist.Admin.Loan


  schema "library_items" do
    field :library_id, :id
    field :due_date, :date
    field :items, :integer

    timestamps(inserted_at: :created_at)
  end

  @doc """
  Migrates legacy model to current booklist model
  """
  def migrate(legacy_loan) do
  	%Loan{
            id: legacy_loan.id,
            inserted_at: legacy_loan.created_at, 
            updated_at: legacy_loan.updated_at,
            library_id: legacy_loan.library_id, 
            item_count: legacy_loan.items, 
            due_date: legacy_loan.due_date, 
          }
  end
end