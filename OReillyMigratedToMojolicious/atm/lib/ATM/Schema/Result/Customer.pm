use utf8;
package ATM::Schema::Result::Customer;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ATM::Schema::Result::Customer

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

=head1 TABLE: C<customer>

=cut

__PACKAGE__->table("customer");

=head1 ACCESSORS

=head2 cid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 aid

  data_type: 'integer'
  is_nullable: 0

=head2 pid

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "cid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "aid",
  { data_type => "integer", is_nullable => 0 },
  "pid",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</cid>

=back

=cut

__PACKAGE__->set_primary_key("cid");

=head1 UNIQUE CONSTRAINTS

=head2 C<aid>

=over 4

=item * L</aid>

=item * L</pid>

=back

=cut

__PACKAGE__->add_unique_constraint("aid", ["aid", "pid"]);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-12-11 19:40:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Uj1gFZuh1h/NUzzS9ciLaw
__PACKAGE__->has_one( c_person  => 'ATM::Schema::Result::Person', 
                            { 'foreign.pid' => 'self.pid' },
 );
__PACKAGE__->has_one( c_accounts => 'ATM::Schema::Result::Account', 
                            { 'foreign.aid' => 'self.aid' },
 );

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
