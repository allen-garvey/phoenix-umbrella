defmodule Bookmarker.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use PhoenixHTMLHelpers

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
    if error = form.errors[field] do
      content_tag :span, CommonWeb.ErrorHelpers.translate_error(error), class: "help-block"
    end
  end

end
