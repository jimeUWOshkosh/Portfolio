package MySubs;
use strict; use warnings; use feature 'say';
use base 'MyAttributeHandler';


# table: An Attribute Subroutine. Make sure we can handle a hash
sub table :Test(4,api, db) {
   {
      use warnings;
      
      # method vs subroutine call
      if ($_[0] eq __PACKAGE__) {
         my $class = shift @_;
      }
      my %data = @_;                
      while ( my ($key, $value) = each  %data) {
         say "$value  $key";
      }
   }
}
1;
__END__
