#!/usr/bin/env perl
use strict;
use warnings;
use Carp 'croak';
use Test::Most;
use Apache::Log::Parser;

our $VERSION = 0.0001;

# Default, for both of 'combined' and 'common'
my $parser = Apache::Log::Parser->new( fast => 1 );

open my $fh, '<', 't/data/apache.log' or croak $@;
while (<$fh>) {

   my $log = $parser->parse($_);
   ok( $log->{rhost} eq '192.168.0.1', 'Correct IP Addr' );

   print $log->{rhost}, '|', $log->{date}, '|', $log->{path}, '|',
      $log->{referer}, '|', $log->{agent}, "\n";
}
close $fh;
done_testing;
exit 0;
