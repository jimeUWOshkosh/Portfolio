package ATM::Schema::Result::View::AccountTrans;
use Moose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'ATM::Schema::Result::Account';

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');
__PACKAGE__->table('accounttrans');    # XXX virtual view name. Doesn't exist

# is_virtual allows us to use bind parameters
__PACKAGE__->result_source_instance->is_virtual(1);
my $sql = 'select s.sid, tt.name, s.amount, s.previous_balance, s.new_balance,
s.transaction_date, a.account_number
from single_transaction s, transactions t, account a, transaction_type tt
where s.sid = t.sid and t.aid = a.aid and s.tid = tt.tid;
and a.account_number = ?';

__PACKAGE__->result_source_instance->view_definition($sql);
__PACKAGE__->meta->make_immutable;

1;
