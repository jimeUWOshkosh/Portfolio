package TestsFor::Person::Employee;
use strict;      # in Test::Most;
use warnings;    # in Test::Most;
use Test::Most;
use base 'TestsFor::Person';
use Person::Employee;

our $VERSION = '0.01';

=head1 Name

TestsFor::Person::Employee.pm

=head1 VERSION

VERSION 0.01

=head1 SYNOPSIS

Is used by Test::Class Base Class to test the Employee object.

=head1 DESCRIPTION

TestsFor::Person::Employee is inherited from TestsFor::Person, 
therefore in Test::Class TestsFor::Person::Employee will 
inherit TestsFor::Person's tests. This test module will only 
have to worry about "full_name" method and the optional attribute
"employee_number".

=head1 METHODS

=cut

#sub class_to_test { 'Person::Employee' }    ## no critic

=head2 test_employee_number

Test that the "employee_number" attribute is optional.

=cut

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

=head2 test_full_name

Test that method "full_name" return "last_name , first_name".

=cut

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
__END__

=head1 BUGS

No Features to report

=head1 AUTHOR

James Edwards

=head1 LICENSE

Ya Right

=cut
