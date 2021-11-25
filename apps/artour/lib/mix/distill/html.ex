#run task with 'mix distill.html'
defmodule Mix.Tasks.Distill.Html do
  use Mix.Task
  import Plug.Test, only: [conn: 2]
  alias Distill.PageRoute

  @shortdoc "Generates static html files from pages and saves in given directory"
  def run(_args) do
    dest_dir = Distill.Directory.default_dest_directory
    #create root directory if it doesn't exist
    File.mkdir_p! dest_dir

    IO.puts "Generating HTML files in " <> dest_dir

    # disable logging of database queries
    Logger.configure(level: :error)
    #start app so repo is available
    Mix.Task.run "app.start", []

    routes = Distill.Page.routes
              ++ Distill.Page.paginated_index_routes(Artour.Public.last_page())
              ++ Distill.Post.routes
              ++ Distill.Tag.routes
              ++ Distill.Category.routes

    for page_route <- routes do
      #render the page
      conn = default_conn() |> render_page_route(page_route)
      #make sure directory for file exists
      directory_name = dest_dir |> Path.join(directory_for(page_route))
      File.mkdir_p! directory_name
      #save html to file
      filename = dest_dir |> Path.join(filename_for(page_route))
      save_to_file(conn, filename)
    end

  end

  @doc """
  Saves html in conn response body to file specified by filename
  be aware that it overwrites the file if it exists
  """
  def save_to_file(%Plug.Conn{resp_body: resp_body}, filename) when is_binary(filename) do
    File.write!(filename, resp_body, [:utf8, :write])
  end

  @doc """
  Can't use Path.dirname unaltered, as it strips the directory name if
  path is already a directory
  """
  def directory_for(%PageRoute{path: path}) do
    directory_for path
  end

  def directory_for(path) when is_binary(path) do
    if String.ends_with? path, ".html" do
      Path.dirname path
    else
      path
    end
  end

  @doc """
  Returns the html filename to save a current path as
  """
  def filename_for(%PageRoute{path: path}) do
    filename_for path
  end

  def filename_for(path) when is_binary(path) do
    if String.ends_with? path, ".html" do
      path
    else
      Path.join(path, "index.html")
    end
  end


  @doc """
  Returns base conn struct
  have to initialize with Phoenix.Controller.put_new_view before
  Phoenix.Controller.render will work
  """
  def default_conn() do
    conn(:get, "/")
      |> Plug.Conn.put_private(:phoenix_endpoint, Artour.Endpoint)
      |> Phoenix.Controller.put_new_layout({Artour.LayoutView, "public.html"})
  end

  @doc """
  Returns conn after rendering page route
  second argument should be list item from page_routes function
  conn.resp_body will contain rendered page
  """
  def render_page_route(conn, %PageRoute{controller: controller, handler: handler, params: params}) do
    #can't use pipes if we want to dynamically call controller
    conn = Phoenix.Controller.put_new_view(conn, default_view_for(controller))
    apply(controller, handler, [conn, params])
  end

  @doc """
  Returns default module name atom for a given controller
  (the same as controller name with controller replaced by view)
  """
  def default_view_for(controller) when is_atom(controller) do
    controller
      |> Atom.to_string
      |> String.replace_suffix("Controller", "View")
      |> String.to_atom
  end

end
