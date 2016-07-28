package User;

use strict;
use warnings NONFATAL => 'uninitialized';
our $VERSION = '0.01';
use English;

#use lib 'lib';
use Moo;
use MooX::late;
use MooX::Types::MooseLike::Base ':all';

use Tweet;
use feature 'say';
use Carp 'croak';

#use POSIX qw(strftime);

=head1 NAME

User - Pseudo Twitter User Object

=head1 VERSION

version 0.01

=head1 AUTHOR

James Edwards

=head1 SYNOPSIS

 use User;
 my $user = User->new( user  => "George57",
                       name  => "George Jeston",
                       email => "gjeston\@spacelysprockets.com",
                       phone => "555-867-5309"
                     );
 use Tweet;
 my $mesg = Tweet->new( mesg => 'MadMongers rock' );
 $user->push_tweet($mesg);


=head1 DESCRIPTION

An Object to hold info about a user and a list of their current tweets.

=head1 Accessor(s)

=head2 user

   data_type: Str

=head2 name

   data_type: Str

=head2 email

   data_type: Str

=head2 phone

   data_type: Str

=head1 Method(s)

=head2 next_tweet

	Equates to "shift" a tweet off a user's tweet array

=head2 count_tweets

        Equates to "count" tweets on a user's tweet array

=head2 has_no_tweets

        Equates to "is_empty" for the tweet object(s) on 
        user's tweet array

=head2 all_tweets

	Equates to all "elements"/tweet objects on user's 
        tweet array

=cut

has 'user' => ( is => 'rw', isa => Str, required => 0, );

has 'name' => ( is => 'rw', isa => Str, required => 0, );

has 'email' => ( is => 'rw', isa => Str, required => 0, );

has 'phone' => ( is => 'rw', isa => Str, required => 0, );

has 'tweets' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRef[Tweet]',
    default => sub { [] },
    handles => {

        #        'push_tweet'   => 'push',
        'next_tweet'    => 'shift',
        'count_tweets'  => 'count',
        'has_no_tweets' => 'is_empty',
        'all_tweets'    => 'elements',
    },
);

=head2 push_tweet

	Equates to "push" a tweet onto a user's tweet array

=cut

sub push_tweet {
    my $this = shift;
    my $obj  = shift;
    if ( $obj->isa('Tweet') ) {
        push @{ $this->tweets }, $obj;
    }
    else {
        croak 'Non Tweet object on list. Type: ', ref $obj;
    }
    return;
}

=head2 print_tweets

	Print all the tweet(s) on the user's tweet array

=cut

sub print_tweets {
    my $this = shift;
    for my $t ( @{ $this->tweets } ) {
        if ( $t->isa('Tweet') ) {

            #      say $t->tm, ": ",$t->mesg;
            say $t->dt->strftime('%a %d-%m-%Y %r: '), $t->mesg
              or croak "Issue printing: $OS_ERROR";
        }
        else {
            croak 'Non Tweet object on list. Type: ', ref $t;
        }
    }
    return;
}

=head2 print_all

        Print information about the user and all the tweet(s) on 
        the user's tweet array

=cut

sub print_all {
    my $this = shift;
    say 'User Id: ', $this->user, "\n", 'User\'s Name: ', $this->name
      or croak "Issue printing: $OS_ERROR";
    say 'E-Mail: ', $this->email, "\n", 'Tele: ', $this->phone
      or croak "Issue printing: $OS_ERROR";
    $this->print_tweets;
    return;
}

=head1 SUBROUTINES/METHODS


=head1 DIAGNOSTICS


=head1 CONFIGURATION AND ENVIRONMENT


=head1 DEPENDENCIES


=head1 INCOMPATIBILITIES


=head1 BUGS AND LIMITATIONS


=head1 LICENSE AND COPYRIGHT

Ya Right

=cut

1;

