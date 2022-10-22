defmodule Common.ModelHelpers.NumberTest do
  use ExUnit.Case

  describe "format_currency" do
    test "format_currency handles decimal number with no fraction" do
      currency = Common.ModelHelpers.Number.format_currency(Decimal.new(0))
      assert currency == "$0"
    end

    test "format_currency handles decimal number with fraction" do
      currency = Common.ModelHelpers.Number.format_currency(Decimal.new("156.56"))
      assert currency == "$156.56"
    end

    test "format_currency handles large decimal number with no fraction" do
      currency = Common.ModelHelpers.Number.format_currency(Decimal.new(849304))
      assert currency == "$849,304"
    end

    test "format_currency handles large decimal number with fraction" do
      currency = Common.ModelHelpers.Number.format_currency(Decimal.new("7845304.30"))
      assert currency == "$7,845,304.30"
    end
  end
end
  