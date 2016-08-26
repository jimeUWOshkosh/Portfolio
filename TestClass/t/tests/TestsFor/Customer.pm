package TestsFor::Customer;
use strict;
use warnings;
use Test::Most;
use base 'TestsFor::Person';
use DateTime;

our $VERSION = '0.01';

#sub class_to_test { 'Person::Customer' }

sub test_mininum_age : Tests(2) {
    my $test = shift;
    my $year = DateTime->now->year;
    $year -= 16;
    throws_ok {
        $test->class_to_test->new(
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
        $test->class_to_test->new(
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

1;
