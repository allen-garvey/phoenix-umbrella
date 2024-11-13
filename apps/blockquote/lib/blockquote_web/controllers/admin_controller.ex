defmodule BlockquoteWeb.AdminController do
  use BlockquoteWeb, :controller
  
  def index(conn, _params) do
    fields = [
      {"Authors", &author_path/2},
      {"Categories", &category_path/2},
      {"Daily Quotes", &daily_quote_path/2},
      {"Quotes", &quote_path/2},
      {"Parent Sources", &parent_source_path/2},
      {"Sources", &source_path/2},
      {"Source Types", &source_type_path/2},
    ]
    render(conn, "index.html", fields: fields)
  end
end