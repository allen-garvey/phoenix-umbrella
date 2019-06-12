defmodule SerenWeb.SharedView do
  use SerenWeb, :view

  def datetime_to_utc_date(nil) do
  	nil
  end

  def datetime_to_utc_date(datetime) do
  	"#{datetime.year}-#{datetime.month}-#{datetime.day}"
  end
end
