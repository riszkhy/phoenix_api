defmodule PhoenixApiWeb.Auth.Pipeline do
   use Guardian.Plug.Pipeline, otp_app: :phoenix_api,
   module: PhoenixApiWeb.Auth.Guardian,
   error_handler: PhoenixApiWeb.Auth.GuardianErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
