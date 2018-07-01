defmodule Servy.Plugins do
  require Logger
  def track(%{ status: 404, path: path } = conv) do
    Logger.error "The path #{path} is on the loose..."
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{ path: "/wildlife" } =  conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(conv), do: conv

  def log(conv) do
    Logger.info "Logger: #{inspect conv}..."
    conv
  end
end


