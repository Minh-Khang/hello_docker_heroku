defmodule HelloDockerHeroku.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :hash_pass, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :hash_pass])
    |> validate_required([:email, :name, :hash_pass])
  end
end
