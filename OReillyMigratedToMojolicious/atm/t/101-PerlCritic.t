#!/usr/bin/env perl
use strict; use warnings;
use Test::Perl::Critic;
#use Test::More tests => 1;
use Test::Most;
critic_ok('lib/ATM.pm');
critic_ok('lib/ATM/Controller/Login.pm');
critic_ok('lib/ATM/Controller/Main.pm');
critic_ok('lib/ATM/Controller/Trans.pm');
critic_ok('lib/ATM/Model/Bank.pm');
critic_ok('lib/ATM/Model/Library.pm');
done_testing();
exit(0);
