defmodule PhoenixApi.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhoenixApi.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        biography: "some biography",
        fullname: "some fullname",
        gender: "some gender"
      })
      |> PhoenixApi.Users.create_user()

    user
  end
end
