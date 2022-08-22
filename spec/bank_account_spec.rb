require "bank_account"
require "account_log"
require "time"
describe BankAccount do

  context "When Bank Account is initalized" do
    before(:each) do
      time = double(:mock_time)
      @bank_account = BankAccount.new(time)
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
      @time = double(:mock_time)
      @bank_account = BankAccount.new(@time)
      @account_log_1 = double(:account, :date => 1, :credit => 1000, :debit =>0)
      @account_log_2 = double(:account, :date => 2, :credit => 200, :debit =>0)
      @account_log_3 = double(:account, :date => 3, :credit => 100, :debit =>0)
    end 
    it "returns bank statement containing a single row when a deposit is made" do
      time_1 = double(:time_of_account_log)
      allow(time_1).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_1.date)
      expect(@time).to receive(:parse).twice.with(@account_log_1.date).and_return(@account_log_1.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(time_1).ordered
      @bank_account.make_transaction(@account_log_1)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n1 || 1000 ||  || 1000"
    end 

    it "returns bank statement containing two entries when two deposits are made" do
      time_1 = double(:time_of_account_log_1)
      time_2 = double(:time_of_account_log_2)
      allow(time_2).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_2.date)
      allow(time_1).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_1.date)
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(@account_log_1.date).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(@account_log_2.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(@account_log_1.date).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(@account_log_2.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(time_1).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(time_2).ordered
      @bank_account.make_transaction(@account_log_1)
      @bank_account.make_transaction(@account_log_2)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n1 || 1000 ||  || 1000\n2 || 200 ||  || 1200"
    end 

  
    it "returns bank statement containing three entries when three deposits are made" do
      time_1 = double(:time_of_account_log_1)
      time_2 = double(:time_of_account_log_2)
      time_3 = double(:time_of_account_log_3)
      allow(time_1).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_1.date)
      allow(time_2).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_2.date)
      allow(time_3).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_3.date)
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(@account_log_1.date).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(@account_log_2.date).ordered
      expect(@time).to receive(:parse).with(@account_log_3.date).and_return(@account_log_3.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(@account_log_1.date).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(@account_log_2.date).ordered
      expect(@time).to receive(:parse).with(@account_log_3.date).and_return(@account_log_3.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(time_1).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(time_2).ordered
      expect(@time).to receive(:parse).with(@account_log_3.date).and_return(time_3).ordered
      @bank_account.make_transaction(@account_log_1)
      @bank_account.make_transaction(@account_log_2)
      @bank_account.make_transaction(@account_log_3)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n1 || 1000 ||  || 1000\n2 || 200 ||  || 1200\n3 || 100 ||  || 1300"
    end 

    it "returns bank statement containing two entries when two deposits are made in the wrong order" do
      time_1 = double(:time_of_account_log_1)
      time_2 = double(:time_of_account_log_2)
      allow(time_1).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_1.date)
      allow(time_2).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_2.date)
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(@account_log_2.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(@account_log_1.date).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(@account_log_2.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(@account_log_1.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(time_1).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(time_2).ordered
      @bank_account.make_transaction(@account_log_2)
      @bank_account.make_transaction(@account_log_1)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n1 || 1000 ||  || 1000\n2 || 200 ||  || 1200"

    end

  end



  context "When Bank Account is initalized and withdrawals are made" do
    before(:each) do

      @time = double(:mock_time)
      @bank_account = BankAccount.new(@time)
      @account_log_1 = double(:account, :date => 1, :credit => 0, :debit =>1000)
      @account_log_2 = double(:account, :date => 2, :credit => 0, :debit =>200)
      @account_log_3 = double(:account, :date => 3, :credit => 0, :debit =>100)
    end 
    it "returns bank statement containing a single row when a withdrawals is made" do
      time_1 = double(:time_of_account_log)
      allow(time_1).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_1.date)
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(@account_log_1.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(@account_log_1.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(time_1).ordered
      @bank_account.make_transaction(@account_log_1)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n1 ||  || 1000 || -1000"
    end 

    it "returns bank statement containing a two entries when two withdrawals are made" do
      time_1 = double(:time_of_account_log_1)
      time_2 = double(:time_of_account_log_2)
      allow(time_2).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_2.date)
      allow(time_1).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_1.date)
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(@account_log_1.date).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(@account_log_2.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(@account_log_1.date).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(@account_log_2.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(time_1).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(time_2).ordered
      @bank_account.make_transaction(@account_log_1)
      @bank_account.make_transaction(@account_log_2)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n1 ||  || 1000 || -1000\n2 ||  || 200 || -1200"
    end 


    it "returns bank statement containing a three entries when three withdrawals are made" do
      time_1 = double(:time_of_account_log_1)
      time_2 = double(:time_of_account_log_2)
      time_3 = double(:time_of_account_log_3)
      allow(time_1).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_1.date)
      allow(time_2).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_2.date)
      allow(time_3).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_3.date)
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(@account_log_1.date).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(@account_log_2.date).ordered
      expect(@time).to receive(:parse).with(@account_log_3.date).and_return(@account_log_3.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(@account_log_1.date).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(@account_log_2.date).ordered
      expect(@time).to receive(:parse).with(@account_log_3.date).and_return(@account_log_3.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(time_1).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(time_2).ordered
      expect(@time).to receive(:parse).with(@account_log_3.date).and_return(time_3).ordered
      @bank_account.make_transaction(@account_log_1)
      @bank_account.make_transaction(@account_log_2)
      @bank_account.make_transaction(@account_log_3)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n1 ||  || 1000 || -1000\n2 ||  || 200 || -1200\n3 ||  || 100 || -1300"

    end 


    it "returns bank statement containing a two entries when two withdrawals are made in the wrong order" do
      time_1 = double(:time_of_account_log_1)
      time_2 = double(:time_of_account_log_2)
      allow(time_1).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_1.date)
      allow(time_2).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_2.date)
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(@account_log_2.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(@account_log_1.date).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(@account_log_2.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(@account_log_1.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(time_1).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(time_2).ordered
      @bank_account.make_transaction(@account_log_2)
      @bank_account.make_transaction(@account_log_1)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n1 ||  || 1000 || -1000\n2 ||  || 200 || -1200"

    end



  end 

  context "When Bank Account is initalized and withdrawals and deposits are made" do
    before(:each) do

      @time = double(:mock_time)
      @bank_account = BankAccount.new(@time)
      @account_log_1 = double(:account, :date => 1, :credit => 0, :debit =>1000)
      @account_log_2 = double(:account, :date => 2, :credit => 200, :debit => 0)
      @account_log_3 = double(:account, :date => 3, :credit => 0, :debit =>100)
    end 

    it "returns bank statement containing a three entries when two withdrawals and one deposit is made" do
      time_1 = double(:time_of_account_log_1)
      time_2 = double(:time_of_account_log_2)
      time_3 = double(:time_of_account_log_3)
      allow(time_1).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_1.date)
      allow(time_2).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_2.date)
      allow(time_3).to receive(:strftime).with("%d/%m/%Y").and_return(@account_log_3.date)
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(@account_log_1.date).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(@account_log_2.date).ordered
      expect(@time).to receive(:parse).with(@account_log_3.date).and_return(@account_log_3.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(@account_log_1.date).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(@account_log_2.date).ordered
      expect(@time).to receive(:parse).with(@account_log_3.date).and_return(@account_log_3.date).ordered
      expect(@time).to receive(:parse).with(@account_log_1.date).and_return(time_1).ordered
      expect(@time).to receive(:parse).with(@account_log_2.date).and_return(time_2).ordered
      expect(@time).to receive(:parse).with(@account_log_3.date).and_return(time_3).ordered
      @bank_account.make_transaction(@account_log_1)
      @bank_account.make_transaction(@account_log_2)
      @bank_account.make_transaction(@account_log_3)
      expect(@bank_account.generate_bank_statement()).to eq "date || credit || debit || balance\n1 ||  || 1000 || -1000\n2 || 200 ||  || -800\n3 ||  || 100 || -900"


    end 

  end




end