require 'bank_account'
require 'time'
describe BankAccount do
  context 'When Bank Account is initalized' do
    before(:each) do
      @bank_account = BankAccount.new()
    end
    it 'returns header when initialized' do
      expect { @bank_account.print_statement }.to output('date || credit || debit || balance').to_stdout
      
    end

  end

 context 'When Bank Account is initalized and deposits are made' do
    before(:each) do
      @bank_account = BankAccount.new()
      @time1,@time2,@time3 = Time.parse('2022-08-22 15:18:38.401955 +0100'),Time.parse('2022-08-22 16:18:38.401955 +0100'),Time.parse('2022-08-22 16:18:38.401955 +0100')
    end
    it 'returns bank statement containing a single row when a deposit is made' do
      expect(Time).to receive(:now).and_return(@time1).ordered
      @bank_account.deposit(1000)
      expect { @bank_account.print_statement }.to output("date || credit || debit || balance\n22/08/2022 || 1000.00 ||  || 1000.00").to_stdout
    end

    it 'returns bank statement containing two entries when two deposits are made' do
      expect(Time).to receive(:now).and_return(@time1).ordered
      expect(Time).to receive(:now).and_return(@time2).ordered
      @bank_account.deposit(1000)
      @bank_account.deposit(200)
      expect { @bank_account.print_statement }.to output("date || credit || debit || balance\n22/08/2022 || 200.00 ||  || 1200.00\n22/08/2022 || 1000.00 ||  || 1000.00").to_stdout
    end

    it 'returns bank statement containing three entries when three deposits are made' do
      expect(Time).to receive(:now).and_return(@time1).ordered
      expect(Time).to receive(:now).and_return(@time2).ordered
      expect(Time).to receive(:now).and_return(@time3).ordered
      @bank_account.deposit(1000)
      @bank_account.deposit(200)
      @bank_account.deposit(100)
      expect { @bank_account.print_statement }.to output("date || credit || debit || balance\n22/08/2022 || 100.00 ||  || 1300.00\n22/08/2022 || 200.00 ||  || 1200.00\n22/08/2022 || 1000.00 ||  || 1000.00").to_stdout


    end

    it 'returns bank statement containing two entries when two deposits are made in the wrong order' do
      expect(Time).to receive(:now).and_return(@time2).ordered
      expect(Time).to receive(:now).and_return(@time1).ordered
      @bank_account.deposit(200)
      @bank_account.deposit(1000)
      expect { @bank_account.print_statement }.to output("date || credit || debit || balance\n22/08/2022 || 200.00 ||  || 1200.00\n22/08/2022 || 1000.00 ||  || 1000.00").to_stdout
    end
  end

  context 'When Bank Account is initalized and withdrawals are made' do
    before(:each) do
      @bank_account = BankAccount.new()
      @time1,@time2,@time3 = Time.parse('2022-08-22 15:18:38.401955 +0100'),Time.parse('2022-08-22 16:18:38.401955 +0100'),Time.parse('2022-08-22 16:18:38.401955 +0100')
    end
    it 'returns bank statement containing a single row when a withdrawals is made' do
      expect(Time).to receive(:now).and_return(@time1).ordered
      @bank_account.withdraw(1000)
      expect { @bank_account.print_statement }.to output("date || credit || debit || balance\n22/08/2022 ||  || 1000.00 || -1000.00").to_stdout
    end

    it 'returns bank statement containing a two entries when two withdrawals are made' do

      expect(Time).to receive(:now).and_return(@time1).ordered
      expect(Time).to receive(:now).and_return(@time2).ordered
      @bank_account.withdraw(1000)
      @bank_account.withdraw(200)
      expect { @bank_account.print_statement }.to output("date || credit || debit || balance\n22/08/2022 ||  || 200.00 || -1200.00\n22/08/2022 ||  || 1000.00 || -1000.00").to_stdout
    end

    it 'returns bank statement containing a three entries when three withdrawals are made' do
      expect(Time).to receive(:now).and_return(@time1).ordered
      expect(Time).to receive(:now).and_return(@time2).ordered
      expect(Time).to receive(:now).and_return(@time3).ordered
      @bank_account.withdraw(1000)
      @bank_account.withdraw(200)
      @bank_account.withdraw(100)
      expect { @bank_account.print_statement }.to output("date || credit || debit || balance\n22/08/2022 ||  || 100.00 || -1300.00\n22/08/2022 ||  || 200.00 || -1200.00\n22/08/2022 ||  || 1000.00 || -1000.00").to_stdout
    end

    it 'returns bank statement containing a two entries when two withdrawals are made in the wrong order' do
      expect(Time).to receive(:now).and_return(@time2).ordered
      expect(Time).to receive(:now).and_return(@time1).ordered
      @bank_account.withdraw(200)
      @bank_account.withdraw(1000)
      expect { @bank_account.print_statement }.to output("date || credit || debit || balance\n22/08/2022 ||  || 200.00 || -1200.00\n22/08/2022 ||  || 1000.00 || -1000.00").to_stdout
    end
  end

  context 'When Bank Account is initalized and withdrawals and deposits are made' do
    before(:each) do
      @bank_account = BankAccount.new()
      @time1,@time2,@time3 = Time.parse('2022-08-22 15:18:38.401955 +0100'),Time.parse('2022-08-22 16:18:38.401955 +0100'),Time.parse('2022-08-22 16:18:38.401955 +0100')
    end

    it 'returns bank statement containing a three entries when two withdrawals and one deposit is made' do

      expect(Time).to receive(:now).and_return(@time1).ordered
      expect(Time).to receive(:now).and_return(@time2).ordered
      expect(Time).to receive(:now).and_return(@time3).ordered
      @bank_account.withdraw(1000.0)
      @bank_account.deposit(200.0)
      @bank_account.withdraw(100.0)
      expect { @bank_account.print_statement }.to output("date || credit || debit || balance\n22/08/2022 ||  || 100.00 || -900.00\n22/08/2022 || 200.00 ||  || -800.00\n22/08/2022 ||  || 1000.00 || -1000.00").to_stdout
    end

    it 'returns bank statement containing a two entries when a withdrawal and deposit are made in the wrong order with microsecond difference' do
      time1_us_after =Time.parse('2022-08-22 15:18:38.401956 +0100')
      expect(Time).to receive(:now).and_return(time1_us_after).ordered
      expect(Time).to receive(:now).and_return(@time1).ordered
      @bank_account.withdraw(1000)
      @bank_account.deposit(300)
      expect { @bank_account.print_statement }.to output("date || credit || debit || balance\n22/08/2022 ||  || 1000.00 || -700.00\n22/08/2022 || 300.00 ||  || 300.00").to_stdout
    end

    it 'returns bank statement containing a two entries when two withdrawals in different timezones are made' do
      time1_us_france = Time.parse('2022-08-22 15:18:38.401955 +0200')
      expect(Time).to receive(:now).and_return(@time1).ordered
      expect(Time).to receive(:now).and_return(time1_us_france).ordered
      @bank_account.withdraw(1000)
      @bank_account.deposit(300)
      expect { @bank_account.print_statement }.to output("date || credit || debit || balance\n22/08/2022 ||  || 1000.00 || -700.00\n22/08/2022 || 300.00 ||  || 300.00").to_stdout
    end
  end

  context 'When Bank Account is initialized, deposits with incorrect data types are rejected' do
    before(:each) do
      @bank_account = BankAccount.new()
      @time1,@time2,@time3 = Time.parse('2022-08-22 15:18:38.401955 +0100'),Time.parse('2022-08-22 16:18:38.401955 +0100'),Time.parse('2022-08-22 16:18:38.401955 +0100')
    end

    it 'returns a bank statement containing two entries when three withdrawals are made but one has an incorrect date' do
      expect(Time).to receive(:now).and_return(@time1).ordered
      expect(Time).to receive(:now).and_return(@time2).ordered
      expect(Time).to receive(:now).and_return(@time3).ordered
      @bank_account.deposit(1000)
      @bank_account.deposit(200)
      @bank_account.deposit('A')
      expect { @bank_account.print_statement }.to output("date || credit || debit || balance\n22/08/2022 || 200.00 ||  || 1200.00\n22/08/2022 || 1000.00 ||  || 1000.00").to_stdout
    end

    it 'returns a bank statement containing two entries when three withdrawals are made but one has a credit amount that is non-numeric' do
      expect(Time).to receive(:now).and_return(@time1).ordered
      expect(Time).to receive(:now).and_return(@time2).ordered
      expect(Time).to receive(:now).and_return(@time3).ordered
      @bank_account.deposit(1000)
      @bank_account.deposit(200)
      @bank_account.deposit('100')
      expect { @bank_account.print_statement }.to output("date || credit || debit || balance\n22/08/2022 || 200.00 ||  || 1200.00\n22/08/2022 || 1000.00 ||  || 1000.00").to_stdout
    end
  end
  context 'When Bank Account is initialized, withdrawals with incorrect data types are rejected' do
    before(:each) do
      @bank_account = BankAccount.new()
      @time1,@time2,@time3 = Time.parse('2022-08-22 15:18:38.401955 +0100'),Time.parse('2022-08-22 16:18:38.401955 +0100'),Time.parse('2022-08-22 16:18:38.401955 +0100')
    end

    it 'returns a bank statement containing two entries when three withdrawals are made but one has an incorrect date' do
      expect(Time).to receive(:now).and_return(@time1).ordered
      expect(Time).to receive(:now).and_return(@time2).ordered
      expect(Time).to receive(:now).and_return(@time3).ordered
      @bank_account.withdraw(1000)
      @bank_account.withdraw(200)
      @bank_account.withdraw('A')
      expect { @bank_account.print_statement }.to output("date || credit || debit || balance\n22/08/2022 ||  || 200.00 || -1200.00\n22/08/2022 ||  || 1000.00 || -1000.00").to_stdout
    end

    it 'returns a bank statement containing two entries when three withdrawals are made but one has a credit amount that is non-numeric' do
      expect(Time).to receive(:now).and_return(@time1).ordered
      expect(Time).to receive(:now).and_return(@time2).ordered
      expect(Time).to receive(:now).and_return(@time3).ordered
      @bank_account.withdraw(1000)
      @bank_account.withdraw(200)
      @bank_account.withdraw('100')
      expect { @bank_account.print_statement }.to output("date || credit || debit || balance\n22/08/2022 ||  || 200.00 || -1200.00\n22/08/2022 ||  || 1000.00 || -1000.00").to_stdout
    end
  end
end
