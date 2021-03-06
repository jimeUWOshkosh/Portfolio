#!/usr/bin/perl
use strict;
use feature 'say';
use Data::Dumper;
use Config::Any;
use Carp;

our $VERSION = '0.01';

# Use a UNITCHECK block to read a configuration file.
# The Configuration file would declare what tests to include and exclude
our $testfilters;
UNITCHECK {
   my $cfgFile  = 'myconfig.json';
   my @files    = ( $cfgFile,);
   my $config   = Config::Any->load_files( { files => \@files, use_ext => 1 } );
   if (defined ($$config[0]{$cfgFile}) ) {
      $testfilters = $$config[0]{$cfgFile};
   } else {
      croak "Could not open Config file :$cfgFile";
   }
}

use Attribute::Handlers;

# This is an attribute. An attribute is any subroutine 
# that has an attribute of :ATTR
# Attributes are compiled just before runtime, in the CHECK phase
sub Test :ATTR() {
   my ($package, $symbol, $code, $attr, $data, $phase) = @_;

   # $data holds the arguments to the attribute
   # In this example, the level of testing debugging is 
   # the first argument.
   my $level=1;;
   if (defined($data)) {
     say "$phase: @$data";
     $level = $data->[0];
   } 
                
   my $name = join '::', *{$symbol}{PACKAGE}, *{$symbol}{NAME};
                
   no warnings 'redefine';
   *{$symbol} = sub {
         # debugging statement
         warn sprintf "DEBUG[%s]: entering %s\n", scalar(localtime), $name;

         # PUT IN Filters
         say "@{$testfilters->{include}}";

         my @output = $code->(@_);

         # debugging statement
         if ( $level >= 2 ) {
            warn sprintf "DEBUG[%s]: leaving %s\n", scalar(localtime), $name;
         }
         return @output;
   };
}

# table: An Attribute Subroutine. Make sure we can handle a hash
sub table :Test(4,api, db) {
   {
      use warnings;
      my %data = @_;                
      while ( my ($key, $value) = each  %data) {
         say "$value  $key";
      }
   }
}

# introduce An Attribute Subroutine. Make sure we can handle an array
sub introduce :Test(1,6) {
   {
      use warnings;
      say "@_";
   }
}

# Main
use warnings;

# Test that the Attribute Handler can handle a hash variable 
# that is passed to the Attribute Subroutine
my %jetsons = (Dad => 'George', Mom => 'Jane', girl => 'Judy', boy => 'Elroy');
table(%jetsons);

# Test that the Attribute Handler can handle an array variable 
# that is passed to the Attribute Subroutine
my @stuff = qw(jimmy bob);
introduce(@stuff);

exit 0;
__END__
