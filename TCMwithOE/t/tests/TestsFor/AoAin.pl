#!/usr/bin/env perl
use strict; use warnings;
use Data::Dump 'dump';
my @dummy = (1,44);
my $data = do {
    local $/; 
    <STDIN>;
};
my @tests = eval $data;
die $@ if $@;
print dump(@tests), "\n";
exit 0;
