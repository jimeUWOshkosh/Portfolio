package Person;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use MooseX::Types::Moose 'Str';
use DateTime::Format::Strptime;
use Carp 'croak';
use DateTime;
use namespace::autoclean;

our $VERSION = '0.01';

=head1 Name

Person.pm

=head1 VERSION

VERSION 0.01

=head1 SYNOPSIS

use Person.pm
my $person = Person->new( { title      => 'Mr.',
                            first_name => 'Charles',
                            last_name  => 'Drew',
                            birthdate  => '1904-06-03',
                          } );

The title attribute is optional.

=head1 DESCRIPTION

A Person object that has the attributes:
 ( title, first name, last name, birthdate)
 The title attribute is optional.

=cut

# Moose doesn't know about non-Moose-based classes.
class_type 'DateTime';

my $datetime_formatter = DateTime::Format::Strptime->new(
    pattern   => '%Y-%m-%d',
    time_zone => 'GMT',
);

coerce 'DateTime' => from Str =>
  via { $datetime_formatter->parse_datetime($_) };

has first_name => ( is => 'ro', isa => Str, required => 1 );
has last_name  => ( is => 'ro', isa => Str, required => 1 );
has title      => ( is => 'rw', isa => Str, required => 0 );
has birthdate => ( is => 'ro', isa => 'DateTime', required => 1, coerce => 1 );

=head1 METHODS

=head2 name

Returns a string containing the Person's: 
   Title(optional), First Name, Last Name

=cut

sub name {
    my $self = shift;

    if ( !( $self->first_name && $self->last_name ) ) {

        croak('Both first and last names must be set');
    }

    my $name;
    if ( my $title = $self->title ) {
        $name = "$title ";
    }
    $name .= join ' ', $self->first_name, $self->last_name;    ## no critic
    return $name;
}

=head2 age

Returns the age of the Person in years.

=cut

sub age {
    my $self     = shift;
    my $duration = DateTime->now - $self->birthdate;
    return $duration->years;
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
