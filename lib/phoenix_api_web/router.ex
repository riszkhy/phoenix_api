defmodule PhoenixApiWeb.Router do
  use PhoenixApiWeb, :router
  use Plug.ErrorHandler

  def handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  def handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug PhoenixApiWeb.Auth.Pipeline
    plug PhoenixApiWeb.Auth.SetAccount
  end

  scope "/api", PhoenixApiWeb do
    pipe_through :api
    get "/", BaseController, :index
    post "/accounts/create", AccountController, :create
    post "/accounts/signin", AccountController, :sign_in
  end

  scope "/api", PhoenixApiWeb do
    pipe_through [:api, :auth]
    get "/accounts/detail/:id", AccountController, :show
    post "/accounts/update", AccountController, :update
    patch "/accounts/signout", AccountController, :sign_out
    get "/accounts/refresh_session", AccountController, :refresh_session
  end
end
