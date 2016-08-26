package TestsFor::Person::Employee;
use strict;      # in Test::Most;
use warnings;    # in Test::Most;
use Test::Most;
use base 'TestsFor::Person';
use Person::Employee;

our $VERSION = '0.01';

sub class_to_test { 'Person::Employee' }    ## no critic

#sub employee_number : Tests(no_plan) {
sub test_employee_number : Tests(3) {
    my $test     = shift;
    my $employee = $test->class_to_test->new(
        {
            first_name => 'Mary',
            last_name  => 'Jones',
            birthdate  => '1904-06-03',
        }
    );

    can_ok $employee, 'employee_number';
    ok !defined $employee->employee_number,
      '... and employee_number should not start out defined';

    $employee->employee_number(4);
    is $employee->employee_number, 4,
      '... but we should be able to set its value';
    return;
}

#sub full_name : Tests(no_plan) {
sub test_full_name : Tests(1) {
    my $test   = shift;
    my $person = $test->class_to_test->new(
        {
            first_name => 'Mary',
            last_name  => 'Jones',
            birthdate  => '1904-06-03',
        }
    );

    is $person->full_name, 'Jones, Mary',
      'The employee name should render correctly';
    return;
}

1;
