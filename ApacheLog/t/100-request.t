use strict;
use warnings;
use Test::Most;
use FindBin::libs;
use feature 'say';
use Carp 'croak';

use MyLib;

our $VERSION = 0.0001;

subtest 'request' => sub {
   open my $fh, "<", "t/data/request.dat" or croak $@;
   while (<$fh>) {
      chomp;
      if ( good_request($_) ) {
         say "good";
      }
      else {
         say "bad";
      }
   }
   close $fh;
   ok( 1, "done" );
};
done_testing;
1;
