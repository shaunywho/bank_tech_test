# frozen_string_literal: true

require 'bank_account'
require 'account_log'
require 'time'
describe BankAccount do
  context 'When Bank Account is initalized' do
    before(:each) do
      time = double(:mock_time)
      @bank_account = BankAccount.new(time)
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
      @time = double(:mock_time)
      @bank_account = BankAccount.new(@time)
      @account1_log = double(:account, date: 1.0, credit: 1000.0, debit: 0.0)
      @account2_log = double(:account, date: 2.0, credit: 200.0, debit: 0.0)
      @account3_log = double(:account, date: 3.0, credit: 100.0, debit: 0.0)
    end
    it 'returns bank statement containing a single row when a deposit is made' do
      time1 = double(:time_of_account_log)
      allow(time1).to receive(:strftime).with('%d/%m/%Y').and_return(@account1_log.date)
      expect(@time).to receive(:parse).twice.with(@account1_log.date).and_return(@account1_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(time1).ordered
      @bank_account.make_transaction(@account1_log)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n1.0 || 1000.00 ||  || 1000.00"
    end

    it 'returns bank statement containing two entries when two deposits are made' do
      time1 = double(:time_of_account1_log)
      time2 = double(:time_of_account2_log)
      allow(time2).to receive(:strftime).with('%d/%m/%Y').and_return(@account2_log.date)
      allow(time1).to receive(:strftime).with('%d/%m/%Y').and_return(@account1_log.date)
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(@account1_log.date).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(@account2_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(@account1_log.date).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(@account2_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(time1).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(time2).ordered
      @bank_account.make_transaction(@account1_log)
      @bank_account.make_transaction(@account2_log)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n1.0 || 1000.00 ||  || 1000.00\n2.0 || 200.00 ||  || 1200.00"
    end

    it 'returns bank statement containing three entries when three deposits are made' do
      time1 = double(:time_of_account1_log)
      time2 = double(:time_of_account2_log)
      time3 = double(:time_of_account3_log)
      allow(time1).to receive(:strftime).with('%d/%m/%Y').and_return(@account1_log.date)
      allow(time2).to receive(:strftime).with('%d/%m/%Y').and_return(@account2_log.date)
      allow(time3).to receive(:strftime).with('%d/%m/%Y').and_return(@account3_log.date)
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(@account1_log.date).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(@account2_log.date).ordered
      expect(@time).to receive(:parse).with(@account3_log.date).and_return(@account3_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(@account1_log.date).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(@account2_log.date).ordered
      expect(@time).to receive(:parse).with(@account3_log.date).and_return(@account3_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(time1).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(time2).ordered
      expect(@time).to receive(:parse).with(@account3_log.date).and_return(time3).ordered
      @bank_account.make_transaction(@account1_log)
      @bank_account.make_transaction(@account2_log)
      @bank_account.make_transaction(@account3_log)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n1.0 || 1000.00 ||  || 1000.00\n2.0 || 200.00 ||  || 1200.00\n3.0 || 100.00 ||  || 1300.00"
    end

    it 'returns bank statement containing two entries when two deposits are made in the wrong order' do
      time1 = double(:time_of_account1_log)
      time2 = double(:time_of_account2_log)
      allow(time1).to receive(:strftime).with('%d/%m/%Y').and_return(@account1_log.date)
      allow(time2).to receive(:strftime).with('%d/%m/%Y').and_return(@account2_log.date)
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(@account2_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(@account1_log.date).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(@account2_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(@account1_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(time1).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(time2).ordered
      @bank_account.make_transaction(@account2_log)
      @bank_account.make_transaction(@account1_log)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n1.0 || 1000.00 ||  || 1000.00\n2.0 || 200.00 ||  || 1200.00"
    end
  end

  context 'When Bank Account is initalized and withdrawals are made' do
    before(:each) do
      @time = double(:mock_time)
      @bank_account = BankAccount.new(@time)
      @account1_log = double(:account, date: 1.0, credit: 0.0, debit: 1000.0)
      @account2_log = double(:account, date: 2.0, credit: 0.0, debit: 200.0)
      @account3_log = double(:account, date: 3.0, credit: 0.0, debit: 100.0)
    end
    it 'returns bank statement containing a single row when a withdrawals is made' do
      time1 = double(:time_of_account_log)
      allow(time1).to receive(:strftime).with('%d/%m/%Y').and_return(@account1_log.date)
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(@account1_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(@account1_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(time1).ordered
      @bank_account.make_transaction(@account1_log)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n1.0 ||  || 1000.00 || -1000.00"
    end

    it 'returns bank statement containing a two entries when two withdrawals are made' do
      time1 = double(:time_of_account1_log)
      time2 = double(:time_of_account2_log)
      allow(time2).to receive(:strftime).with('%d/%m/%Y').and_return(@account2_log.date)
      allow(time1).to receive(:strftime).with('%d/%m/%Y').and_return(@account1_log.date)
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(@account1_log.date).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(@account2_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(@account1_log.date).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(@account2_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(time1).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(time2).ordered
      @bank_account.make_transaction(@account1_log)
      @bank_account.make_transaction(@account2_log)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n1.0 ||  || 1000.00 || -1000.00\n2.0 ||  || 200.00 || -1200.00"
    end

    it 'returns bank statement containing a three entries when three withdrawals are made' do
      time1 = double(:time_of_account1_log)
      time2 = double(:time_of_account2_log)
      time3 = double(:time_of_account3_log)
      allow(time1).to receive(:strftime).with('%d/%m/%Y').and_return(@account1_log.date)
      allow(time2).to receive(:strftime).with('%d/%m/%Y').and_return(@account2_log.date)
      allow(time3).to receive(:strftime).with('%d/%m/%Y').and_return(@account3_log.date)
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(@account1_log.date).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(@account2_log.date).ordered
      expect(@time).to receive(:parse).with(@account3_log.date).and_return(@account3_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(@account1_log.date).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(@account2_log.date).ordered
      expect(@time).to receive(:parse).with(@account3_log.date).and_return(@account3_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(time1).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(time2).ordered
      expect(@time).to receive(:parse).with(@account3_log.date).and_return(time3).ordered
      @bank_account.make_transaction(@account1_log)
      @bank_account.make_transaction(@account2_log)
      @bank_account.make_transaction(@account3_log)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n1.0 ||  || 1000.00 || -1000.00\n2.0 ||  || 200.00 || -1200.00\n3.0 ||  || 100.00 || -1300.00"
    end

    it 'returns bank statement containing a two entries when two withdrawals are made in the wrong order' do
      time1 = double(:time_of_account1_log)
      time2 = double(:time_of_account2_log)
      allow(time1).to receive(:strftime).with('%d/%m/%Y').and_return(@account1_log.date)
      allow(time2).to receive(:strftime).with('%d/%m/%Y').and_return(@account2_log.date)
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(@account2_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(@account1_log.date).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(@account2_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(@account1_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(time1).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(time2).ordered
      @bank_account.make_transaction(@account2_log)
      @bank_account.make_transaction(@account1_log)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n1.0 ||  || 1000.00 || -1000.00\n2.0 ||  || 200.00 || -1200.00"
    end
  end

  context 'When Bank Account is initalized and withdrawals and deposits are made' do
    before(:each) do
      @time = double(:mock_time)
      @bank_account = BankAccount.new(@time)
      @account1_log = double(:account, date: 1.0, credit: 0.0, debit: 1000.0)
      @account2_log = double(:account, date: 2.0, credit: 200.0, debit: 0.0)
      @account3_log = double(:account, date: 3.0, credit: 0.0, debit: 100.0)
    end

    it 'returns bank statement containing a three entries when two withdrawals and one deposit is made' do
      time1 = double(:time_of_account1_log)
      time2 = double(:time_of_account2_log)
      time3 = double(:time_of_account3_log)
      allow(time1).to receive(:strftime).with('%d/%m/%Y').and_return(@account1_log.date)
      allow(time2).to receive(:strftime).with('%d/%m/%Y').and_return(@account2_log.date)
      allow(time3).to receive(:strftime).with('%d/%m/%Y').and_return(@account3_log.date)
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(@account1_log.date).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(@account2_log.date).ordered
      expect(@time).to receive(:parse).with(@account3_log.date).and_return(@account3_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(@account1_log.date).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(@account2_log.date).ordered
      expect(@time).to receive(:parse).with(@account3_log.date).and_return(@account3_log.date).ordered
      expect(@time).to receive(:parse).with(@account1_log.date).and_return(time1).ordered
      expect(@time).to receive(:parse).with(@account2_log.date).and_return(time2).ordered
      expect(@time).to receive(:parse).with(@account3_log.date).and_return(time3).ordered
      @bank_account.make_transaction(@account1_log)
      @bank_account.make_transaction(@account2_log)
      @bank_account.make_transaction(@account3_log)
      expect(@bank_account.generate_bank_statement).to eq "date || credit || debit || balance\n1.0 ||  || 1000.00 || -1000.00\n2.0 || 200.00 ||  || -800.00\n3.0 ||  || 100.00 || -900.00"
    end
  end
end
