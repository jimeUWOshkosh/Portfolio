#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;
use Carp 'croak';
use feature 'say';

our $VERSION = 0.0001;

my $USAGE = "Usage: $0 --log ApacheLogFile --geo GeoIP2db [--help]";
GetOptions(
   'log=s' => \my $inputlog,
   'geo=s' => \my $geo_db,
   'help'  => \my $help,
   )
   or do {
   croak "Missing argument(s)\n", $USAGE;
   };

#$inputlog = 'data/apache.log';
#$geo_db   = 'data/GeoLite2-City.mmdb';

if ($help) { say $USAGE; exit 0; }
if ( !($inputlog) ) { croak "No Log file given\n", $USAGE; }
if ( !($geo_db) )   { croak "No Geo file given\n", $USAGE; }

#croak "Bad input file for [log]\n", $USAGE if (!(-s $inputlog));
#croak "Bad Geo DB for [Geo]\n",     $USAGE if (!(-s $geo_db));
if ( !( -s $inputlog ) ) { croak "Bad input file for [log]\n", $USAGE; }
if ( !( -s $geo_db ) )   { croak "Bad Geo DB for [Geo]\n",     $USAGE; }
exit 0;
