defmodule PhoenixApi.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string
  schema "accounts" do
    field :email, :string
    field :hash_password, :string
    has_one :user, PhoenixApi.Users.User

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :hash_password])
    |> validate_required([:email, :hash_password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign")
    |> unique_constraint(:email)
    |> put_change(:id, Ecto.UUID.generate())
    |> put_password_hash()
  end

  def changeset_update(account, attrs) do
    account
    |> cast(attrs, [:email, :hash_password])
    |> validate_required([:email, :hash_password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign")
    |> unique_constraint(:email)
    |> put_password_hash()
  end


  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{hash_password: hash_password}} = changeset ) do
    change(changeset, hash_password: Pbkdf2.hash_pwd_salt(hash_password))
  end

  defp put_password_hash(changeset), do: changeset
end
