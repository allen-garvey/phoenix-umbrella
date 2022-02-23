defmodule Artour.Guggenheim.Filesystem do
    alias Common.MixHelpers.Error
    
    @doc """
    Creates temp directory for converted image
    """
    def create_temp_dir(source_directory_name) do
        temp_dir_name = Path.join(source_directory_name, "__temp__artour-guggenheim")

        if File.exists?(temp_dir_name) do
            Error.exit_with_error("#{temp_dir_name} already exists", :temp_dir_already_exists)
        end

        File.mkdir_p!(temp_dir_name)

        temp_dir_name
    end

    @doc """
    Fix image permissions so read all is enabled
    """
    def fix_permissions(temp_dir) do
        File.ls!(temp_dir)
        |> Enum.map(fn filename -> Path.join(temp_dir, filename) end)
        |> Enum.filter(fn filename -> !File.dir?(filename) end)
        |> Enum.map(fn filename -> File.chmod!(filename, 0o644) end)
    end
end