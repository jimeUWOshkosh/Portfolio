package Tweet;
use strict;
use warnings NONFATAL => 'uninitialized';
use Moo;
use MooX::late;
use MooX::Types::MooseLike::Base ':all';
use DateTime;

our $VERSION = '0.01';

=head1 NAME

Tweet.pm - Pseudo Twitter Tweet Object

=head1 VERSION

VERSION 0.01

=head1 SYNOPSIS

use Tweet;

my $mesg = Tweet->new( mesg => 'Madmongers rock' );

=head1 DESCRIPTION

An Object to hold info about an individual tweet.

=head1 ATTRIBUTES

=head2 mesg

data_type:	Str

=head3 DEFAULT ATTRIBUTE(S)

=head4 dt

data_type:	DateTime
value:	local time_zone now

=cut

has 'mesg' => ( is => 'rw', isa => Str, required => 0, );
has 'dt' => (
    is      => 'rw',
    isa     => 'DateTime',
    default => sub { DateTime->now( time_zone => 'local' ) },
);

1;
__END__

=head1 METHODS

NONE

=head1 BUGS

No Features to report

=head1 AUTHOR

James Edwards

=head1 LICENSE

Ya Right

=cut

