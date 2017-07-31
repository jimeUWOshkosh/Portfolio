package MyLib;
use strict;
use warnings;
use Apache::Log::Parser;
use GeoIP2::Database::Reader;

=head1 NAME

MyLib - Library to help in the processing a Apache log file

=head1 VERSION

Version 0.0001

=cut

BEGIN {
   our $VERSION = 0.0001;
   require Exporter;
   our @ISA = qw(Exporter);
   # subs & vars exported by default
   our @EXPORT = qw(good_request process_record cleanup_by_sorting world_stats US_stats);
   #   our @EXPORT_OK= qw($Var1 %Hashit func3); # subs & vars optionally exported
}

=head1 SYNOPSIS

Library of subroutines to support IPtop.pl

    use MyLib;


=head1 EXPORT

Subroutine(s) (good_request process_record cleanup_by_sorting world_stats
              US_stats) are exported by default.
No optionally items exported.

=cut

=head1 SUBROUTINES/METHODS

=head2 B<good_request>

(record, )

To validate whether the requested path is one that should be
gather statistically

=over

=item I<record>

A line from the Apache log file

=back

=cut

sub good_request {
   local $_ = shift;
   if (/\A\/[a-f\d]+\/css\//sxm) {
   }
   elsif (/\A\/[a-f\d]+\/images\//sxm) {
   }
   elsif (/\A\/[a-f\d]+\/js\//sxm) {
   }
   elsif (/\A\/entry-imagess\//sxm) {
   }
   elsif (/\A\/imagess\//sxm) {
   }
   elsif (/\A\/user-imagess\//sxm) {
   }
   elsif (/\A\/static\//sxm) {
   }
   elsif (/\A\/robots\.txt\//sxm) {
   }
   elsif (/\A\/favicon\.ico\//sxm) {
   }
   elsif (/\.(rss|atom)\z/sxm) {
   }
   else {
      return 1;
   }
   return 0;
}

=head2 B<process_record>

(record, reference GeoIP DB handle, reference Parser handle, reference to country Hash, reference to US Hash,)

A valid record has been parsed, gather information for world wide by country and US by state if need be.

=over

=item I<record>

A line from the Apache log file that which we wish to count in
our evaluation

=item I<GeoIP2::Database::Reader Object>

Filehandle Object to the GeoIP Database

=item I<Apache Log Parser Object>

Object handle record parsed

=item I<Reference to stats hash for country information>

Data Structure for collected data
(
   'abbv' => {
      total  => 3,
      label  => 'Country or State in English'
      lookup => {
         '/path'  => {count => 2,},
      },
   },
)

=item I<Reference to stats hash for USA states information>

Please look at the previous parameter

=back

=cut

sub process_record {
   my ( $rec, $GeoDB_obj, $parser_obj, $refh_stats, $refh_us_stats, ) = @_;
   my $log = $parser_obj->parse($rec);

   if ( good_request( $log->{path} ) ) {
      my ( $city, $country_abbv ) = process_country( $GeoDB_obj, $log, $refh_stats, );

      # United States
      if ( $country_abbv eq 'US' ) {
         process_state( $city, $refh_us_stats, $log->{path} );
      }
   }    # else { $$rs_bad++; }
   return;
}

=head2 B<process_country>

(reference GeoIP DB handle, reference Parser handle, reference to country Hash, ...)

A valid record has been parsed, gather information for the country and if a USA request, state information

=over

=item I<GeoIP2::Database::Reader Object>

Filehandle Object to the GeoIP Database

=item I<Apache Log Parser Object>

Object handle record parsed

=item I<Reference to stats hash for the country information>

Data Structure for collected data
(
   'abbv' => {
      total  => 3,
      label  => 'Country or State in English'
      lookup => {
         '/path'  => {count => 2,},
      },
   },
)

=item I<Reference to stats hash for USA state information>

Please look at the previous parameter

=back

=cut

sub process_country {
   my ( $geodb_obj, $log_obj, $refh_stats, ) = @_;
   my ( $city, $country, $country_abbv, $country_name, );
   eval {
      $city = $geodb_obj->city( ip => $log_obj->{rhost} );
      $country = $city->country();
      if ( defined $country->iso_code ) {
         $country_abbv = $country->iso_code;
         $country_name = $country->names->{en};
      }
      else {
         $country_abbv = $country_name = 'unknown';
      }
      1;
   } or do {
      $country_abbv = $country_name = 'unknown';
   };

   assign_entry( $refh_stats, $country_abbv, $country_name, $log_obj->{path}, );
   return $city, $country_abbv;
}

=head2 B<process_state>

(GeoIP DB City object, reference to USA State Hash, )

A valid record has been parsed, gather information for US state

=over

=item I<GeoIP2::Database City Object>

Filehandle Object to the GeoIP Database

=item I<Reference to Stats Hash for USA State information>

Data Structure for collected data
(
   'abbv' => {
      total  => 3,
      label  => 'Country or State in English'
      lookup => {
         '/path'  => {count => 2,},
      },
   },
)

=item I<path>

Request URL

=back

=cut

