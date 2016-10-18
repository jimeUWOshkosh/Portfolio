#!/usr/bin/env perl
use strict; use warnings; use feature 'say'; use Carp 'croak';
use Data::Dumper;
our $Dbug = 1;

our $VERSION = qw( 0.01);

=head1 NAME

        DLL2.pl

=head1 DESCRIPTION

 Double Linked List 
 Used dummy header and tail nodes to make the logic easier.
 Derefernces do NOT use the binary infix operator (arrow operator)

=head1 VERSION

version 0.01

=head1 AUTHOR

James Edwards

=cut


# insert node before the node pointer passed in
# $data in this case is a just a message
sub insert_node_before { 
   my ($data, $ptr) = @_;
   say "start insert_node_before" if $Dbug;

   my $rh_node;

   eval {
      # Create node and hook to previous node
      $rh_node = { data => $data, prev => ${$ptr}{prev}, nxt => $ptr };
      1;
   } or do {
      croak "caught error 'insert_node_before': $@"; 
   };

   # Hook to node that got pushed down the list
   ${$rh_node}{nxt}{prev} = $rh_node;

   # Hook previous node to know the new node is next
   ${$rh_node}{prev}{nxt} = $rh_node;

   say "end insert_node_before", "\n" if $Dbug;
   return $rh_node;
}

sub print_forward {
   say "start print_forward" if $Dbug;
   my $ptr = shift;
   while ($ptr) {
      say '  ', ${$ptr}{data} or croak "output error: $!";
      $ptr = ${$ptr}{nxt};
   }
   say "end print_forward", "\n" if $Dbug;
   return;
}

sub print_backwards {
   say "start print_backwards" if $Dbug;
   my $ptr = shift;
   while ($ptr) {
      say '  ', ${$ptr}{data} or croak "output error: $!";
      $ptr = ${$ptr}{prev};
   }
   say "end print_backwards", "\n" if $Dbug;
   return;
}


# Set up. Create dummy header and tail and link up
my ($rh_tail, $rh_hdr);
eval {
   $rh_tail = { data => 'dummy tail node', prev => undef, nxt => undef    };
   $rh_hdr  = { data => 'dummy hdr node',  prev => undef, nxt => $rh_tail };
   ${$rh_tail}{prev} = $rh_hdr;
   1;
} or do {
   croak "caught error in 'setup': $@"; 
};


# insert a front of list
my $list_hdr = ${$rh_hdr}{nxt};
$list_hdr = insert_node_before( '1st node', $list_hdr );
$list_hdr = insert_node_before( '2nd node', $list_hdr );
#my $list_hdr = ${$rh_hdr}{nxt};
#insert_node_before( '3rd node', $list_hdr );

# insert at the tail end
insert_node_before( '3rd node', $rh_tail );

print_forward( $rh_hdr) ;
print_backwards( $rh_tail );

#print Dumper(\$rh_hdr);
exit 0;
