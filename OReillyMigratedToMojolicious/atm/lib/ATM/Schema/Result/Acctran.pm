package ATM::Schema::Result::Acctran;

use base qw/DBIx::Class::Core/;

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');

__PACKAGE__->table('acctran');
__PACKAGE__->result_source_instance->is_virtual(0);
#__PACKAGE__->result_source_instance->view_definition( $sql );
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
