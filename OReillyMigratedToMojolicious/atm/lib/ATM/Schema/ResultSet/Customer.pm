use utf8;
package ATM::Schema::ResultSet::Customer;

=head1 NAME

ATM::Schema::ResultSet::Customer

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
#use MooseX::MarkAsMethods autoclean =>1;
extends 'DBIx::Class::ResultSet';
use ATM::Schema;

sub BUILDARGS { $_[2] } # ::RS::new() expects my ($class, $rsrc, $args) = @_

__PACKAGE__->meta->make_immutable;

1;
