# bank_tech_test

Ensure that rspec is installed.

There are two classes: BankAccount and AccountLog, AccountLog serves purely as an object to store the entries for each deposit/withdrawal. The AccountLog instances are passed to the BankAccount which stores them and generates the bank statement.

An AccountLog instance can be initialized by passing it a string representation of a Time instance, for example '2022-08-22 15:18:38.401955 +0100', along with a credit and a debit amount. Where for a transaction with a deposit of 100 and withdrawal of 1000, the AccountLog instance can be declared as 
```Ruby
account_log = AccountLog.new('2022-08-22 15:18:38.401955 +0100', 100, 1000)
```

A BankAccount instance has two public methods make_transaction() and generate_bank_statement(). The former takes an AccountLog instance and performs light validation of the data and stores the data within the BankAccount instance. generate_bank_statement() reads all the AccountLog that have been stored, sorts the entries and returns a bank statement string where the balance at each entry has been calculated and displayed along with the amount deposited or withdrawn

```Ruby
bank_account = BankAccount.new
bank_account.make_transaction(account1_log)
bank_account.make_transaction(account2_log)
bank_account.make_transaction(account3_log)
bank_account.generate_bank_statement()
```

[screenshot](https://github.com/shaunywho/bank_tech_test/blob/main/bank_tech_test.png?raw=true)
