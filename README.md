# bank_tech_test

Ensure that rspec is installed.

There is a single class BankAccount which handles deposits and withdrawals and printing of the bank statement

A BankAccount instance has three public methods deposit(amount), withdraw(amount) and print_statement(). deposit(amount) takes an amount and denotes credit into the account, withdraw(amount) takes an amount and denotes the debit from the account. print_statement() prints the deposit and withdraw logs along with the balance held at the time of each transactions, and these logs are printed in order of the most recent transaction. The class is used in the following manner

```Ruby
bank_account = BankAccount.new
bank_account.withdraw(1000)
bank_account.deposit(200)
bank_account.withdraw(500)
bank_account.generate_bank_statement()
=begin
=> date || credit || debit || balance
24/08/2022 ||  || 500.00 || -1300.00
24/08/2022 || 200.00 ||  || -800.00
24/08/2022 ||  || 1000.00 || -1000.00
=end

```

[screenshot](https://github.com/shaunywho/bank_tech_test/blob/main/bank_tech_test.png?raw=true)
