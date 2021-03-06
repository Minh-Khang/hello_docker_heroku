# File: my_app/lib/my_app/release.ex
defmodule HelloDockerHeroku.Release do
  @app :hello_docker_heroku

  def migrate do
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def rollback(version) do
    Application.load(@app)
    Application.ensure_all_started(:ecto_sql)

    Ecto.Migrator.with_repo(
      HelloDockerHeroku.Repo,
      &Ecto.Migrator.run(&1, :down, to: version)
    )
  end

  defp repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end
end
