defmodule Common.ViewHelpers.Error do
  use PhoenixHTMLHelpers
  
  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, CommonWeb.ErrorHelpers.translate_error(error), class: "help-block")
    end)
  end

end