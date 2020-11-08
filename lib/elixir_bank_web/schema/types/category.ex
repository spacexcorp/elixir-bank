defmodule ElixirBankWeb.Schema.Types.Category do
  use Absinthe.Schema.Notation

  @desc "The `Category` object represents an entity that contains the name of the possible categories for a `Record`."
  object :category do
    field(:id, non_null(:uuid))
    field(:name, non_null(:string))
  end

  @desc "The `Category` names"
  enum :category_names do
    value(:collections, description: "Collections Category")
    value(:fastest, description: "Fastest Category")
    value(:highest, description: "Highest Category")
    value(:largest, description: "Largest Category")
    value(:longest, description: "Longest Category")
    value(:marathon, description: "Marathon Category")
    value(:most, description: "Most Category")
    value(:other, description: "Other Category")
    value(:smallest, description: "Smallest Category")
  end
end
