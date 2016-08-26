package TestsFor::Person;
use strict;
use warnings;
use Test::Most;
use base 'TestsFor';
use DateTime;

our $VERSION = '0.01';

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

# will run once and only once for each test class
# if startup test failed, it skips the remaining tests for the class.
sub test_load_db : Tests(startup) {
    my $test = shift;
    $test->_create_database;
    return;
}

sub _create_database {
    return;
}

# will run once and only once for each test class
sub test_shutdown_db : Tests(shutdown) {
    my $test = shift;
    $test->_shutdown_database;
    return;
}

sub _shutdown_database {
    return;
}

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

sub test_first_name : Tests(2) {    # READ ONLY REQUIRED
    my $test   = shift;
    my $person = $test->default_object;

    can_ok $person, 'first_name';

    is $person->first_name, 'Charles', '... and default first_name correct';

#    is $person->first_name, 'Charles', '... and setting its value should succeed';
    return;
}

#sub last_name : Tests {    # READ ONLY
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
