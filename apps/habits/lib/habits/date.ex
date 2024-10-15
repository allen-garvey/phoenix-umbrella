defmodule Habits.Date do
    def date_from(year, month) when is_binary(year) and is_binary(month) do
        case {Integer.parse(year), Integer.parse(month)} do
            {{year_int, _}, {month_int, _}} -> Date.new(year_int, month_int, 1)
            _ -> {:error, :non_number_year_or_month}
        end
    end

    def sunday_before(date) do
        day_of_week = Date.day_of_week(date, :sunday)
        Date.add(date, 1 - day_of_week)
    end

    def saturday_after_end_of_month(date) do
        end_of_month = Date.end_of_month(date)
        day_of_week = Date.day_of_week(end_of_month, :sunday)
        Date.add(end_of_month, 7 - day_of_week)
    end
end