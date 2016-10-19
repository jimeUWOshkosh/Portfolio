#!/usr/bin/env perl
use strict; use warnings;
use feature 'say';
use Test::More;
use Try::Tiny;
use lib 'lib';
use ATM::Schema;
use CGI qw/:standard/;
use Config::Any;
use Data::Dumper;

# Read in project config
my $file = '/home/wds/atm/a_t_m.json';
my @files = ( $file );
my $config = Config::Any->load_files( { use_ext => 1,  files => \@files });
my $cfg = $config->[0]->{$file};

# restore save point
my $cmd = "$cfg->{RDBMS} --user=$cfg->{USER} --password=$cfg->{PASSWORD} < ~/atm/db/ATM-sql.txt";
system($cmd) == 0 or do {
   my $mesg = sprintf "%d %d %d",
         ($? >> 8), ($? & 127), ($? & 128);
   #    exit value  signal       core dump
   die "system $cmd : failed $mesg $?";
};

my $schema;
try {
    $schema = ATM::Schema->connect( $cfg->{DSN}, 
                                    $cfg->{USER}, 
                                    $cfg->{PASSWORD} );
} catch {
    die("RDBMS Issue:" );
};


# get list of owner(s)
#   get Account id asscociated with Account Number
my $account = $schema->resultset('Account')
  ->search( { account_number => 10001 } )->first;
#   You have the Account id. find all customer associated with this account.
#   Gather all the Person ids
my @owners;
foreach my $o ( $account->get_owner_list ) {
    push @owners, $o->c_person;
}

# Find all accounts associated with this owners
# You Person ids of each owner, query the Customer table
my @dest_accs;
foreach my $o (@owners) {
    my @accounts = $schema->resultset('Customer')
      ->search( { pid => $o->pid } )->all;
    # remove source account
    my @tmp_accs = grep { $_->aid != $account->aid } @accounts;
    push @dest_accs, @tmp_accs;
}

ok(scalar(@dest_accs) == 2, "Correct number of accounts to display");


say 'error' if (scalar(@dest_accs) == 0 );

my @acc_2display;
for my $a (@dest_accs) {
   my $akount = $schema->resultset('Account')
     ->search( { aid => $a->aid } )->first;

   my $str = sprintf("%d Balance: \$ %d", $akount->account_number, $akount->balance);
   like  ($str, qr/\d{5} Balance: \$ \d{5}/, "Correct format for screen");

   push @acc_2display, { account_number => $akount->account_number, desc => $str };
}
my $account_number = $account->account_number;

done_testing();
exit(0);
