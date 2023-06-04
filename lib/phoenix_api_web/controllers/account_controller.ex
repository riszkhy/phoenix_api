defmodule PhoenixApiWeb.AccountController do
  use PhoenixApiWeb, :controller

  alias PhoenixApiWeb.Auth.ErrorResponse
  alias PhoenixApiWeb.Auth.Guardian
  alias PhoenixApi.Users.User
  alias PhoenixApi.Accounts
  alias PhoenixApi.Accounts.Account
  alias PhoenixApi.Users

  action_fallback PhoenixApiWeb.FallbackController

  plug :is_authorized_account when action in [:update, :delete]

  defp is_authorized_account(conn, _) do
    %{params: %{"account" => params}} = conn
    account = Accounts.get_account_by_email(params["email"])
    if conn.assigns.account.id == account.id do
      conn
    else
      raise ErrorResponse.Forbidden
    end
  end

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, "index.json", accounts: accounts)
  end

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
          {:ok, token, _claims} <- Guardian.encode_and_sign(account),
          {:ok, %User{} = _user} <- Users.create_user(account, account_params) do
      conn
      |> put_status(:created)
      |> render("account_token.json", %{account: account, token: token})
    end
  end

  @spec sign_in(Plug.Conn.t(), map) :: Plug.Conn.t()
  def sign_in(conn, %{"email" => email, "hash_password" => hash_password}) do
    case Guardian.authenticate(email, hash_password) do
      {:ok, account, token} ->
        conn
        |> Plug.Conn.put_session(:account_id, account.id)
        |> put_status(:ok)
        |> render("account_token.json", %{account: account, token: token})
      {:error, :unauthorized} -> raise ErrorResponse.Unauthorized, message: "Email or Password is incorrect"
    end
  end

  def sign_out(conn, %{}) do
    account = conn.assigns[:account]
    token = Guardian.Plug.current_token(conn)
    Guardian.revoke(token)
    conn
    |> Plug.Conn.clear_session()
    |> put_status(:ok)
    |> render("account_token.json", %{account: account, token: nil})
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, "show.json", account: account)
  end

  @spec update(any, map) :: any
  def update(conn, %{"account" => account_params}) do
    account = Accounts.get_account_by_email(account_params["email"])

    with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
      render(conn, "show.json", account: account)
    end
  end

  @spec delete(any, map) :: any
  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
