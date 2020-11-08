# elixir-bank

# ElixirBank Backend

[build]: https://github.com/ElixirBank2020/elixir_bank-backend/actions?workflow=Continuous%20Integration
[build-badge]: https://github.com/ElixirBank2020/elixir_bank-backend/workflows/Continuous%20Integration/badge.svg

[![Build Status][build-badge]][build]

## Requirements

- Elixir 1.9.X-otp-22
- Erlang 22.1.X

## Starting the Service

- Install dependencies with `mix deps.get`;
- Start a local docker environment for the database with `docker-compose up -d`;
- Create and migrate your database with `mix ecto.setup`;
- Start Phoenix endpoint with `mix phx.server`.

Now you can call routes on [`localhost:4000`](http://localhost:4000).

## Running seeds and having mocked data

- Run `mix ecto.seed` and it will run the script in priv/seeds.exs.

## Running Code Analysis Tools and formatting

We format the codebase using `mix format` and verify if everything is correct with it.

We use [Credo](https://github.com/rrrene/credo) and [Dialyxir](https://github.com/jeremyjh/dialyxir) to verify code integrity.

The following command should not return errors for builds to pass on CI:

```sh
mix credo && mix dialyzer && mix sobelow --config && mix format --check-formatted
```

## Running Tests

### Unit Tests

- Use `mix test` to run unit tests.
