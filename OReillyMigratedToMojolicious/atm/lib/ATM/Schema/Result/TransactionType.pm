use utf8;
package ATM::Schema::Result::TransactionType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ATM::Schema::Result::TransactionType

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

=head1 TABLE: C<transaction_type>

=cut

__PACKAGE__->table("transaction_type");

=head1 ACCESSORS

=head2 tid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "tid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</tid>

=back

=cut

__PACKAGE__->set_primary_key("tid");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-12-11 19:40:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gFpMungorGkso6zgCGv5ZA

__PACKAGE__->has_many( 'single_trans' =>  'ATM::Schema::Result::TransactionType',
                                        { 'foreign.tid' => 'self.tid' },
);

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
