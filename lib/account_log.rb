# frozen_string_literal: true

# Acts as a model for a withdrawal/deposit
class AccountLog
  attr_reader :date, :credit, :debit

  def initialize(date, credit, debit)
    @date = date
    @credit = credit
    @debit = debit
  end
end
