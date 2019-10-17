defmodule GrenadierWeb.LoginView do
  use GrenadierWeb, :view

  def login_row_class(login_was_successful) when is_boolean(login_was_successful) do
    case login_was_successful do
      true  -> ""
      false -> "login-failed"
    end
  end

end
