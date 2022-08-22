require "bank_account"
require "account_log"
require "time"
describe BankAccount do

  context "When Bank Account is initalized" do
    before(:each) do
      @bank_account = BankAccount.new(Time)
    end 
    it "returns header when initialized" do
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance"
    end 
    it "returns an empty list when initialized" do
      expect(@bank_account.account_logs).to eq []
    end 
  end

  context "When Bank Account is initalized and deposits are made" do

    before(:each) do
      @bank_account = BankAccount.new(Time)
      @account_log_1 = AccountLog.new("2022-08-22 15:18:38.401955 +0100",credit=1000, debit = 0)
      @account_log_2 = AccountLog.new("2022-08-22 16:18:38.401955 +0100",credit=200, debit = 0)
      @account_log_3 = AccountLog.new("2022-08-22 17:18:38.401955 +0100",credit = 100, debit=0)
    end 
    it "returns bank statement containing a single row when a deposit is made" do
      
      @bank_account.make_transaction(@account_log_1)
      expect(@bank_account.account_logs.length).to eq(1)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n22/08/2022 || 1000 ||  || 1000"
    end 

    it "returns bank statement containing two entries when two deposits are made" do
      @bank_account.make_transaction(@account_log_1)
      @bank_account.make_transaction(@account_log_2)
      expect(@bank_account.account_logs.length).to eq(2)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n22/08/2022 || 1000 ||  || 1000\n22/08/2022 || 200 ||  || 1200"
    end 
    it "returns bank statement containing three entries when three deposits are made" do
      @bank_account.make_transaction(@account_log_1)
      @bank_account.make_transaction(@account_log_2)
      @bank_account.make_transaction(@account_log_3)
      expect(@bank_account.account_logs.length).to eq(3)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n22/08/2022 || 1000 ||  || 1000\n22/08/2022 || 200 ||  || 1200\n22/08/2022 || 100 ||  || 1300"
    end 

    it "returns bank statement containing two entries when two deposits are made in the wrong order" do
      @bank_account.make_transaction(@account_log_2)
      @bank_account.make_transaction(@account_log_1)
      expect(@bank_account.account_logs.length).to eq(2)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n22/08/2022 || 1000 ||  || 1000\n22/08/2022 || 200 ||  || 1200"

    end

    it "returns bank statement containing two entries when two deposits are made in the wrong order with microsecond difference" do
      account_log_1_us_after = AccountLog.new("2022-08-22 16:18:38.401951 +0100",credit = 200, debit=0)

      @bank_account.make_transaction(account_log_1_us_after)
      @bank_account.make_transaction(@account_log_1)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n22/08/2022 || 1000 ||  || 1000\n22/08/2022 || 200 ||  || 1200"

    end

    it "returns bank statement containing two entries when two withdrawals in different timezones are made" do
      account_log_france = AccountLog.new("2022-08-22 15:18:38.401955 +0200",credit = 3000,debit=0)
      @bank_account.make_transaction(@account_log_1)
      @bank_account.make_transaction(account_log_france)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n22/08/2022 || 3000 ||  || 3000\n22/08/2022 || 1000 ||  || 4000"
    end

  end 

  context "When Bank Account is initalized and withdrawals are made" do
    before(:each) do
      @bank_account = BankAccount.new(Time)
      @account_log_1 = AccountLog.new("2022-08-22 15:18:38.401955 +0100",credit = 0,debit=1000)
      @account_log_2 = AccountLog.new("2022-08-22 16:18:38.401955 +0100",credit = 0, debit=200)
      @account_log_3 = AccountLog.new("2022-08-22 17:18:38.401955 +0100",credit = 0, debit=100)
    end 
    it "returns bank statement containing a single row when a withdrawals is made" do
      
      @bank_account.make_transaction(@account_log_1)
      expect(@bank_account.account_logs.length).to eq(1)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n22/08/2022 ||  || 1000 || -1000"
    end 
    it "returns bank statement containing a two entries when two withdrawals are made" do
      @bank_account.make_transaction(@account_log_1)
      @bank_account.make_transaction(@account_log_2)
      expect(@bank_account.account_logs.length).to eq(2)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n22/08/2022 ||  || 1000 || -1000\n22/08/2022 ||  || 200 || -1200"
    end 

    it "returns bank statement containing a three entries when three withdrawals are made" do
      @bank_account.make_transaction(@account_log_1)
      @bank_account.make_transaction(@account_log_2)
      @bank_account.make_transaction(@account_log_3)
      expect(@bank_account.account_logs.length).to eq(3)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n22/08/2022 ||  || 1000 || -1000\n22/08/2022 ||  || 200 || -1200\n22/08/2022 ||  || 100 || -1300"
    end 

    it "returns bank statement containing a two entries when two withdrawals are made in the wrong order" do
      @bank_account.make_transaction(@account_log_2)
      @bank_account.make_transaction(@account_log_1)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n22/08/2022 ||  || 1000 || -1000\n22/08/2022 ||  || 200 || -1200"

    end

    it "returns bank statement containing a two entries when two withdrawals are made in the wrong order with microsecond difference" do
      account_log_1_us_after = AccountLog.new("2022-08-22 16:18:38.401951 +0100",credit = 0, debit=200)
      @bank_account.make_transaction(account_log_1_us_after)
      @bank_account.make_transaction(@account_log_1)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n22/08/2022 ||  || 1000 || -1000\n22/08/2022 ||  || 200 || -1200"
    end
  
    it "returns bank statement containing a two entries when two withdrawals in different timezones are made" do
      account_log_france = AccountLog.new("2022-08-22 15:18:38.401955 +0200",credit = 0,debit=3000)
      @bank_account.make_transaction(@account_log_1)
      @bank_account.make_transaction(account_log_france)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n22/08/2022 ||  || 3000 || -3000\n22/08/2022 ||  || 1000 || -4000"
    end

  end 

  context "When Bank Account is initialized, entries with incorrect data types are rejected" do
    before(:each) do
      @bank_account = BankAccount.new(Time)
      @account_log_1 = AccountLog.new("2022-08-22 15:18:38.401955 +0100",credit=1000, debit = 0)
      @account_log_2 = AccountLog.new("2022-08-22 16:18:38.401955 +0100",credit=200, debit = 0)
      @account_log_3 = AccountLog.new("2022-08-22 17:18:38.401955 +0100",credit = 100, debit=0)
    end 

    it "returns a bank statement containing two entries when three withdrawals are made but one has an incorrect date" do
      account_log_3 = AccountLog.new("A",credit = 100, debit=0)
      @bank_account.make_transaction(@account_log_1)
      @bank_account.make_transaction(@account_log_2)
      @bank_account.make_transaction(account_log_3)
      expect(@bank_account.account_logs.length).to eq(2)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n22/08/2022 || 1000 ||  || 1000\n22/08/2022 || 200 ||  || 1200"
    end 

    it "returns a bank statement containing two entries when three withdrawals are made but one has a credit amount that is non-numeric" do
      account_log_3 = AccountLog.new("2022-08-22 17:18:38.401955 +0100",credit = "100", debit=0)
      @bank_account.make_transaction(@account_log_1)
      @bank_account.make_transaction(@account_log_2)
      @bank_account.make_transaction(account_log_3)
      expect(@bank_account.account_logs.length).to eq(2)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n22/08/2022 || 1000 ||  || 1000\n22/08/2022 || 200 ||  || 1200"
    end 


  end 


end