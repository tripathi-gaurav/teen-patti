defmodule TeenpattiWeb.GameChannel do
use TeenpattiWeb, :channel



def join("game:" <> gameName, payload, socket) do
   if authorized?(payload) do
      {:ok, %{reason: "Joined Successfully"}, socket}
   else
      {:error, %{reason: "unauthorized"}}
   end
end




defp authorized?( _payload ) do
        true
end

end

