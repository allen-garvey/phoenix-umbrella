defmodule CommonWeb do
    @moduledoc """
    The entrypoint for defining your web interface, such
    as controllers, views, channels and so on.
  
    This can be used in your application as:
  
        use CommonWeb, :controller
        use CommonWeb, :view
  
    The definitions below will be executed for every view,
    controller, etc, so keep them short and clean, focused
    on imports, uses and aliases.
  
    Do NOT define functions inside the quoted expressions
    below. Instead, define any helper function in modules
    and import those modules here.
    """
  
    def view do
      quote do
        use Phoenix.View, root: "lib/common_web/templates",
                          namespace: CommonWeb
  
        # Import convenience functions from controllers
        import Phoenix.Controller, only: [get_flash: 2, view_module: 1]
  
        # Use all HTML functionality (forms, tags, etc)
        import Phoenix.HTML
        import Phoenix.HTML.Form
        use PhoenixHTMLHelpers

        import CommonWeb.Gettext
        import CommonWeb.ErrorHelpers
      end
    end
  
    @doc """
    When used, dispatch to the appropriate controller/view/etc.
    """
    defmacro __using__(which) when is_atom(which) do
      apply(__MODULE__, which, [])
    end
  end
  