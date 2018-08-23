defmodule HelloPhxWeb.PageController do
  use HelloPhxWeb, :controller

  def index(conn, _params) do
    assigns = [item_name_a: "apple", item_name_b: "banana"]
    render conn, "index.html", assigns
  end
end
