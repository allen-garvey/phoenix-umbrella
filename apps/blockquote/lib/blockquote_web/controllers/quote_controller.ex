defmodule BlockquoteWeb.QuoteController do
  use BlockquoteWeb, :controller

  alias Blockquote.Admin
  alias Blockquote.Admin.Quote
  alias Blockquote.Repo

  def custom_render(conn, template, assigns) do
    custom_render(conn, view_module(conn), template, assigns)
  end

  def custom_render(conn, view_module, template, assigns) do
    assigns = [{:item_name_singular, "quote"}] ++ assigns
    render(conn, view_module, template, assigns)
  end
  
  def related_fields do
    #need to add empty value at start of authors since it is optional
    authors = Admin.list_authors() |> BlockquoteWeb.AuthorView.map_for_form |> List.insert_at(0, {"", nil})
    categories = Admin.list_categories() |> BlockquoteWeb.CategoryView.map_for_form
    sources = Admin.list_sources() |> BlockquoteWeb.SourceView.map_for_form
    [authors: authors, categories: categories, sources: sources]
  end

  def index(conn, _params) do
    quotes = Admin.list_quotes()
    custom_render(conn, BlockquoteWeb.SharedView, "index.html", items: quotes, item_view: view_module(conn), item_display_func: :to_excerpt)
  end

  def new(conn, params) do
    changeset = Admin.change_quote(%Quote{})
    new_page(conn, changeset, params)
  end
  
  def new_page(conn, changeset, _params) do
    custom_render(conn, "new.html", changeset: changeset, related_fields: related_fields(), save_another: true)
  end
  
  def edit_page(conn, changeset, quote) do
    custom_render(conn, "edit.html", changeset: changeset, related_fields: related_fields(), item: quote)
  end

  def create_succeeded(conn, quote, "true") do
    changeset = Admin.change_quote(%Quote{author_id: quote.author_id, category_id: quote.category_id, source_id: quote.source_id})
    new_page(conn, changeset, nil)
  end

  def create_succeeded(conn, quote, _save_another) do
    redirect(conn, to: quote_path(conn, :show, quote))
  end

  def create(conn, %{"quote" => quote_params, "save_another" => save_another}) do
    changeset = Admin.create_quote_changeset(quote_params)
    source_id = Ecto.Changeset.get_field(changeset, :source_id)
    source = Admin.get_source!(source_id)
    
    case Repo.insert(Quote.validate_author_id(changeset, source)) do
      {:ok, quote} ->
        conn
          |> put_flash(:info, "Quote created successfully.")
          |> create_succeeded(quote, save_another)
      {:error, %Ecto.Changeset{} = changeset} ->
        new_page(conn, changeset, nil)
    end
  end

  def show(conn, %{"id" => id}) do
    quote = Admin.get_quote_for_show!(id)
    custom_render(conn, "show.html", quote: quote)
  end

  def edit(conn, %{"id" => id}) do
    quote = Admin.get_quote!(id)
    changeset = Admin.change_quote(quote)
    edit_page(conn, changeset, quote)
  end

  def update(conn, %{"id" => id, "quote" => quote_params}) do
    quote = Admin.get_quote!(id)
    
    changeset = Admin.update_quote_changeset(quote, quote_params)
    source_id = Ecto.Changeset.get_field(changeset, :source_id)
    source = Admin.get_source!(source_id)

    case Repo.update(Quote.validate_author_id(changeset, source)) do
      {:ok, quote} ->
        conn
        |> put_flash(:info, "Quote updated successfully.")
        |> redirect(to: quote_path(conn, :show, quote))
      {:error, %Ecto.Changeset{} = changeset} ->
        edit_page(conn, changeset, quote)
    end
  end

  def delete(conn, %{"id" => id}) do
    quote = Admin.get_quote!(id)
    {:ok, _quote} = Admin.delete_quote(quote)

    conn
    |> put_flash(:info, "Quote deleted successfully.")
    |> redirect(to: quote_path(conn, :index))
  end
end
