# File: my_app/Dockerfile
FROM elixir:alpine as build

# install build dependencies
RUN apk add --update git build-base nodejs npm yarn python

RUN mkdir /app
WORKDIR /app

# install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# build assets
COPY assets assets
RUN cd assets && npm install && npm run deploy
RUN mix phx.digest

# build project
COPY priv priv
COPY lib lib
RUN mix compile

# build release
# at this point we should copy the rel directory but
# we are not using it so we can omit it
# COPY rel rel
RUN mix release

# prepare release image
FROM alpine:latest AS app

# install runtime dependencies
RUN apk add --update bash openssl postgresql-client

EXPOSE 4000
ENV MIX_ENV=prod

# prepare app directory
RUN mkdir /app
WORKDIR /app

# copy release to app container
COPY --from=build /app/_build/prod/rel/hello_docker_heroku .
COPY entrypoint.sh .
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
# 2 ways to migrate + start app
# 1. uncomment COPY entrypoint.sh . and exec this to migrate + bin start
CMD ["bash", "/app/entrypoint.sh"]

# 2. self migrate: heroku run bash -> /app/bin/hello_docker_heroku eval HelloDockerHeroku.Release.migrate
# or /app/bin/hello_docker_heroku eval 'HelloDockerHeroku.Release.rollback(version)'
# CMD ["/app/bin/hello_docker_heroku", "start"]
