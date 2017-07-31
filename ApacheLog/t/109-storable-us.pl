#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use MyLib;
use Storable;

our $VERSION = 0.0001;

my $refh_stats = retrieve("data/us_stats2.storable");

my $i = 1;
print "\nTop 10 States for visitors followied by most visted pages\n\n";
print "Rank                        Total\n";
foreach my $loc ( sort { $refh_stats->{$b}{total} <=> $refh_stats->{$a}{total} } keys %{$refh_stats} ) {
   printf "  %2d: %-20s ", $i, ${$refh_stats}{$loc}{label};
   printf "%6d  ", ${$refh_stats}{$loc}{total};
   my $rh = ${${$refh_stats}{$loc}}{lookup};
   foreach my $r ( keys %{$rh} ) {
      print $r;
   }
   print "\n";
   last if ( $i == 10 );
   $i++;
}
exit 0;
