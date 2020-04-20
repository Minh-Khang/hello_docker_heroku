defmodule HelloDockerHeroku.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :name, :string
      add :hash_pass, :string

      timestamps()
    end

  end
end
