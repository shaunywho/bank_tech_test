# bank_tech_test

Ensure that rspec is installed.

There are two classes: BankAccount and AccountLog, AccountLog serves purely as an object to store the entries for each deposit/withdrawal. The AccountLog instances are passed to the BankAccount which stores them and generates the bank statement.

A BankAccount instance has two public methods make_transaction() and generate_bank_statement(). The former takes an AccountLog instance and performs light validation of the data and stores the data within the BankAccount instance. generate_bank_statement() reads all the AccountLog that have been stored, sorts the entries and returns a bank statement string.
