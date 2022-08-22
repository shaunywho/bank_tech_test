# frozen_string_literal: true

require 'bank_account'
require 'account_log'
require 'time'
describe BankAccount do
  context 'When Bank Account is initalized' do
    before(:each) do
      @bank_account = BankAccount.new(Time)
    end
    it 'returns header when initialized' do
      expect(@bank_account.generate_bank_statement).to eq 'date || credit || debit || balance'
    end
    it 'returns an empty list when initialized' do
      expect(@bank_account.account_logs).to eq []
    end
  end

  context 'When Bank Account is initalized and deposits are made' do
    before(:each) do
      @bank_account = BankAccount.new(Time)
      @account1_log = AccountLog.new('2022-08-22 15:18:38.401955 +0100', 1000, 0)
      @account2_log = AccountLog.new('2022-08-22 16:18:38.401955 +0100', 200, 0)
      @account3_log = AccountLog.new('2022-08-22 17:18:38.401955 +0100', 100, 0)
    end
    it 'returns bank statement containing a single row when a deposit is made' do
      @bank_account.make_transaction(@account1_log)
      expect(@bank_account.account_logs.length).to eq(1)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n22/08/2022 || 1000 ||  || 1000"
    end

    it 'returns bank statement containing two entries when two deposits are made' do
      @bank_account.make_transaction(@account1_log)
      @bank_account.make_transaction(@account2_log)
      expect(@bank_account.account_logs.length).to eq(2)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n22/08/2022 || 1000 ||  || 1000\n22/08/2022 || 200 ||  || 1200"
    end
    it 'returns bank statement containing three entries when three deposits are made' do
      @bank_account.make_transaction(@account1_log)
      @bank_account.make_transaction(@account2_log)
      @bank_account.make_transaction(@account3_log)
      expect(@bank_account.account_logs.length).to eq(3)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n22/08/2022 || 1000 ||  || 1000\n22/08/2022 || 200 ||  || 1200\n22/08/2022 || 100 ||  || 1300"
    end

    it 'returns bank statement containing two entries when two deposits are made in the wrong order' do
      @bank_account.make_transaction(@account2_log)
      @bank_account.make_transaction(@account1_log)
      expect(@bank_account.account_logs.length).to eq(2)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n22/08/2022 || 1000 ||  || 1000\n22/08/2022 || 200 ||  || 1200"
    end

    it 'returns bank statement containing two entries when two deposits are made in the wrong order with microsecond difference' do
      account_log_1_us_after = AccountLog.new('2022-08-22 16:18:38.401951 +0100', 200, 0)

      @bank_account.make_transaction(account_log_1_us_after)
      @bank_account.make_transaction(@account1_log)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n22/08/2022 || 1000 ||  || 1000\n22/08/2022 || 200 ||  || 1200"
    end

    it 'returns bank statement containing two entries when two withdrawals in different timezones are made' do
      account_log_france = AccountLog.new('2022-08-22 15:18:38.401955 +0200', 3000, 0)
      @bank_account.make_transaction(@account1_log)
      @bank_account.make_transaction(account_log_france)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n22/08/2022 || 3000 ||  || 3000\n22/08/2022 || 1000 ||  || 4000"
    end
  end

  context 'When Bank Account is initalized and withdrawals are made' do
    before(:each) do
      @bank_account = BankAccount.new(Time)
      @account1_log = AccountLog.new('2022-08-22 15:18:38.401955 +0100', 0, 1000)
      @account2_log = AccountLog.new('2022-08-22 16:18:38.401955 +0100', 0, 200)
      @account3_log = AccountLog.new('2022-08-22 17:18:38.401955 +0100', 0, 100)
    end
    it 'returns bank statement containing a single row when a withdrawals is made' do
      @bank_account.make_transaction(@account1_log)
      expect(@bank_account.account_logs.length).to eq(1)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n22/08/2022 ||  || 1000 || -1000"
    end
    it 'returns bank statement containing a two entries when two withdrawals are made' do
      @bank_account.make_transaction(@account1_log)
      @bank_account.make_transaction(@account2_log)
      expect(@bank_account.account_logs.length).to eq(2)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n22/08/2022 ||  || 1000 || -1000\n22/08/2022 ||  || 200 || -1200"
    end

    it 'returns bank statement containing a three entries when three withdrawals are made' do
      @bank_account.make_transaction(@account1_log)
      @bank_account.make_transaction(@account2_log)
      @bank_account.make_transaction(@account3_log)
      expect(@bank_account.account_logs.length).to eq(3)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n22/08/2022 ||  || 1000 || -1000\n22/08/2022 ||  || 200 || -1200\n22/08/2022 ||  || 100 || -1300"
    end

    it 'returns bank statement containing a two entries when two withdrawals are made in the wrong order' do
      @bank_account.make_transaction(@account2_log)
      @bank_account.make_transaction(@account1_log)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n22/08/2022 ||  || 1000 || -1000\n22/08/2022 ||  || 200 || -1200"
    end

    it 'returns bank statement containing a two entries when two withdrawals are made in the wrong order with microsecond difference' do
      account_log_1_us_after = AccountLog.new('2022-08-22 16:18:38.401951 +0100', 0, 200)
      @bank_account.make_transaction(account_log_1_us_after)
      @bank_account.make_transaction(@account1_log)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n22/08/2022 ||  || 1000 || -1000\n22/08/2022 ||  || 200 || -1200"
    end

    it 'returns bank statement containing a two entries when two withdrawals in different timezones are made' do
      account_log_france = AccountLog.new('2022-08-22 15:18:38.401955 +0200', 0, 3000)
      @bank_account.make_transaction(@account1_log)
      @bank_account.make_transaction(account_log_france)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n22/08/2022 ||  || 3000 || -3000\n22/08/2022 ||  || 1000 || -4000"
    end
  end

  context 'When Bank Account is initialized, entries with incorrect data types are rejected' do
    before(:each) do
      @bank_account = BankAccount.new(Time)
      @account1_log = AccountLog.new('2022-08-22 15:18:38.401955 +0100', 1000, 0)
      @account2_log = AccountLog.new('2022-08-22 16:18:38.401955 +0100', 200, 0)
      @account3_log = AccountLog.new('2022-08-22 17:18:38.401955 +0100', 100, 0)
    end

    it 'returns a bank statement containing two entries when three withdrawals are made but one has an incorrect date' do
      account3_log = AccountLog.new('A', 100, 0)
      @bank_account.make_transaction(@account1_log)
      @bank_account.make_transaction(@account2_log)
      @bank_account.make_transaction(account3_log)
      expect(@bank_account.account_logs.length).to eq(2)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n22/08/2022 || 1000 ||  || 1000\n22/08/2022 || 200 ||  || 1200"
    end

    it 'returns a bank statement containing two entries when three withdrawals are made but one has a credit amount that is non-numeric' do
      account3_log = AccountLog.new('2022-08-22 17:18:38.401955 +0100', '100', 0)
      @bank_account.make_transaction(@account1_log)
      @bank_account.make_transaction(@account2_log)
      @bank_account.make_transaction(account3_log)
      expect(@bank_account.account_logs.length).to eq(2)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n22/08/2022 || 1000 ||  || 1000\n22/08/2022 || 200 ||  || 1200"
    end
  end
end
