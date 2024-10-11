defmodule HabitsWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """
  import Phoenix.HTML.Form
  use PhoenixHTMLHelpers

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, CommonWeb.ErrorHelpers.translate_error(error),
        class: "invalid-feedback",
        phx_feedback_for: input_name(form, field)
      )
    end)
  end

end
