use strict;
use warnings;

use art;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use Data::Dumper;

my $app = art->to_app;
is( ref $app, 'CODE', 'Got app' );

my $test = Plack::Test->create($app);
my $res  = $test->request( GET '/' );
#print Dumper($res);

is($res->code, 302, 'successful 200 response on /');

done_testing();
1;
