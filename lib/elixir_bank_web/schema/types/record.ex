defmodule ElixirBankWeb.Schema.Types.Record do
  use Absinthe.Schema.Notation

  alias ElixirBank.Interactions.Like
  alias ElixirBankWeb.Middlewares.Authentication
  alias ElixirBankWeb.Resolvers.Record

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  @desc "The `Record` object represents an entity that is submittable for the review with all the required information."
  object :record do
    field(:category, non_null(:category))
    field(:description, non_null(:string))
    field(:id, non_null(:uuid))
    field(:image_url, non_null(:string))
    field(:likes, non_null(:integer))
    field(:title, non_null(:string))
    field(:user_likes, non_null(list_of(non_null(:like))), resolve: dataloader(Like))
  end

  @desc "The `UpdateRecordParams` object represents the updatable fields of a `Record`."
  input_object :update_record_params do
    field(:category_id, :uuid)
    field(:description, :string)
    field(:image_url, :string)
    field(:title, :string)
  end

  object :record_queries do
    @desc "The `allRecords` query returns all the existing `Records`."
    field :all_records, non_null(list_of(non_null(:record))) do
      arg(:category_name, type: :category_names)

      resolve(&Record.all_records/2)
    end

    @desc "The `mostLikedRecords` query returns the most liked `Record` within a given limit in descending order."
    field :most_liked_records, non_null(list_of(non_null(:record))) do
      arg(:limit, type: non_null(:integer))

      resolve(&Record.most_liked_records/2)
    end

    @desc "The `getRecord` query returns the `Record` within a given `UUID`."
    field :get_record, :record do
      arg(:id, type: non_null(:uuid))

      resolve(&Record.get_record/2)
    end
  end

  object :record_mutations do
    @desc "The `createRecord` mutation returns a created `Record`."
    field :create_record, :record do
      middleware(Authentication)

      arg(:category_id, non_null(:uuid))
      arg(:description, non_null(:string))
      arg(:image_url, non_null(:string))
      arg(:title, non_null(:string))

      resolve(&Record.create_record/2)
    end

    @desc "The `updateRecord` mutation returns an updated `Record`."
    field :update_record, :record do
      middleware(Authentication)

      arg(:id, type: non_null(:uuid))
      arg(:params, :update_record_params)

      resolve(&Record.update_record/2)
    end

    @desc "The `toggleLike` mutation returns a liked `Record` with its number of `likes` updated."
    field :toggle_like, :record do
      middleware(Authentication)

      arg(:record_id, non_null(:uuid))

      resolve(&Record.toggle_like/2)
    end
  end
end
