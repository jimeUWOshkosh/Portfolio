package TestsFor;
use strict;
use warnings;
use Test::Most;
use Carp 'croak';
use English;
use base qw(Test::Class Class::Data::Inheritable);

our $VERSION = '0.01';

# Creates a class data method "class_to_test"
INIT {
    __PACKAGE__->mk_classdata('class_to_test');
    Test::Class->runtests;
}

=head1 Name

TestsFor.pm

=head1 VERSION

VERSION 0.01

=head1 SYNOPSIS

Base Class for a Test::Class::Moose test suite

=head1 DESCRIPTION

Base Class for other Test::Class::Moose modules to inherit.

=head1 METHODS

=head2 test_startup

xxx

=cut

# Test Control Methods
# Tip: Don't put tests in your test control methods
sub test_startup : Tests( startup) {
    my $test = shift;
    ( my $class = ref $test ) =~ s/^TestsFor:://;
    eval "use $class";
    croak $EVAL_ERROR if $EVAL_ERROR;
    $test->class_to_test($class);
    return;
}

=head2 test_setup

Boilerplate sub routine to be used if needed.

=head2 test_teardown

Boilerplate sub routine to be used if needed.

=head2 test_shutdown

Boilerplate sub routine to be used if needed.

=cut

sub test_setup    : Tests(setup)    { }
sub test_teardown : Tests(teardown) { }
sub test_shutdown : Tests(shutdown) { }

1;
__END__

=head1 BUGS

No Features to report

=head1 AUTHOR

James Edwards

=head1 LICENSE

Ya Right

=cut
