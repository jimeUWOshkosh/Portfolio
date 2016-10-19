#!/usr/bin/env perl
use lib 'lib';
use Test::Class::Moose::Load 't/tests';
#use Test::Class::Moose::Load qw<t/customer t/order>;
use Test::Class::Moose::Runner;
my $test_suite =Test::Class::Moose::Runner->new(
      statistics   => 1,
      test_classes => \@ARGV,
)->runtests->test_report;
