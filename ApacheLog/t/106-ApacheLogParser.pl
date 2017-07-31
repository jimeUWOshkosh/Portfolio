#!/usr/bin/env perl
use strict;
use warnings;
use Apache::Log::Parser;

our $VERSION = 0.0001;

push @ARGV, 'data/access.log';

# Default, for both of 'combined' and 'common'
my $parser = Apache::Log::Parser->new( fast => 1 );

while (<>) {
   my $log = $parser->parse($_);

   print $log->{rhost}, '|',
      $log->{date},     '|',
      $log->{path},     '|',
      $log->{referer},  '|',
      $log->{agent},
      "\n";
}
exit 0;
