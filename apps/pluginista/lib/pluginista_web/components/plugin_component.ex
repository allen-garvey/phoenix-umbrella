defmodule PluginistaWeb.PluginComponent do
  use PluginistaWeb, :component

  attr :form, Phoenix.HTML.Form, required: true
  attr :field, :atom, required: true
  attr :options, :list, required: true
  attr :selected_options, :list, required: true

  def multiselect_checkboxes(assigns) do
    ~H"""
    <%= for {name, key} <- @options do %>
      <% id = input_id(@form, @field, key) %>
      <div class="form-check form-check-inline">
        <input
          name={input_name(@form, @field) <> "[]"}
          id={id}
          class="form-check-input"
          type="checkbox"
          value={key}
          checked={Map.has_key?(@selected_options, key)}
        />
        <label class="form-check-label" for={id}>
          <%= name %>
        </label>
      </div>
    <% end %>
    """
  end
end
