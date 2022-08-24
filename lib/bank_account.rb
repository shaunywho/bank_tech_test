# frozen_string_literal: true

require 'time'


# BankAccount object is used with the deposit, withdraw and print_statement methods
class BankAccount
  def initialize()
    @transactions = []
    @headers = %w[date credit debit balance]
  end

  def print_statement
    bank_statement = @headers.join(' || ')
    sort_transactions
    balance = 0.0
    @transactions.each do |account_log|
      balance += account_log["credit"] - account_log["debit"]
      bank_statement += generate_line(account_log,
                                 balance)
    end
    print bank_statement
  end

  def deposit(amount)
    # Accepts a AccountLog instance and adds it to the transactions list
    date = Time.now()
    if amount.is_a? Numeric
      @transactions << {"date"=>date, "credit"=>amount, "debit"=>0}
    end 
  end

  def withdraw(amount)
    # Accepts a AccountLog instance and adds it to the transactions list
    date = Time.now()
    if amount.is_a? Numeric
      @transactions << {"date"=>date, "credit"=>0, "debit"=>amount}
    end 
  end

  private

  def sort_transactions
    # sorts transactions by date
    @transactions.sort_by! { |account_log| account_log["date"] }.reverse!
  end

  def generate_line(account_log, balance)
    # generates a line in the print
    date = account_log["date"].strftime('%d/%m/%Y')
    "\n#{date} || #{'%.2f' % account_log["credit"] if account_log["credit"]>0.0 } || #{'%.2f' % account_log["debit"] if account_log["debit"]>0.0} || #{'%.2f' % balance}"
  end
end
