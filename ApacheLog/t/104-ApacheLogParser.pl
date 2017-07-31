#!/usr/bin/env perl
use strict;
use warnings;
use Apache::Log::Parser;

our $VERSION = 0.0001;

# Default, for both of 'combined' and 'common'
my $parser = Apache::Log::Parser->new( fast => 1 );

my $log1 = $parser->parse(<<'COMBINED');
192.168.0.1 - - [07/Feb/2011:10:59:59 +0900] "GET /path/to/file.html HTTP/1.1" 200 9891 "-" "DoCoMo/2.0 P03B(c500;TB;W24H16)"
COMBINED

#say $log1->{rhost}, $log1->{date}, $log1->{path}, $log1->{referer}, $log1->{agent};
print $log1->{rhost}, '|',
   $log1->{date},     '|',
   $log1->{path},     '|',
   $log1->{referer},  '|',
   $log1->{agent},
   "\n";
exit 0;
