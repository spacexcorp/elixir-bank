defmodule ElixirBankWeb.ErrorViewTest do
  use ElixirBankWeb.ConnCase, async: true

  import Phoenix.View

  test "should renders 404.json" do
    assert render(ElixirBankWeb.ErrorView, "404.json", []) == %{errors: %{detail: "Not Found"}}
  end

  test "should renders 500.json" do
    assert render(ElixirBankWeb.ErrorView, "500.json", []) == %{errors: %{detail: "Internal Server Error"}}
  end
end
