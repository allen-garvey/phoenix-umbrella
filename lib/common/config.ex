defmodule Umbrella.Common.Config do
  def secret_key_base() do
    System.get_env("UMBRELLA_SECRET_KEY_BASE", "pTlqYpnNuuhdjjy+uza2Ih+G6GdE8/nYiATPOT6PEAkcWTB4qjtH0+urfiYJwF0X")
  end
end
