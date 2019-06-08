defmodule BlockquoteWeb.SharedView do
  use BlockquoteWeb, :view
  
  @doc """
  	Naive implementation of function to pluralize string
  	"""
	def naive_pluralize(singular) do
		if String.ends_with? singular, "y" do
		  String.replace_trailing(singular, "y", "ies")
		else
			singular <> "s"
		end
	end

	@doc """
  	Used to generate name for path helper function
  	"""
	def item_path_func_name(item_name_singular) do
		String.to_atom(String.replace(item_name_singular, " ", "_") <> "_path")
	end

	@doc """
  	Returns path for item
  	(e.g. :index, :show, :new)
  	"""
	def path_for_item(conn, item_name_singular, path_atom) do
		apply(BlockquoteWeb.Router.Helpers, item_path_func_name(item_name_singular), [conn, path_atom])
	end

	@doc """
  	Returns path for item instance
  	(e.g. :edit and :show)
  	"""
	def path_for_item(conn, item_name_singular, path_atom, item_instance) do
		apply(BlockquoteWeb.Router.Helpers, item_path_func_name(item_name_singular), [conn, path_atom, item_instance])
	end
	
	@doc """
  	Returns inserted_at date as string for ecto model
  	"""
  	def item_date_created(item) do
  		"#{date_to_iso_string(item.inserted_at)} #{pad_date_digit(item.inserted_at.hour)}:#{pad_date_digit(item.inserted_at.minute)}"
  	end
  	
  	@doc """
  	Returns date as iso_formatted string YYYY-MM-DD
  	"""
  	def date_to_iso_string(date) do
  		"#{date.year}-#{pad_date_digit(date.month)}-#{pad_date_digit(date.day)}"
  	end
  	
  	
  	def pad_date_digit(digit) do
  		Integer.to_string(digit) |> String.pad_leading(2, ["0"])
  	end
  	
  	@doc """
  	Used to turn a url that might be nil into a link
  	"""
  	def linkify(nil) do
  		nil
  	end
  	
  	def linkify(url) do
  		link(url, to: url)
  	end
  	
  	
  	@doc """
  	Used for forms to determine if required
  	"""
  	def field_required?(field_atom, required_fields) do
  		required_fields |> Enum.member?(field_atom)
  	end
  	
  	def field_required_label_class(true) do
  		"required"
  	end
  	
  	def field_required_label_class(false) do
  		""
  	end
  	
	def form_item_label(f, field, required_fields) do
		label f, field, class: "control-label " <> field_required_label_class(field_required?(field, required_fields))
	end
	
	def form_input(f, :string, field, required_fields, nil) do
		text_input(f, field, class: "form-control", required: field_required?(field, required_fields))
	end
	
	def form_input(f, :text, field, required_fields, nil) do
		textarea(f, field, class: "form-control", required: field_required?(field, required_fields), cols: 80, rows: 10)
	end
	
	def form_input(f, :date, field, required_fields, nil) do
    date_input(f, field, class: "form-control", required: field_required?(field, required_fields))
	end
	
	def form_input(f, :select, field, required_fields, items) do
		select(f, field, items, class: "form-control", required: field_required?(field, required_fields))
	end

  def breadcrumb_link(conn, item_name_singular) do
    link_title = item_name_singular |> naive_pluralize |> String.capitalize
    
    link link_title, to: path_for_item(conn, item_name_singular, :index)
  end

  def render("new.html", assigns) do
      conn = assigns[:conn]
      item_name_singular = assigns[:item_name_singular]
      
      assigns = Map.merge(assigns, 
          %{
              title: "Add " <> item_name_singular,
              # back_link_title: "All " <> naive_pluralize(item_name_singular),
              # back_link_path: path_for_item(conn, item_name_singular, :index),
              action: path_for_item(conn, item_name_singular, :create),
          }
      )
      
      render "form_page.html", assigns
  end

  def render("edit.html", assigns) do
      conn = assigns[:conn]
      item_name_singular = assigns[:item_name_singular]
      item = assigns[:item]
      item_display_name = assigns[:item_display_name]
      
      assigns = Map.merge(assigns, 
          %{
              title: "Edit " <> item_display_name,
              back_link_title: "Back to " <> item_display_name,
              back_link_path: path_for_item(conn, item_name_singular, :show, item),
              action: path_for_item(conn, item_name_singular, :update, item),
          }
      )
      
      render "form_page.html", assigns
  end
end