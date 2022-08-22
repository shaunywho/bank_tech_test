require_relative "./account_log"
require 'time'
time_class = Time
class BankAccount
  attr_reader :headers, :account_logs
  def initialize(time_class)
    @account_logs = []
    @headers = ["date", "credit", "debit", "balance"]
    @time_class = time_class
  end 

  def generate_bank_statement()
    statement = @headers.join(" || ")
    self.sort_account_logs()
    balance = 0
    @account_logs.each do |account_log|
      balance+= account_log.credit - account_log.debit
      statement+= "\n#{@time_class.parse(account_log.date).strftime("%d/%m/%Y")} || #{account_log.credit if account_log.credit>0} || #{account_log.debit if account_log.debit > 0} || #{balance}"
    end
    return statement
  end 

  def make_transaction(account_log)
    # Accepts a AccountLog instance and adds it to the account_logs list
    begin
      date = @time_class.parse(account_log.date)
    rescue ArgumentError
      date = false
    end
    if (date && (account_log.credit.is_a? Numeric) && (account_log.debit.is_a? Numeric))
      @account_logs << account_log
    end
  end 

  private
  def sort_account_logs()
    @account_logs.sort_by!{|account_log| @time_class.parse(account_log.date)}
  end 
end

