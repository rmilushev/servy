defmodule Servy.BearController do
  def index(conv) do
    %{ conv | status: 200, resp_body: "Mecho1, Mecan2, Pticho" }
  end

  def show(conv, %{"id" => id}) do
    %{ conv | status: 200, resp_body: "Bear #{id}" }
  end

  def create(conv, %{"name" => name, "type" => type} = params) do
    %{ conv | status: 201,
              resp_body: "Created a bear: #{type} with name #{name}" }
  end

end
