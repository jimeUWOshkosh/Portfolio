#!/usr/bin/perl -Ilib
use Test::More tests => 2;
use strict;
use warnings;

# the order is important
use GuArt::Controller;
use Dancer2::Test apps => ['GuArt::Controller'];

#route_exists [GET => '/'], 'a route handler is defined for /';
response_status_is ['GET' => '/'], 302, 'response status is 302 for /';

my $response = dancer_response
    POST => '/', {
      params => { login_user => 'Andrew' }
    };
is($response->status, 200, 'successful 200 response on login');
