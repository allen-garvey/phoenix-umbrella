defmodule CommonWeb.FormView do
    use CommonWeb, :view

    @doc """
    Creates a submit button
    """
    def submit_button(resource_title) do
        content_tag(:div, submit("Save " <> resource_title, class: "btn btn-success"))
    end

    @doc """
    Creates a button to trigger the hidden delete form
    """
    def delete_button(opts \\ []) do
        content_tag(:button, "Delete", [class: Keyword.get(opts, :class, "btn btn-danger"), data_button: "delete", type: "button"])
    end

    def delete_button_with_form(conn, delete_path, opts \\ []) do
        hidden_delete_form(conn, delete_path, fn _f -> delete_button(opts) end)
    end
    
    @doc """
    Creates a hidden form to enable item deletion
    """
    def hidden_delete_form(conn, delete_path) do
        hidden_delete_form(conn, delete_path, fn _f -> "" end)
    end

    def hidden_delete_form(conn, delete_path, form_func) when is_function(form_func, 1) do
        form_for(conn, delete_path, [method: "delete", data_form: "delete", class: "hidden-delete-form"], form_func)
    end
  
  end