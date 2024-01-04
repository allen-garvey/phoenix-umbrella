defmodule CommonWeb.FormView do
    use CommonWeb, :view
    
    @doc """
    Creates a hidden form to enable item deletion
    """
    def hidden_delete_form(conn, delete_path) do
        form_for(conn, delete_path, [method: "delete", data_form: "delete"])
    end
  
  end