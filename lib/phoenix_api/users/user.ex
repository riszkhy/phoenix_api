defmodule PhoenixApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string
  schema "users" do
    field :biography, :string
    field :fullname, :string
    field :gender, :string
    belongs_to :account, PhoenixApi.Accounts.Account

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:fullname, :gender, :biography])
    |> validate_required([:account_id])
    |> put_change(:id, Ecto.UUID.generate())
  end
end
