package ATM::Schema::Result::Acctran;

use base qw/DBIx::Class::Core/;

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');

__PACKAGE__->table('acctran');
__PACKAGE__->result_source_instance->is_virtual(1);
#my $sql = <<'END_SQL';
#select s.sid, s.tid, s.amount, s.previous_balance, s.new_balance, s.transaction_date, a.account_number  from single_transaction s, transactions t, account a where s.sid = t.sid and t.aid = a.aid and a.account_number = ?
#END_SQL
my $sql = <<'END_SQL';
SELECT me.sid, me.amount, me.tid, me.previous_balance, me.new_balance, me.transaction_date, me.transaction_date, transactiontype.name, me.amount, me.new_balance FROM single_transaction me  JOIN transactions trans ON trans.sid = me.sid  JOIN account account ON account.aid = trans.aid  JOIN transaction_type transactiontype ON transactiontype.tid = me.tid LEFT JOIN transaction_type single_trans ON single_trans.tid = transactiontype.tid WHERE ( account_number = ? )
END_SQL

__PACKAGE__->result_source_instance->view_definition( $sql );
__PACKAGE__->add_columns(
  'sid' => {
    data_type => 'integer',
  },
  'name' => {
    data_type => 'text',
  },
  'amount' => {
    data_type => 'double precision',
  },
  'previous_balance' => {
    data_type => 'double precision',
  },
  'new_balance' => {
    data_type => 'double precision',
  },
  'transaction_date' => {
    data_type => 'timestamp',
  },
  'account_number' => {
    data_type => 'integer',
  },
);
1;
