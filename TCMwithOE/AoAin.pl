#!/usr/bin/env perl
use strict; use warnings;
use Data::Dump 'dump';
my $data = do {
   if (open my $fh, '<', 'CLASS.dsc') { local $/; <$fh> }
   else {undef}
};
my @tests = eval $data;
die $@ if $@;
exit 0;
