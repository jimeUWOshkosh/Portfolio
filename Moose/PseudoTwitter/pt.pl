#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';
use lib 'lib';
use Carp 'croak';

use User;

our $VERSION = qw( 0.01);

=head1 NAME

	pt.pl

=head1 DESCRIPTION

	Program that uses the Pseudo_Twitter package.

=head1 VERSION

version 0.01

=head1 AUTHOR

James Edwards

=cut

my $u = User->new(
    user  => 'eLroy',
    name  => 'Elroy Jetseon',
    email => 'LRoy@notvalid.com',
    phone => '555-777-1234'
);
croak 'Error from User::push_tweet'
  if ( $u->push_tweet( Tweet->new( mesg => 'message 1' ) ) );
croak 'Error from User::push_tweet'
  if ( $u->push_tweet( Tweet->new( mesg => 'message 2' ) ) );
croak 'Error from User::push_tweet'
  if ( $u->push_tweet( Tweet->new( mesg => 'message 3' ) ) );

print 'Number of Tweets(count_tweets()): ', $u->count_tweets() . "\n";
print 'Has no Tweets(has_no_tweets()): ',
  $u->has_no_tweets() ? 'TRUE' : 'FALSE', "\n";

say '-------';

$u->print_all;

say '-------';

my $tweet = $u->next_tweet();
say 'first tweet shifted(next_tweet()) of array';
say $tweet->mesg;

say '-------';

say 'Copy messages to a list(all_tweets()) and pop them off';
my @list = $u->all_tweets();
while (@list) {
    $tweet = pop @list;
    say $tweet->mesg;
}

say '-------';
say 'Show whats left';

$u->print_all;

=head1 LICENSE AND COPYRIGHT

Ya Right

=cut

exit 0;