sub process_state {
   my ( $city, $refh_us_stats, $path ) = @_;
   my $rush     = $city->_subdivisions;    # conform or be cast out
   my $refh_obj = $$rush[0];
   my ( $state, $state_name );
   if ( defined $refh_obj ) {
      $state      = $refh_obj->iso_code;
      $state_name = $refh_obj->names->{en};
   }
   else {
      # IPAs missing in the US
      $state = $state_name = 'unknown';
   }
   assign_entry( $refh_us_stats, $state, $state_name, $path, );
   return;
}

=head2 B<assign_entry>

(reference to hash stats info, abbreviation of country or state,
name country or state in English, request path)

Create a entry in the hash with the information passed in. Increment total and count of requested path

=over

=item I<Reference to stats hash for USA state information>

Data Structure for collected data
(
   'abbv' => {
      total  => 3,
      label  => 'Country or State in English'
      lookup => {
         '/path'  => {count => 2,},
      },
   },
)

=item I<Abbreviation of Country or State>

Abbrerviation

=item I<Name of Country or State >

Name of Country or State in English

=item I<path>

Requested URL

=back

=cut

sub assign_entry {
   my ( $rh_stats, $abbv, $name, $path, ) = @_;
   $$rh_stats{$abbv}{label} = $name unless ( exists $$rh_stats{$abbv} );
   $$rh_stats{$abbv}{total}++;
   # don't store paths that are only slash
   $$rh_stats{$abbv}{lookup}{$path}{count}++ unless ( $path eq "/" );
   return;
}

=head2 B<cleanup_by_sorting>

(reference to hash stats info,)

For each entity (country or state) find the path that was most requested and
purge the rest.

=over

=item I<Reference to stats hash for country or USA states information>

Data Structure for collected data
(
   'abbv' => {
      total  => 3,
      label  => 'Country or State in English'
      lookup => {
         '/path'  => {count => 2,},
      },
   },
)

=back

=cut

sub cleanup_by_sorting {
   my ($refh_stats) = @_;
   foreach my $loc ( keys %{$refh_stats} ) {
      my $i = 1;
      foreach my $r (
         sort { ${$refh_stats}{$loc}{lookup}{$b}{count} <=> ${$refh_stats}{$loc}{lookup}{$a}{count} }
         keys %{${$refh_stats}{$loc}{lookup}}
         )
      {
         delete ${$refh_stats}{$loc}{lookup}{$r} if ( $i != 1 );
         $i++;
      }
   }
   return;
}

=head2 B<world_stats>

(reference to hash stats info, top number items to be printed, )

Print the header information for the report showing the top N countries who had the most requested paths. 
Call subroutine print_top_N to print the most most requsted paths.

=over

=item I<Reference to stats hash for country information>

Data Structure for collected data
(
   'abbv' => {
      total  => 3,
      label  => 'Country or State in English'
      lookup => {
         '/path'  => {count => 2,},
      },
   },
)

=item I<top number of N country paths requested>

Print N number of entries

=back

=cut

sub world_stats {
   my ( $refh_stats, $top ) = @_;
   print "\nTop 10 Countries for visitors followied by most visted pages\n\n";
   print "Rank                        Total\n";
   print_top_N( $refh_stats, $top );
   return;
}

=head2 B<US_stats>

(reference to hash stats info, top number items to be printed, )

Print the header information for the report showing the top N US states who had the most requested paths. Call subroutine print_top_N to print the most most requsted paths.

=over

=item I<Reference to stats hash for US state information>

Data Structure for collected data
(
   'abbv' => {
      total  => 3,
      label  => 'Country or State in English'
      lookup => {
         '/path'  => {count => 2,},
      },
   },
)

=item I<top number of N US state paths requested>

Print N number of entries

=back

=cut

sub US_stats {
   my ( $refh_stats, $top ) = @_;
   print "\nTop 10 States for visitors followied by most visted pages\n\n";
   print "Rank                        Total\n";
   print_top_N( $refh_stats, $top );
   return;
}

=head2 B<print_top_N>

(reference to hash stats info, top number items to be printed, )

Print the entity information for the report showing the top N US states who had the most requested paths

=over

=item I<Reference to stats hash for country or US state information>

Data Structure for collected data
(
   'abbv' => {
      total  => 3,
      label  => 'Country or State in English'
      lookup => {
         '/path'  => {count => 2,},
      },
   },
)

=item I<top number of N country or US state paths requested>

Print N number of entries

=back

=cut

sub print_top_N {
   my ( $refh_stats, $top ) = @_;
   my $i = 1;
   foreach my $loc ( sort { $refh_stats->{$b}{total} <=> $refh_stats->{$a}{total} } keys %{$refh_stats} ) {
      printf "  %2d: %-20s ", $i, ${$refh_stats}{$loc}{label};
      printf "%6d  ", ${$refh_stats}{$loc}{total};
      my $rh = ${${$refh_stats}{$loc}}{lookup};
      foreach my $r ( keys %{$rh} ) {
         print $r;
      }
      print "\n";
      last if ( $i == $top );
      $i++;
   }
   return;
}
1;
