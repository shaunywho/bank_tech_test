# frozen_string_literal: true

require 'account_log'
describe AccountLog do
  context 'AccountLog should be readable but not writable after initialization' do
    it 'should not have attribute writers associated with its field' do
      expect(AccountLog.instance_methods(false)).to eq [:credit, :debit, :date]
    end

    it 'should have attribute readers associated with its field' do
      expect(AccountLog.instance_methods - Object.methods).to eq [:credit, :debit, :date]
    end
  end

  context 'Account Log' do
    it 'should have attributes equivalent to what was set' do
      date = '2022-08-22 15:18:38.401955 +0100'
      credit = 1000.0
      debit = 0.0
      account_log = AccountLog.new(date, credit, debit)
      expect(account_log.date).to eq date
      expect(account_log.credit).to eq credit
      expect(account_log.debit).to eq debit
    end
  end
end
