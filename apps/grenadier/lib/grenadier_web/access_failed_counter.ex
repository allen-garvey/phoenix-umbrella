defmodule GrenadierWeb.AccessFailedCounter do
  @table :access_failed_table

  # Call this when your application starts (e.g., in application.ex)
  def init do
    :ets.new(@table, [
      :named_table,
      :public,
      read_concurrency: true,
      write_concurrency: true
    ])
  end

  def increment_counter(identifier) do
    # Atomically increment the 2nd element of the tuple.
    :ets.update_counter(@table, identifier, {2, 1}, {identifier, 1})
  end

  def get_count(identifier) do
    case :ets.lookup(@table, identifier) do
      [{_, count}] -> count
      _ -> 0
    end
  end
end
