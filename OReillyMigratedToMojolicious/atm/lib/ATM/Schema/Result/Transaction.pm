use utf8;
package ATM::Schema::Result::Transaction;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ATM::Schema::Result::Transaction

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

=head1 TABLE: C<transactions>

=cut

__PACKAGE__->table("transactions");

=head1 ACCESSORS

=head2 sid

  data_type: 'integer'
  is_nullable: 0

=head2 aid

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "sid",
  { data_type => "integer", is_nullable => 0 },
  "aid",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sid>

=back

=cut

__PACKAGE__->set_primary_key("sid");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-12-11 19:40:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RbrUeWC3w6XddhOij43RhA
__PACKAGE__->belongs_to( single_trans => 'ATM::Schema::Result::SingleTransaction',
                            { 'foreign.sid' => 'self.sid' },
);
__PACKAGE__->belongs_to( account      => 'ATM::Schema::Result::Account',
                            { 'foreign.aid' => 'self.aid' },
);

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
