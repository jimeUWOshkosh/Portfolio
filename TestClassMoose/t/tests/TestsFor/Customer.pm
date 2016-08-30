package TestsFor::Customer;
use strict;
use warnings;
use Test::Class::Moose extends => 'TestsFor::Person';
use namespace::autoclean;
use DateTime;

our $VERSION = '0.01';

=head1 Name

TestsFor::Customer.pm

=head1 VERSION

VERSION 0.01

=head1 SYNOPSIS

Is used by Test::Class::Moose Base Class to test the Customer object.

=head1 DESCRIPTION

TestsFor::Customer is inherited from TestsFor::Person, therefore in 
Test::Class:Moose TestsFor::Customer will inherit TestsFor::Person's
tests. This test module will only have to worry about restriction
to birthdate being 18 or older.

=head1 METHODS

=head2 test_minimum_age

BirthDate is a manditory attribute but a Customer must 18 or older.

=cut

sub test_mininum_age : Tags(api) {
    my $test = shift;
    $test->test_report->plan(2);
    my $year = DateTime->now->year;
    $year -= 16;
    throws_ok {
        $test->class_name->new(
            {
                first_name => 'Sally',
                last_name  => 'Forth',
                birthdate  => "$year-06-05",
            }
        );
    }
    qr/^Customers must be 18 years old or older, not \d+/,
      'Trying to create a customer younger than 18 should fail';
    $year -= 10;    # take another ten years off
    lives_ok {
        $test->class_name->new(
            {
                first_name => 'Sally',
                last_name  => 'Forth',
                birthdate  => "$year-06-05",
            }
        );
    }
    'Trying to create a customer older than 18 should succeed';
    return;
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
