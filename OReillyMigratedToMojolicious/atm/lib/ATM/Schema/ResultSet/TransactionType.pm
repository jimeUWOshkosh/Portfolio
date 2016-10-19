use utf8;
package ATM::Schema::ResultSet::TransactionType;

=head1 NAME

ATM::Schema::ResultSet::TransactionType

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
#use MooseX::MarkAsMethods autoclean =>1;
extends 'DBIx::Class::ResultSet';
use ATM::Schema;

sub BUILDARGS { $_[2] } # ::RS::new() expects my ($class, $rsrc, $args) = @_



1;
