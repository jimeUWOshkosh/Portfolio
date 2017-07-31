#!/usr/bin/env perl
use strict;
use warnings;
use Carp 'croak';

our $VERSION = 0.0001;

use GeoIP2::Database::Reader;

my $MMDB_DATABASE_LOCATION = 'data/GeoLite2-City.mmdb';

my ( $reader, $city );
eval {
   $reader = GeoIP2::Database::Reader->new(
      file    => $MMDB_DATABASE_LOCATION,
      locales => ['en'],
   );
   $city = $reader->city( ip => '24.24.24.24' );
   1;
} or do {
   croak $@;
};
my $country = $city->country();
print $city->names->{en}, "\n";
print $country->iso_code(), "\n";

# Not a nice interface/documentation!!!
# This jump around to get the State
my $rush = $city->_subdivisions;
my $refh = $$rush[0];
print $refh->iso_code, "\n";
print $refh->names->{en}, "\n";
my ( $r, $s );
$r = $s = 'unknown';
print "$r    $s\n";
exit 0;
