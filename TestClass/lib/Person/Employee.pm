package Person::Employee;
use strict;
use warnings;
use Moose;
extends 'Person';
use namespace::autoclean;
use Carp 'croak';

our $VERSION = '0.01';

=head1 Name

Employee.pm

=head1 VERSION

VERSION 0.01

=head1 SYNOPSIS

use Employee.pm
my $employee = Employee->new( {   title            => 'Mr.',
                                  first_name       => 'Charles',
                                  last_name        => 'Drew',
                                  birthdate        => '1904-06-03',
                                  employee_number  => 4,
                              } );

The title, employee_number attributes is optional.


=head1 DESCRIPTION

A Employee object that has the attributes:
 ( title, first name, last name, birthdate, employee_number)

The title, employee_number attributes is optional.

=head1 METHODS


=cut

has employee_number => ( is => 'rw', isa => 'Int' );

=head2 full_name

Returns a string containing the Person's: 
   Last Name, First Name

=cut

sub full_name {
    my $self = shift;

    if ( !( $self->first_name && $self->last_name ) ) {
        croak('Both first and last names must be set');
    }

    return $self->last_name . ', ' . $self->first_name;
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
