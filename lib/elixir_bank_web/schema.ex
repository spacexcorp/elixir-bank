defmodule ElixirBankWeb.Schema do
  use Absinthe.Schema

  alias ElixirBank.Interactions.Like
  alias ElixirBank.Records

  import_types(ElixirBankWeb.Schema.Types.Custom.Date)
  import_types(ElixirBankWeb.Schema.Types.Custom.UUID)
  import_types(ElixirBankWeb.Schema.Types.Category)
  import_types(ElixirBankWeb.Schema.Types.Like)
  import_types(ElixirBankWeb.Schema.Types.Record)
  import_types(ElixirBankWeb.Schema.Types.User)

  query do
    import_fields(:record_queries)
    import_fields(:user_queries)
  end

  mutation do
    import_fields(:record_mutations)
    import_fields(:user_mutations)
  end

  def context(context) do
    loader = Dataloader.add_source(Dataloader.new(), Like, Records.data())
    Map.put(context, :loader, loader)
  end

  def plugins, do: [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
end
