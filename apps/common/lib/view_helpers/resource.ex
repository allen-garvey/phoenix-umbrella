defmodule Common.ViewHelpers.Resource do
    @doc """
    Gets ecto resource if loaded or default value
    """
    def get_maybe_loaded_or_default(resource, default_value) do
        case resource do
            %Ecto.Association.NotLoaded{} -> default_value
            _ -> resource
        end
    end
end