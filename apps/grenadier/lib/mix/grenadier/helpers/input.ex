defmodule Mix.Tasks.Grenadier.Helpers.Input do
    def get_input_with_min_length(prompt, min_length) when is_binary(prompt) and is_integer(min_length) do
        get_input_with_min_length_helper(prompt, min_length)
    end

    defp get_input_with_min_length_helper(prompt, min_length) do
        case get_input(prompt) |> validate_min_length(min_length) do
            {:error, :length_error} -> 
                IO.puts("Input must be at least #{min_length} characters.")
                get_input_with_min_length_helper(prompt, min_length)
            {:ok, input} -> input
        end
    end

    defp get_input(prompt) do
        case IO.gets(prompt) do
            :eof -> raise "Getting input failed due to encountering end of file."
            {:error, reason} -> raise "Getting input failed for #{reason}."
            data -> String.trim_trailing(data)     
        end
    end

    defp validate_min_length(input, min_length) do
        cond do
            String.length(input) < min_length -> {:error, :length_error}
            true -> {:ok, input}
        end
    end
end