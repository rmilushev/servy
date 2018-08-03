defmodule Servy.Conv do
  defstruct method: "",
            path: "",
            resp_body: "",
            status: nil,
            params: %{},
            headers: %{}


  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
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
