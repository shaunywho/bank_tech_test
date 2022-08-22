# frozen_string_literal: true

require_relative './account_log'
require 'time'

# Stores AccountLog instances with the make_transaction() method
# Display them as a sorted bank statement using generate_bank_statement()
class BankAccount
  attr_reader :account_logs

  def initialize(time_class)
    @account_logs = []
    @headers = %w[date credit debit balance]
    @time_class = time_class
  end

  def generate_bank_statement
    bank_statement = @headers.join(' || ')
    sort_account_logs
    balance = 0.0
    @account_logs.each do |account_log|
      balance += account_log.credit - account_log.debit
      bank_statement += generate_line(account_log,
                                 balance)
    end
    bank_statement
  end

  def make_transaction(account_log)
    # Accepts a AccountLog instance and adds it to the account_logs list
    begin
      date_valid = @time_class.parse(account_log.date)
    rescue ArgumentError
      date_valid = false
    end
    @account_logs << account_log if date_valid && (account_log.credit.is_a? Numeric) && (account_log.debit.is_a? Numeric)
  end

  private

  def sort_account_logs
    @account_logs.sort_by! { |account_log| @time_class.parse(account_log.date) }
  end

  def generate_line(account_log, balance)
    date = @time_class.parse(account_log.date).strftime('%d/%m/%Y')
    "\n#{date} || #{'%.2f' % account_log.credit if account_log.credit>0.0 } || #{'%.2f' % account_log.debit if account_log.debit>0.0} || #{'%.2f' % balance}"
  end
end
