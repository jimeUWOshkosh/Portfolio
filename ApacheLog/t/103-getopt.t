use strict;
use warnings;
use Test::Cmd;
use Test::More;

our $VERSION = 0.0001;

my $test = Test::Cmd->new( prog => 't/103-getopt.pl', workdir => '' );
$test->run();

is( $? >> 8, 255, 'No arguments: exit status' );
$test->run( args => '--help' );
is( $? >> 8, 0, '--help: exit status' );
$test->run( args => '--log=data/apache.log -geo=data/GeoLite2-City.mmdb' );
is( $? >> 8, 0, '--log and --geo: exit status' );
$test->run( args => '--log=data/apache.log' );
is( $? >> 8, 255, '--log only: exit status' );
$test->run( args => '-geo=data/GeoLite2-City.mmdb' );
is( $? >> 8, 255, '--geo only: exit status' );
$test->run( args => '--log=data/apache.logg -geo=data/GeoLite2-City.mmdb' );
is( $? >> 8, 2, '--log does not exist: exit status' );
$test->run( args => '--log=data/apache.log -geo=data/GeoLite2-City.mmdbb' );
is( $? >> 8, 2, '--geo does not exist: exit status' );
done_testing;
1;
