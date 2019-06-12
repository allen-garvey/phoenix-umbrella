defmodule SerenWeb.ComposerView do
  use SerenWeb, :view
  alias SerenWeb.ComposerView

  def render("index.json", %{composers: composers}) do
    %{data: render_many(composers, ComposerView, "composer.json")}
  end

  def render("show.json", %{composer: composer}) do
    %{data: render_one(composer, ComposerView, "composer.json")}
  end

  def render("composer.json", %{composer: composer}) do
    %{id: composer.id,
      name: composer.name}
  end
end
