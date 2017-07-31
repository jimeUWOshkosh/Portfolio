use strict;
use warnings;
use Test::Most;
use GeoIP2::Database::Reader;

our $VERSION = 0.0001;

subtest 'geo' => sub {

   my $MMDB_DATABASE_LOCATION = 'data/GeoLite2-City.mmdb';

   my ( $reader, $city );
   lives_ok {
      $reader = GeoIP2::Database::Reader->new(
         file    => $MMDB_DATABASE_LOCATION,
         locales => ['en'],
      );
      $city = $reader->city( ip => '24.24.24.24' );
   }
   'Pulled data on read';

   my $country = $city->country();
   my $cntry   = $country->iso_code();
   ok( $country->iso_code eq "US", 'We are in the US' );

   # Not a nice interface/documentation!!!
   # This jump around to get the State
   my $rush = $city->_subdivisions;
   my $refh = $$rush[0];
   ok( $refh->iso_code eq "NY", 'I am in a New York State of mind' );
};

done_testing;
1;
