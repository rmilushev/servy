defmodule Servy.Plugins do
  require Logger
  alias Servy.Conv

  def track(%Conv{ status: 404, path: path } = conv) do
    Logger.error "The path #{path} is on the loose..."
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{ path: "/wildlife" } =  conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv) do
    Logger.info "Logger: #{inspect conv}..."
    conv
  end
end
