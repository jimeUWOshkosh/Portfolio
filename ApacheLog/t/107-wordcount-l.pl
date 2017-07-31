#!/usr/bin/env perl
use strict;
use warnings;

our $VERSION = 0.0001;

$_ = "zero:one:two:three:four:five:six";
print join( "\t", ( split /:/sx )[0, 2, 1, 5] ), "\n";

my $str = `wc -l data/access.log`;
my $lines = ( split / /s, $str )[0];
print "$lines\n";

