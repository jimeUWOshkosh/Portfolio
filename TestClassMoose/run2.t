#!/usr/bin/env perl
use strict;
use warnings;

our $VERSION = '0.01';

use Test::Class::Moose::Load 't/tests';

#use Test::Class::Moose::Load qw<t/customer t/order>;
use Test::Class::Moose::Runner;
my $test_suite = Test::Class::Moose::Runner->new(
    statistics => 1,

    #      include_tags => [qw/api/],
    exclude_tags => [qw/deprecated/],
    test_classes => \@ARGV,
)->runtests->test_report;
