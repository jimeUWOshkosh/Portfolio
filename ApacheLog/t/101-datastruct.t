use strict;
use warnings;
use Test::Most;
use MyLib;

our $VERSION = 0.0001;

subtest 'stat' => sub {
   my %stats = (
      'USA:CA' => {
         total  => 3,
         lookup => {
            '/stuff'  => {count => 2,},
            '/beavis' => {count => 1,},
         },
      },
      'USA::AZ' => {
         total  => 3,
         lookup => {
            '/stuff'  => {count => 2,},
            '/beavis' => {count => 1,},
         },
      },
   );
   $stats{'Canada'}{total} = 3;
   $stats{'Canada'}{lookup}{'/jsonline.com'}{count} = 2;
   foreach my $loc ( grep { /\AUSA/sxm } keys %stats ) {
      print "$loc { ";
      print " $stats{$loc}{total}: ";
      foreach my $r ( sort { $stats{$loc}{lookup}{$b}{count} <=> $stats{$loc}{lookup}{$a}{count} } keys %{$stats{$loc}{lookup}} ) {
         print $stats{$loc}{lookup}{$r}{count} . ":";
         print "$r\t";
      }
      print "}\n";
   }
   ok( 1, 'done' );
};

done_testing;
1;
