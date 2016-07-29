#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use lib 'lib';

our $VERSION = '0.01';

use User;
use Tweet;

=head1 NAME

	01-pt.pl

=head1 DESCRIPTION

	Test the Pseudo_Twitter packages (User, Tweet).
	  1) Be able to create "User" and "Tweet" objects
	  2) test their attribute methods
	  3) test their object methods

=cut

use Test::Most tests => 13;

#use Test::Most 'no_plan';

use User;
use Tweet;

diag("\ntest creation of 'User' object");
my $user1 = new_ok('User');

diag("\ntest existence of User's attribute");
can_ok( $user1, $_ ) for qw (user name email phone tweets);

diag("\ntest existence of User's methods");
can_ok( $user1, $_ ) for qw (push_tweet print_all print_tweets);

diag("\nadd user data by attribute methods");
$user1->user('jim89');
$user1->name('Jim Bo');
$user1->email('jamesAT19@abc.com');
$user1->phone('555-777-5309');

diag("\ncreate a User object with new with all attributes (except tweets)");
my $user2 = User->new(
    user  => 'jim89',
    name  => 'Jim Bo',
    email => 'jamesAT19@abc.com',
    phone => '555-777-5309',
);
diag 'user 1';
note explain $user1;
is_deeply( $user1, $user2, 'Compare the two objects' ) or diag explain $user2;

diag("\ntest creation of \"Tweet\" object");
my $mesg1 = new_ok('Tweet');

diag("\nadd tweet data by attribute method(s)");
$mesg1->mesg('message 1');

diag("\nadd first message to User by push_tweet method");
$user1->push_tweet($mesg1);

diag("\nadd second message to User by push_tweet method");
my $mesg2 = Tweet->new( mesg => 'message 2' );
$user1->push_tweet($mesg2);

diag(
    "\nadd third message to User by chaining a new within a push_tweet method");
$user1->push_tweet( Tweet->new( mesg => 'message 3' ) );

diag("\nDump a User object");
$user1->print_all;

#   Note:  Runtime error or 255
#          A new member value for tweets does not pass its type constraint ...
#
#diag("\nPut a different class on the Tweet list using push_tweet");
my $card = { suit => 'spades', value => 'ace' };
bless $card, 'PlayingCard';
diag('Push a bad tweet');
throws_ok {
    $user1->push_tweet($card);
}

#qr/^A new member value for tweets does not pass its type constraint/,
#  'You pushed a non Tweet object onto the array by hand';
qr/^Non Tweet object on list. Type: PlayingCard/,
  'You pushed a non Tweet object onto the array by hand';

diag("\nAdd a non-Tweet object to User by hand");
diag('This is by-passing Moose');
push @{ $user1->tweets }, $card;

diag("\nDump a User object again");
throws_ok {
    $user1->print_all;
}
qr/^Non Tweet object on list. Type:/,
  'You pushed a non Tweet object onto the array by hand';

exit 0;
