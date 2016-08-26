package TestsFor;
use strict;
use warnings;
use Test::Most;
use Carp 'croak';
use English;
use base qw(Test::Class Class::Data::Inheritable);

our $VERSION = '0.01';

INIT {
    __PACKAGE__->mk_classdata('class_to_test');
    Test::Class->runtests;
}

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

sub test_setup : Tests(setup)       { }
sub test_teardown : Tests(teardown) { }
sub test_shutdown : Tests(shutdown) { }

1;
