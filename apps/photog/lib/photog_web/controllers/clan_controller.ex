defmodule PhotogWeb.ClanController do
  use PhotogWeb, :controller

  alias Photog.Api
  alias Photog.Api.Clan
  alias Photog.Api.ClanPerson

  action_fallback PhotogWeb.FallbackController

  def index(conn, %{"excerpt" => "false"}) do
    clans = Api.list_clans_full()
    render(conn, "index.json", clans: clans)
  end
  
  def index(conn, _params) do
    clans = Api.list_clans()
    render(conn, "index.json", clans: clans)
  end

  def create(conn, %{"clan" => clan_params, "person_ids" => person_ids}) do
    create_clan(conn, clan_params, fn clan -> 
      {_, _} = add_persons_to_clan(clan.id, person_ids)
    end)
  end

  def create(conn, %{"clan" => clan_params}) do
    create_clan(conn, clan_params, fn _ -> true end)
  end

  defp create_clan(conn, clan_params, created_callback) do
    with {:ok, %Clan{} = clan} <- Api.create_clan(clan_params) do
      created_callback.(clan)
      conn
      |> put_status(:created)
      |> render("show.json", clan: clan)
    end
  end

  def show(conn, %{"id" => id}) do
    clan = Api.get_clan!(id)
    render(conn, "show.json", clan: clan)
  end

  def update(conn, %{"id" => id, "clan" => clan_params}) do
    clan = Api.get_clan!(id)

    with {:ok, %Clan{} = clan} <- Api.update_clan(clan, clan_params) do
      render(conn, "show.json", clan: clan)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {1, _} <- Api.delete_clan_by_id(id) do
      conn
      |> put_view(CommonWeb.ApiGenericView)
      |> render("ok.json", message: "Clan #{id} deleted.")
    end
  end

  @doc """
  Adds persons to an clan
  returns {person_ids_added, errors}
  """
  def add_persons_to_clan(clan_id, person_ids) do
    Enum.reduce(person_ids, {[], []}, fn person_id, {persons_added, errors} ->
      case Api.create_clan_person(%{"clan_id" => clan_id, "person_id" => person_id}) do
        {:ok, %ClanPerson{} = clan_person} -> { [clan_person.person_id | persons_added], errors }
        {:error, _changeset}                -> { persons_added, [ person_id | errors] }
      end
    end)
  end

  @doc """
  Replaces an clans's persons with given list of persons
  """
  def replace_persons(conn,  %{"id" => id, "person_ids" => person_ids}) when is_list(person_ids) do
    view = conn |> put_view(CommonWeb.ApiGenericView)

    case Api.replace_persons_for_clan(id, person_ids) do
      {:ok, _} -> view |> render("ok.json", message: "ok")
      {:error, _} -> view |> put_status(:bad_request) |> render("error.json", message: "Error saving persons for clan #{id}")
    end
  end

  def images_for(conn, %{"id" => id, "limit" => limit, "offset" => offset}) do
    images = Api.get_images_for_clan(id, String.to_integer(limit), String.to_integer(offset))
    
    conn
    |> put_view(PhotogWeb.ImageView)
    |> render("index_thumbnail_list.json", images: images)
  end
end
