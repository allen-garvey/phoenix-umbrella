defmodule Grenadier.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Grenadier.Repo

  alias Grenadier.Account.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user.
  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Gets a single user by name
  """
  def get_user_by_name(name) do
    Repo.get_by(User, name: name)
  end

  @doc """
  Gets a single user given name and password,
  or false if either user does not exist or password is wrong
  """
  def authenticate_user(name, password) do
    case get_user_by_name(name) do
      %User{} = user -> Argon2.check_pass(user, password)
      nil -> {:error, Argon2.no_user_verify()}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Grenadier.Account.Login

  @doc """
  Returns the list of logins.

  ## Examples

      iex> list_logins()
      [%Login{}, ...]

  """
  def list_logins do
    from(Login, order_by: [desc: :id])
    |> Repo.all()
  end

  @doc """
  Gets a single login.

  Raises `Ecto.NoResultsError` if the Login does not exist.

  ## Examples

      iex> get_login!(123)
      %Login{}

      iex> get_login!(456)
      ** (Ecto.NoResultsError)

  """
  def get_login!(id), do: Repo.get!(Login, id)

  @doc """
  Creates a login.

  ## Examples

      iex> create_login(%{field: value})
      {:ok, %Login{}}

      iex> create_login(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_login(attrs \\ %{}) do
    %Login{}
    |> Login.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a login.

  ## Examples

      iex> update_login(login, %{field: new_value})
      {:ok, %Login{}}

      iex> update_login(login, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_login(%Login{} = login, attrs) do
    login
    |> Login.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Login.

  ## Examples

      iex> delete_login(login)
      {:ok, %Login{}}

      iex> delete_login(login)
      {:error, %Ecto.Changeset{}}

  """
  def delete_login(%Login{} = login) do
    Repo.delete(login)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking login changes.

  ## Examples

      iex> change_login(login)
      %Ecto.Changeset{source: %Login{}}

  """
  def change_login(%Login{} = login) do
    Login.changeset(login, %{})
  end
end
