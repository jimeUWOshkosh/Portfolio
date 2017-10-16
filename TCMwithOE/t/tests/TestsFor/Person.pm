package TestsFor::Person;
use strict;
use warnings;

use Object::Exercise;
# at this point $exercise is defined as a coderef to execute the tests.

use Test::Class::Moose parent => 'My::Test::Class';
use namespace::autoclean;
use Data::Dump 'dump';

has test_person => ( is => 'rw', isa => 'Person' );

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

=head2 constructor_args

A private sub routine to set up arguments to create a default test Person

=cut

sub constructor_args {
    return (
        first_name => 'Bob',
        last_name  => 'Dobbs',
        birthdate  => '1904-06-03',
    );
}

=head2 test_setup

1) Will execute the Base Class's test_startup sub routine (if it exists!).
2) Will create a class method "default_object" for Person

=cut

sub test_setup {
    my ( $test, $report ) = @_;
    $test->next::method($report);    # call parent method
    $test->test_person(
        $test->class_name->new( { $test->constructor_args, } ) );
    return;
}

=head2 test_startup

Boilerplate sub routine if we needed to use a RDBMS

=cut

sub test_startup {
    return;
}

=head2 test_shutdown

Boilerplate sub routine if we needed to use a RDBMS

=cut

sub test_shutdown {
    return;
}

=head2 test_teardown

Boilerplate sub routine if we needed to use a RDBMS

=cut

sub test_teardown { }

sub test_constructor : Tests(3) {

    #sub test_constructor {
    my ( $test, $report ) = @_;

    #    $report->plan(3);
    ok my $person = $test->test_person, 'We should have a test person';

    isa_ok $person, $test->class_name, '... and the object it returns';
    is $person->name, 'Bob Dobbs',
      '... and it should return the correct full name';
    return;
}

sub test_last_name {
    my ( $test, $report ) = @_;
    $report->plan(2);
    my $person = $test->test_person;

    can_ok $person, 'last_name';
    is $person->last_name, 'Dobbs', '... and default value is correct';
    return;
}

sub test_first_name {
    my ( $test, $report ) = @_;
    $report->plan(2);
    my $person = $test->test_person;

    can_ok $person, 'first_name';
    is $person->first_name, 'Bob', '... and default value is correct';
    return;
}

sub test_name_order : Tests(3) {    # METHOD
    my ( $test, $report ) = @_;

    my $person = $test->test_person;

    can_ok $person, 'name';

    is $person->name, 'Bob Dobbs', 'name() should return the full name';
    $person->title('Dr.');
    is $person->name, 'Dr. Bob Dobbs',
      '... and it should be correct if we have a title';
    return;
}

sub test_age : Tests(2) {
    my ( $test, $report ) = @_;
    my $person = $test->test_person;

    can_ok $person, 'age';
    cmp_ok $person->age, '>', 100,
      'Our default person is more than one hundred years old';
    return;
}

sub test_object_exercise : Test(1) {
    my ( $test, $report ) = @_;
    ok my $person = $test->test_person, 'We should have a test person';

#   Create filename for Object::Exercise input file
    my $pwd = `pwd`;
    chomp $pwd;
    my $class_name = $test->class_name;
    $class_name =~ s|::|/|;
    my $fn = "$pwd/t/tests/TestsFor/$class_name.dsc";
#   diag $fn;

#   Slurp O::E input file
    my $data = do {
                     if (open my $fh, '<', $fn) { 
                        local $/; 
                        <$fh> 
                     } else {
                        undef
                     }
                  };
    my @tests = eval $data;
    die $@ if $@;
#   diag dump(@tests);
#   Trying to emulate
#   is $person->last_name, 'Dobbs', '... and default value is correct';
    #    $execute->( $person, @tests );
    $person->$execute( @tests );

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
