package Person::Employee;
use strict;
use warnings;
use Moose;
extends 'Person';
use namespace::autoclean;
use Carp 'croak';
our $VERSION = '0.01';

has employee_number => ( is => 'rw', isa => 'Int' );

sub full_name {
    my $self = shift;

    if ( !( $self->first_name && $self->last_name ) ) {
        croak('Both first and last names must be set');
    }

    return $self->last_name . ', ' . $self->first_name;
}

__PACKAGE__->meta->make_immutable;

1;

