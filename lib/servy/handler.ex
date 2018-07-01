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


defmodule Servy.Handler do
  @pages_path Path.expand("../../pages", __DIR__)


  def handle(request) do
    request
    |> parse
    |> Servy.Plugins.rewrite_path
    |> Servy.Plugins.log
    |> route
    |> Servy.Plugins.track
    |> format_response
  end


  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split( " ")

    %{ method: method,
       path: path,
       resp_body: "",
       status: nil }
  end

  def route(%{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%{ method: "GET", path: "/bears" } = conv) do
    %{ conv | status: 200, resp_body: "Mecho1, Mecan2, Pticho" }
  end

  def route(%{ method: "GET", path: "/bears" <> id } = conv) do
    %{ conv | status: 200, resp_body: "Bear #{id}" }
  end

  def route(%{ method: "DELETE", path: "/bears" <> _id } = conv) do
    %{ conv | status: 403, resp_body: "Cannot delete bears!!!" }
  end

  def route(%{ method: "GET", path: "/about" } = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%{ method: "GET", path: "/bears/new" } = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%{ path: path } = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here..." }
  end

  def handle_file({:ok, contents}, conv) do
    %{ conv | status: 200, resp_body: contents }
  end

  def handle_file({:error, :enoent}, conv) do
    %{ conv | status: 404, resp_body: "File not found" }
  end

  def handle_file({:error, reason}, conv) do
    %{ conv | status: 500, resp_body: "Got error: #{reason} !!!" }
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      404 => "Not found",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbiden",
      500 => "Internal server error"
    }[code]
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""


response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""


response = Servy.Handler.handle(request)

IO.puts response


request = """
GET /kuche HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""


response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response


request = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)

IO.puts response


request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""


response = Servy.Handler.handle(request)

IO.puts response


request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response


request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response
