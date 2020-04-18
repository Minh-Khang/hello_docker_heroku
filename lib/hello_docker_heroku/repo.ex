defmodule HelloDockerHeroku.Repo do
  use Ecto.Repo,
    otp_app: :hello_docker_heroku,
    adapter: Ecto.Adapters.Postgres
end
