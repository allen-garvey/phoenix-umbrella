defmodule BooklistWeb.LoanController do
  use BooklistWeb, :controller

  alias Booklist.Admin
  alias Booklist.Admin.Loan

  def related_fields() do
    [
      libraries: Admin.list_libraries() |> BooklistWeb.LibraryView.map_for_form,
    ]
  end

  def index(conn, _params) do
    loans = Admin.list_loans()
    render(conn, "index.html", loans: loans)
  end

  def new(conn, _params) do
    changeset = Admin.change_loan(%Loan{})
    render(conn, "new.html", [changeset: changeset] ++ related_fields())
  end

  def create(conn, %{"loan" => loan_params}) do
    case Admin.create_loan(loan_params) do
      {:ok, loan} ->
        conn
        |> put_flash(:info, "Loan created successfully.")
        |> redirect(to: Routes.loan_path(conn, :show, loan))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", [changeset: changeset] ++ related_fields())
    end
  end

  def show(conn, %{"id" => id}) do
    loan = Admin.get_loan!(id)
    render(conn, "show.html", loan: loan)
  end

  def edit(conn, %{"id" => id}) do
    loan = Admin.get_loan!(id)
    changeset = Admin.change_loan(loan)
    render(conn, "edit.html", [loan: loan, changeset: changeset] ++ related_fields())
  end

  def update(conn, %{"id" => id, "loan" => loan_params}) do
    loan = Admin.get_loan!(id)

    case Admin.update_loan(loan, loan_params) do
      {:ok, loan} ->
        conn
        |> put_flash(:info, "Loan updated successfully.")
        |> redirect(to: Routes.loan_path(conn, :show, loan))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", [loan: loan, changeset: changeset] ++ related_fields())
    end
  end

  def delete(conn, %{"id" => id}) do
    loan = Admin.get_loan!(id)
    item_name = BooklistWeb.LoanView.to_s(loan)
    {:ok, _loan} = Admin.delete_loan(loan)

    conn
    |> put_flash(:info, item_name <> " deleted.")
    |> redirect(to: Routes.loan_path(conn, :index))
  end
end
