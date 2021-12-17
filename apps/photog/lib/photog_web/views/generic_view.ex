defmodule PhotogWeb.GenericView do
  use PhotogWeb, :view

  @doc """
  Generic ok message, such as for when something is created or deleted successfully
  """
  def render("ok.json", %{message: message}) do
    %{data: message}
  end

  @doc """
  Generic error message, such as for when there is an error
  """
  def render("error.json", %{message: message}) do
    %{error: message}
  end

  @doc """
  Used for when there is a mixture of success and error messages
  """
  def render("mixed_response.json", %{message: message, error: error}) do
    %{
      data: message,
      error: error,
    }
  end

  @doc """
  Used for count of items
  """
  def render("count.json", %{count: count}) do
    %{data: count}
  end

end
