defmodule Supersearch.Admin do
  @moduledoc """
  The Admin context.
  """

  import Ecto.Query, warn: false
  alias Grenadier.Repo

  alias Supersearch.Admin.Engine

  @doc """
  Returns the list of engines.

  ## Examples

      iex> list_engines()
      [%Engine{}, ...]

  """
  def list_engines do
    from(Engine, order_by: [:order, :id])
    |> Repo.all()
  end

  @doc """
  Gets a single engine.

  Raises `Ecto.NoResultsError` if the Engine does not exist.

  ## Examples

      iex> get_engine!(123)
      %Engine{}

      iex> get_engine!(456)
      ** (Ecto.NoResultsError)

  """
  def get_engine!(id), do: Repo.get!(Engine, id)

  @doc """
  Creates a engine.

  ## Examples

      iex> create_engine(%{field: value})
      {:ok, %Engine{}}

      iex> create_engine(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_engine(attrs) do
    %Engine{}
    |> Engine.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a engine.

  ## Examples

      iex> update_engine(engine, %{field: new_value})
      {:ok, %Engine{}}

      iex> update_engine(engine, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_engine(%Engine{} = engine, attrs) do
    engine
    |> Engine.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a engine.

  ## Examples

      iex> delete_engine(engine)
      {:ok, %Engine{}}

      iex> delete_engine(engine)
      {:error, %Ecto.Changeset{}}

  """
  def delete_engine(%Engine{} = engine) do
    Repo.delete(engine)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking engine changes.

  ## Examples

      iex> change_engine(engine)
      %Ecto.Changeset{data: %Engine{}}

  """
  def change_engine(%Engine{} = engine, attrs \\ %{}) do
    Engine.changeset(engine, attrs)
  end

  def reorder_engines(engine_ids) when is_list(engine_ids) do
    Repo.transaction(fn ->
      for {engine_id, i} <- engine_ids |> Enum.with_index() do
        now = DateTime.utc_now() |> DateTime.truncate(:second)

        {1, nil} =
          from(
            engine in Engine,
            where: engine.id == ^engine_id
          )
          |> Repo.update_all(set: [order: i, updated_at: now])
      end
    end)
  end
end
