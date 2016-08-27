package TestsFor::Person;
use strict;
use warnings;
use Test::Most;
use base 'TestsFor';
use DateTime;

our $VERSION = '0.01';

=head1 Name

TestsFor::Person.pm

=head1 VERSION

VERSION 0.01

=head1 SYNOPSIS

Is used by Test::Class::Moose Base Class to test the Person object.

=head1 DESCRIPTION

Test suite to test the attributes of the Person Object


=head1 METHODS

=head2 test_startup

1) Will execute the Base Class's test_startup sub routine (if it exists!).
2) Will create a class method "default_object" for Person

=cut

# The "startup" method has an attribute, Tests with has the arguments startup
# and 1. Any method labeled as a startup method will run once before any of
# the other methods run. The 1 (one) in the attribute says "this method runs
# one test". If you don't run any tests in your startup method, omit this
# number:
# Tip: Don't run tests in your startup method
# sub startup : Tests(startup => 1) {
sub test_startup : Tests(startup) {
    my $test = shift;
    $test->SUPER::test_startup;
    my $class = ref $test;
    $class->mk_classdata('default_object');
    return;
}

=head2 test_setup

Create a test Person object to run test against.

=cut

sub test_setup : Tests(setup) {
    my $test = shift;
    $test->SUPER::test_setup;
    $test->default_object(
        $test->class_to_test->new(
            {
                first_name => 'Charles',
                last_name  => 'Drew',
                birthdate  => '1904-06-03',
            }
        )
    );
    return;
}

=head2 test_load_db

Boilerplate sub routine if we needed to use a RDBMS

=cut

# will run once and only once for each test class
# if startup test failed, it skips the remaining tests for the class.
sub test_load_db : Tests(startup) {
    my $test = shift;
    $test->_create_database;
    return;
}

=head2 _create_database

Boilerplate sub routine if we need to create a RDBMS

=cut

sub _create_database {
    return;
}

=head2 test_shutdown_db

Boilerplate sub routine if we needed to use a RDBMS

=cut

# will run once and only once for each test class
sub test_shutdown_db : Tests(shutdown) {
    my $test = shift;
    $test->_shutdown_database;
    return;
}

=head2 _shutdown_database

Boilerplate sub routine if we need to destory a RDBMS

=cut

sub _shutdown_database {
    return;
}

=head2 test_constructor

Verify you can create a Person object

=cut

# If you don't know how many tests you're going to have, use "no_plan".
# sub constructor : Tests(no_plan) {
# Omitting arguments to the attribute will also mean "no_plan":
# sub constructor : Tests() {
# The $test object is an empty hashref. This allows you to stash data
# there, if needed.
# $test->{pid} = $pid;
sub test_constructor : Tests(3) {
    my $test = shift;

    my $class = $test->class_to_test;
    can_ok $class, 'new';

    throws_ok { $class->new }
    qr/Attribute.*required/,
      "Creating a $class without proper attributes should fail";

    isa_ok $test->default_object, $class;
    return;
}

=head2 test_first_name

Verify that creation of the default Person object made "first_name"
manditory.

=cut

sub test_first_name : Tests(2) {    # READ ONLY REQUIRED
    my $test   = shift;
    my $person = $test->default_object;

    can_ok $person, 'first_name';

    is $person->first_name, 'Charles', '... and default first_name correct';

#    is $person->first_name, 'Charles', '... and setting its value should succeed';
    return;
}

=head2 test_last_name

Verify that creation of the default Person object made "last_name"
manditory.

=cut

#sub last_name : Tests {    # READ ONLY REQUIRED
sub test_last_name : Tests(2) {
    my $test = shift;

    #    my $person = $test->class->new;
    my $person = $test->default_object;

    can_ok $person, 'last_name';

    #    ok !defined $person->last_name,
    #        '... and last_name should start out undefined';

    #    $person->last_name('Drew');
    is $person->last_name, 'Drew', '... and default last_name correct';

 #    is $person->last_name, 'Drew', '... and setting its value should succeed';
    return;
}

=head2 test_name

Test method "name" for Person object works correctly.

=cut

#sub name : Tests {
sub test_name : Tests(3) {    # METHOD
    my $test = shift;

    #    my $person = $test->class->new;
    #    can_ok $person, 'name';
    #
    #    throws_ok { !$person->name }
    #        qr/^Both last and last names must be set/,
    #        '... and name() should croak() if the either name is not set';
    #    $person->first_name('John');
    #
    #    throws_ok { $person->full_name }
    #        qr/^Both first and last names must be set/,
    #        '... and full_name() should croak() if the either name is not set';

    my $person = $test->default_object;

    can_ok $person, 'name';

    is $person->name, 'Charles Drew', 'name() should return the full name';
    $person->title('Dr.');
    is $person->name, 'Dr. Charles Drew',
      '... and it should be correct if we have a title';
    return;
}

=head2 test_age

Test method "age" for Person object works correctly.

=cut

#sub age : Tests {    # METHOD
sub test_age : Tests(2) {
    my $test   = shift;
    my $person = $test->default_object;

    can_ok $person, 'age';
    cmp_ok $person->age, '>', 100,
      'Our default person is more than one hundred years old';
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
