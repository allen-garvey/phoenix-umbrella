#run task with 'mix distill.test.image_urls'
defmodule Mix.Tasks.Distill.Test.ImageUrls do
    use Mix.Task

    @shortdoc "Checks that all image urls return HTTP 200 status code"
	def run([base_url]) do

        #make sure base_url ends with trailing slash
        base_url = cond do
                        !String.ends_with?(base_url, "/") -> base_url <> "/"
                        true -> base_url 
                    end

        #start app so repo is available
        Mix.Task.run "app.start", []

        #start HTTPoison
        HTTPoison.start

        #parallel map based on:
        #http://elixir-recipes.github.io/concurrency/parallel-map/
    	Artour.Repo.all(Artour.Image)
    		|> Enum.flat_map(fn image -> image_sizes() |> Enum.map(&(url_for_image(image, base_url, &1))) end)
            |> Task.async_stream(&HTTPoison.head/1, max_concurrency: System.schedulers_online * 8, timeout: :infinity)
            |> Enum.to_list()
            |> Enum.each(&print_image_response/1)

    	IO.puts "\nAll image urls checked"
	end

    def image_sizes() do
        [:thumbnail, :small, :medium, :large]
    end

    #task status and http status is ok, so do nothing
    def print_image_response({:ok, {:ok, %HTTPoison.Response{status_code: 200}}}) do
    end

    def print_image_response({:ok, {:ok, response}}) do
        IO.puts "HTTP status code of " <> Integer.to_string(response.status_code) <> " for " <> response.request_url
    end

    #url sent no response
    def print_image_response({:ok, {:error, message}}) do
        IO.puts message
    end

    #problem with running async task somehow
    def print_image_response({_task_status, {_httpoison_status, _message}}) do
        IO.puts "Problem with testing image url async task"
    end

	def url_for_image(image, base_url, size) do
		image_filename = case size do
			:thumbnail -> image.filename_thumbnail
			:small -> image.filename_small
			:medium -> image.filename_medium
			:large -> image.filename_large
		end
        URI.merge(base_url, image_filename) |> to_string
	end
	
end