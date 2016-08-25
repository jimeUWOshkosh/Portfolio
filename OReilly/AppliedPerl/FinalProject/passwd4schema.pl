#!/usr/local/bin/perl

use strict;
use warnings;

my $psw = "10001";
my $salt = "ab";
my $encryptedPsw = crypt $psw, $salt;
print "$encryptedPsw\n";
$psw = "10002";
$encryptedPsw = crypt $psw, $salt;
print "$encryptedPsw\n";
