defmodule Mix.Tasks.Rekog do
  @moduledoc """
  Describes an image using a local Ollama vision model.
  Currently doesn't support webp images.

  ## Usage

      mix rekog /path/to/image.png
      mix rekog /path/to/image.jpg --model llava
  """
  use Mix.Task

  @default_model "gemma4:e2b"
  @ollama_url "http://localhost:11434/api/chat"

  def run(args) do
    # required for network requests to work
    Mix.Task.run("app.start")

    {opts, positional_args, _} = OptionParser.parse(args, switches: [model: :string])

    case positional_args do
      [image_path] ->
        model = opts[:model] || @default_model
        process_image(image_path, model)

      _ ->
        Mix.raise("Usage: mix rekog <path_to_image> [--model <model_name>]")
    end
  end

  defp process_image(path, model) do
    with {:ok, binary_data} <- File.read(path) do
      base64_image = Base.encode64(binary_data)

      payload = %{
        model: model,
        messages: [
          %{
            role: "user",
            # content:
            #   "Describe this image in 5 words using the format: person, place, thing, mood.",
            # content:
            #   "Describe this image in 7 words using the format: person, place, thing, mood, medium.",
            content:
              "Describe this image in 5 words using the format: person, place, thing, mood. If the image is a drawing or a painting also include that at the end.",
            images: [base64_image]
          }
        ],
        stream: false
      }

      Mix.shell().info("Sending request to Ollama using #{model}...")

      case Req.post(@ollama_url, json: payload, receive_timeout: 60_000) do
        {:ok, %{status: 200, body: %{"message" => %{"content" => description}}}} ->
          Mix.shell().info("\n--- Description ---\n")
          Mix.shell().info(description)

        {:ok, %{status: status, body: body}} ->
          Mix.raise("Ollama request failed with status #{status}: #{inspect(body)}")

        {:error, reason} ->
          Mix.raise("Failed to connect to Ollama: #{inspect(reason)}")
      end
    else
      {:error, :enoent} ->
        Mix.raise("File not found at path: #{path}")

      {:error, reason} ->
        Mix.raise("Failed to read image file: #{inspect(reason)}")
    end
  end
end
