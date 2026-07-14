defmodule SupersearchWeb.ApiController do
  use GrenadierWeb, :controller

  alias Supersearch.Admin

  plug(:put_view, json: CommonWeb.ApiGenericView)

  defp does_env_value_match?(string, env_key) do
    case System.fetch_env(env_key) do
      {:ok, value} ->
        case Regex.compile(value) do
          {:ok, regex} -> Regex.match?(regex, string)
          _ -> true
        end

      _ ->
        true
    end
  end

  def ip_class(conn, %{"ip" => ip, "org" => org}) do
    class_name =
      case {does_env_value_match?(ip, "UMBRELLA_SUPERSEARCH_IP_REGEX"),
            does_env_value_match?(org, "UMBRELLA_SUPERSEARCH_ORG_REGEX")} do
        {false, false} -> "alert-success"
        _ -> "alert-danger"
      end

    render(conn, "ok.json", message: class_name)
  end

  def reorder_engines(conn, %{"engine_ids" => engine_ids}) when is_list(engine_ids) do
    case Admin.reorder_engines(engine_ids) do
      {:ok, _} ->
        conn |> render("ok.json", message: "ok")

      {:error, _} ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", message: "Could not reorder engines.")
    end
  end
end
