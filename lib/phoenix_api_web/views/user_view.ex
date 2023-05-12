defmodule PhoenixApiWeb.UserView do
  use PhoenixApiWeb, :view
  alias PhoenixApiWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      fullname: user.fullname,
      gender: user.gender,
      biography: user.biography
    }
  end
end
