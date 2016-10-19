use Mojo::Base -strict;
use Test::More;
use Test::Mojo;

use lib 'lib';

my $t = Test::Mojo->new('ATM');
$t->get_ok('/login')->status_is(200)->content_like(qr/Reilly/i);

done_testing();
