defmodule Mix.Tasks.Miggy do
    use Mix.Task
  
    alias Photog.Api

    def run(_args) do
        Mix.Task.run "app.start", []

        imports = Api.list_imports_with_count_and_limited_images()

        for import <- imports do
            first_image = import.images |> Enum.fetch!(0)
            Api.update_import(import, %{cover_image_id: first_image.id})
        end
    end

end