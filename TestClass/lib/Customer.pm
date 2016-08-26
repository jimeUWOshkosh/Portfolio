package Customer;
use strict;
use warnings;
use Moose;
extends 'Person';
use Carp 'croak';
use namespace::autoclean;

our $VERSION = '0.01';

=head1 Name

Customer.pm

=head1 VERSION

VERSION 0.01

=head1 SYNOPSIS

use Customer.pm

=head1 DESCRIPTION

Add the restriction to a Person object that a customer must be
at least 18 year old.

=head1 METHODS

=head2 BUILD

Called after Customer->new() to validate object.

=cut

sub BUILD {
    my $self = shift;

    if ( $self->age < 18 ) {
        my $age = $self->age;
        croak("Customers must be 18 years old or older, not $age");
    }
}

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 BUGS

No Features to report

=head1 AUTHOR

James Edwards

=head1 LICENSE

Ya Right

=cut
