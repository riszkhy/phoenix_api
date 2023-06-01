defmodule PhoenixApiWeb.Auth.ErrorResponse.Unauthorized do
  defexception [message: "Unauthorized", plug_status: 401]
end

defmodule PhoenixApiWeb.Auth.ErrorResponse.Forbidden do
  defexception [message: "Forbidden Access", plug_status: 403]
end
