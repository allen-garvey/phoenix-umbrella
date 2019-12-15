defmodule StartpageWeb.FolderView do
  use StartpageWeb, :view

  def content_to_list(folder_content) when is_binary(folder_content) do
    folder_content
    |> String.split("\n")
    |> Enum.filter(&is_valid_line/1)
    |> Enum.map(&parse_line/1)
  end

  @doc """
  Tests if a line is a comment line (starts with #)
  or is empty
  """
  def is_valid_line(line) when is_binary(line) do
    !String.match?(line, ~r/^\s+$|^\s*#/)
  end

  def parse_line(line) when is_binary(line) do
    if String.match?(line, ~r/^====\s+/) do
      tag(:hr)
    else
      parse_link(line)
    end
  end

  def parse_link(line) when is_binary(line) do
    [title, url] = String.split(line, ~r/\s+---\s+/)
    content_tag(:a, title, href: expand_url(url))
  end

  def expand_url(url) when is_binary(url) do
    umbrella_domain = System.get_env("UMBRELLA_COOKIE_DOMAIN", ".umbrella.test")
    String.replace(url, ~r/\$\{UMBRELLA_DOMAIN\}/, umbrella_domain)
  end
end
