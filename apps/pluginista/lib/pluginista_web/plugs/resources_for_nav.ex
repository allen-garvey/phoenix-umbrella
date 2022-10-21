defmodule PluginistaWeb.Plugs.ResourcesForNav do
    import Plug.Conn
    alias Pluginista.Admin
  
    def init(opts) do
      opts
    end
  
    def call(conn, _opts) do
      groups = Admin.list_groups_with_plugins()
      assign(conn, :nav_groups, groups)
    end
  
  end
  