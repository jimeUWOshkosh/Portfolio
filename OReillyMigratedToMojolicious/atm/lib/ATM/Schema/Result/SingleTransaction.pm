use utf8;
package ATM::Schema::Result::SingleTransaction;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ATM::Schema::Result::SingleTransaction

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<single_transaction>

=cut

__PACKAGE__->table("single_transaction");

=head1 ACCESSORS

=head2 sid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 amount

  data_type: 'double precision'
  is_nullable: 0

=head2 tid

  data_type: 'integer'
  is_nullable: 0

=head2 previous_balance

  data_type: 'double precision'
  is_nullable: 0

=head2 new_balance

  data_type: 'double precision'
  is_nullable: 0

=head2 transaction_date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "sid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "amount",
  { data_type => "double precision", is_nullable => 0 },
  "tid",
  { data_type => "integer", is_nullable => 0 },
  "previous_balance",
  { data_type => "double precision", is_nullable => 0 },
  "new_balance",
  { data_type => "double precision", is_nullable => 0 },
  "transaction_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</sid>

=back

=cut

__PACKAGE__->set_primary_key("sid");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-12-11 19:40:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qvXSPaAjUulIHDTShS97UA
__PACKAGE__->has_one( trans => 'ATM::Schema::Result::Transaction',
                                        { 'foreign.sid' => 'self.sid' },
);
__PACKAGE__->belongs_to( transactiontype => 'ATM::Schema::Result::TransactionType',
                                        { 'foreign.tid' => 'self.tid' },
);
__PACKAGE__->has_many( bankaccount => 'trans', 'account');

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
