defmodule PhoenixApiWeb.BaseController do
  use PhoenixApiWeb, :controller

  def index(conn, _params) do
    text conn, "Toast API Live #{Mix.env()}"
  end
end
