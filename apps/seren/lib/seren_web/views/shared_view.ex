defmodule SerenWeb.SharedView do
  use SerenWeb, :view

  def datetime_to_utc_date(nil) do
  	nil
  end

  def datetime_to_utc_date(datetime) do
    NaiveDateTime.to_date(datetime)
    |> Date.to_iso8601()
  end
end
