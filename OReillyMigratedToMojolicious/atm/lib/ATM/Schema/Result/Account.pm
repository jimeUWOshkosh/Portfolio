use utf8;
package ATM::Schema::Result::Account;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ATM::Schema::Result::Account

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

=head1 TABLE: C<account>

=cut

__PACKAGE__->table("account");

=head1 ACCESSORS

=head2 aid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 account_number

  data_type: 'integer'
  is_nullable: 0

=head2 password

  data_type: 'text'
  is_nullable: 0

=head2 balance

  data_type: 'double precision'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "aid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "account_number",
  { data_type => "integer", is_nullable => 0 },
  "password",
  { data_type => "text", is_nullable => 0 },
  "balance",
  { data_type => "double precision", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</aid>

=back

=cut

__PACKAGE__->set_primary_key("aid");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-12-11 19:40:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yvVI/PDwRcxKfdOHOAZV4A
__PACKAGE__->has_many( a_customers =>  'ATM::Schema::Result::Customer',
                                        { 'foreign.aid' => 'self.aid' },
                                        { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many( trans =>  'ATM::Schema::Result::Transaction',
                                        { 'foreign.aid' => 'self.aid' },
                                        { cascade_copy => 0, cascade_delete => 0 },
);

sub get_owner_list {
    my $self           = shift;
    return $self->a_customers->all;
}

sub get_transaction_list {
    my $self           = shift;
    return $self->trans->all;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
