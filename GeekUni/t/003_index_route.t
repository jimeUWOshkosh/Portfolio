use Test::More;
use Plack::Test;
use HTTP::Request::Common; # install separately

use art;

my $app  = art->to_app;
my $test = Plack::Test->create($app);

my $res = $test->request( GET '/' );
is( $res->code, 200, '[GET /] Request successful' );
#like( $res->content, qr/hello, world/, '[GET /] Correct content';

done_testing;

my $app = art->to_app;
is( ref $app, 'CODE', 'Got app' );
