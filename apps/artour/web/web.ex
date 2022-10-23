defmodule Artour.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Artour.Web, :controller
      use Artour.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Common.ViewHelpers.Form
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias Artour.Repo
      import Ecto
      import Ecto.Query

      import Artour.Router.Helpers
      import Artour.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Artour.Router.Helpers
      import Artour.ErrorHelpers
      import Artour.Gettext
      import Artour.LayoutHelpers
      import Artour.DateHelpers, only: [datetime_to_display_date: 1, date_to_us_date: 1, datetime_to_us_date: 1]
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Artour.Repo
      import Ecto
      import Ecto.Query
      import Artour.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
