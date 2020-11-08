defmodule ElixirBank.Factory do
  alias Ecto.{Changeset, UUID}
  alias ElixirBank.Accounts.{Profile, User}
  alias ElixirBank.Interactions.Like
  alias ElixirBank.Records.{Category, Record}
  alias ElixirBank.Repo

  @build_action :build
  @build_action! :build!
  @insert_action :insert
  @insert_action! :insert!

  def build(module, attrs \\ %{}), do: factory(@build_action, module, attrs)
  def build!(module, attrs \\ %{}), do: factory(@build_action!, module, attrs)

  def insert(module, attrs \\ %{}), do: factory(@insert_action, module, attrs)
  def insert!(module, attrs \\ %{}), do: factory(@insert_action!, module, attrs)

  defp factory(action, module, attrs) do
    with {:ok, base_attrs} <- get_base_attributes(module) do
      module
      |> apply_changeset(base_attrs, attrs)
      |> do_action(action)
    end
  end

  def params_for(module), do: get_base_attributes(module)

  defp get_base_attributes(Category) do
    base_attrs = %{
      name: Faker.Name.name()
    }

    {:ok, base_attrs}
  end

  defp get_base_attributes(Like) do
    {:ok, record} = insert(Record)
    {:ok, user} = insert(User)

    base_attrs = %{
      record_id: record.id,
      user_id: user.id
    }

    {:ok, base_attrs}
  end

  defp get_base_attributes(Profile) do
    {:ok, user} = insert(User)

    base_attrs = %{
      user_id: user.id
    }

    {:ok, base_attrs}
  end

  defp get_base_attributes(Record) do
    {:ok, category} = insert(Category)

    base_attrs = %{
      category_id: category.id,
      description: "some description",
      image_url: "some image url",
      title: "some title"
    }

    {:ok, base_attrs}
  end

  defp get_base_attributes(User) do
    base_attrs = %{
      date_of_birth: ~D[2000-01-01],
      email: Faker.Internet.email(),
      name: "some name",
      pin: "0000"
    }

    {:ok, base_attrs}
  end

  defp get_base_attributes(_), do: {:error, :invalid_factory}

  defp apply_changeset(module, base_attrs, attrs) do
    updated_attrs = Map.merge(base_attrs, attrs)
    id = Map.get(updated_attrs, :id, UUID.generate())
    struct = Map.put(module.__struct__, :id, id)
    module.changeset(struct, updated_attrs)
  end

  defp do_action(changeset = %Changeset{valid?: true}, @build_action), do: {:ok, Changeset.apply_changes(changeset)}
  defp do_action(changeset = %Changeset{}, @build_action), do: {:error, changeset}
  defp do_action(changeset = %Changeset{}, @insert_action), do: Repo.insert(changeset)

  defp do_action(changeset = %Changeset{}, @build_action!), do: Changeset.apply_changes(changeset)
  defp do_action(changeset = %Changeset{}, @insert_action!), do: Repo.insert!(changeset)
end
