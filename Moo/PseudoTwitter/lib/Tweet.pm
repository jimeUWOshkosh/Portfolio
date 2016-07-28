package Tweet;

use strict;
use warnings NONFATAL => 'uninitialized';
use Moo;
use MooX::late;
use MooX::Types::MooseLike::Base ':all';
use DateTime;

our $VERSION = '0.01';

=head1 NAME

Tweet - Pseudo Twitter Tweet Object

=head1 VERSION

version 0.01

=head1 SYNOPSIS

 use Tweet;

 my $mesg = Tweet->new( mesg => 'Madmongers rock' );

=head1 DESCRIPTION

An Object to hold info about an individual tweet.

=head1 Accessor(s)

=head2 mesg

  data_type:	Str

=head1 Default Attribute(s)

=head2 dt

  data_type:	DateTime
  value:	local time_zone now

=cut

has 'mesg' => ( is => 'rw', isa => Str, required => 0, );
has 'dt' => (
   is      => 'rw',
   isa     => 'DateTime',
   default => sub { DateTime->now(time_zone => 'local') },
);

=head1 COPYRIGHT

Ya Right

=cut

1;
