#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use Carp 'croak';
use Getopt::Long;
use Apache::Log::Parser;
use GeoIP2::Database::Reader;
use lib 'lib';
use MyLib;
use English;

=head1 NAME

IPtop - Top N Countries and Top N States visited gathered from a
Apache combined common log using GeoIP2 database for Location information.

N will default to 10.

Usage: IPtop.pl --log ApacheLogFile --geo GeoIP2db 
[--top N   --help --verbose ]


=head1 VERSION

Version 0.0001

=cut

BEGIN {
   our $VERSION = 0.0001;
}

=head1 SYNOPSIS

The report shows the following information:

    Top 10 countries for visitors
        include the name of the country in English and the number of visitors
           from that country
        sort the results by number of visitors (most to least)
        for each country show the page other than / that visitors from that
           country visited the most
    Top 10 US states, ignoring visitors outside the US
        same as above for output

For the purposes of this code, "the page" is the path including the query
string.

If there are less than 10 states or countries with visitors, only show those 
which have at least one visitor.

Note that the GeoLite2 data file may simply not have all the relevant 
information on some IP addresses. In this case, assign the visit to a state 
or country of "unknown" as needed.

=cut

my $USAGE = <<"EOD";
Usage: $0 --log ApacheLogFile --geo GeoIP2db 
[--top N  --help --verbose ]
EOD

GetOptions(
   'log=s'   => \my $inputlog, 'geo=s' => \my $geo_db,
   'top=i'   => \my $top,      'help'  => \my $help,
   'verbose' => \my $verbose,
   )
   or do {
   die "Missing argument(s)\n", $USAGE;
   };

if ($help) { say $USAGE; exit 0; }
die "No Log file given\n", $USAGE if ( !($inputlog) );
die "No Geo file given\n", $USAGE if ( !($geo_db) );

die "Bad input file for [log]\n", $USAGE if ( !( -s $inputlog ) );
die "Bad Geo DB for [Geo]\n",     $USAGE if ( !( -s $geo_db ) );

my $reader;    # file handle to Geo DB
my $parser;    # parser handle for Apache log file record
eval {
   $reader = GeoIP2::Database::Reader->new( file => $geo_db, locales => ['en'] );
   # Default, for both of 'combined' and 'common'
   $parser = Apache::Log::Parser->new( fast => 1 );
   1;
} or do {
   croak $@;
};

$top //= 10;    # default to top 10

my %stats;      # Table for world wide info
my %us_stats;   # Table for US info
my $bad = 0;    # num of filtered paths by MyLib::good_request via MyLib::process_record

my $str = `wc -l $inputlog`;
my $lines = ( split / /, $str )[0];

open my $fh, "<", $inputlog or croak $@;
while (<$fh>) {
   chomp;
   print "line:$. of $lines\n" if ( ( !( $. % 1000 ) ) && ($verbose) );
   process_record( $_, $reader, $parser, \%stats, \%us_stats, );
}
close($fh);
# print "BAD $bad\n";

#use Storable;
#store \%stats, 'data/stats.storable';
#store \%stats, 'data/us_stats.storable';

cleanup_by_sorting( \%stats );
cleanup_by_sorting( \%us_stats );
#use Storable;
#store \%stats,    'data/stats2.storable';
#store \%us_stats, 'data/us_stats2.storable';

world_stats( \%stats, $top, );
US_stats( \%us_stats, $top, );

=head1 AUTHOR

James Edwards, C<< <mr_osh_vegas at notvalid dot com> >>

=head1 BUGS

No undocumented features to report at the current time

=head1 SUPPORT

A one time programing task

=cut

exit 0;
