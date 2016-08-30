package TestsFor::Person::Employee;
use strict;
use warnings;
use Test::Class::Moose extends => 'TestsFor::Person';
use namespace::autoclean;

our $VERSION = '0.01';

=head1 Name

TestsFor::Person::Employee.pm

=head1 VERSION

VERSION 0.01

=head1 SYNOPSIS

Is used by Test::Class::Moose Base Class to test the Employee object.

=head1 DESCRIPTION

TestsFor::Person::Employee is inherited from TestsFor::Person, 
therefore in Test::Class:Moose TestsFor::Person::Employee will 
inherit TestsFor::Person's tests. This test module will only 
have to worry about "full_name" method and the optional attribute
"employee_number".

=head1 METHODS

=cut

around 'constructor_args' => sub {
    my ( $orig, $self, $report ) = @_;
    return ( $self->$orig($report), employee_number => 666 );
};

=head2 test_constructor

Verify you can create a Person object

=cut

sub test_constructor : Tests(1) {
    my ( $test, $report ) = @_;
    $test->next::method($report);    # call parent method

    #    $report->plan(1);
    is $test->test_person->employee_number, 666,
      '... and we should get the correct employee number';
    return;
}

=head2 test_employee_number

Test that the "employee_number" attribute is optional.

=cut

sub test_employee_number : Tests(2) {
    my ( $test, $report ) = @_;
    my $employee = $test->class_name->new(
        {
            first_name => 'Mary',
            last_name  => 'Jones',
            birthdate  => '1904-06-03',
        }
    );

    can_ok $employee, 'employee_number';

    $employee->employee_number(4);
    is $employee->employee_number, 4,
      '... but we should be able to set its value';
    return;
}

=head2 test_first_name

Verify that creation of the default Employe object made "first_name"
manditory.

=cut

sub test_full_name : Tests(1) Tags(deprecated) {
    my ( $test, $report ) = @_;
    my $person = $test->class_name->new(
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
