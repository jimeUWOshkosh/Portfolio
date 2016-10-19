#!/usr/bin/env perl
use strict; use warnings;
use feature 'say';
use Test::More;
use Try::Tiny;
use lib 'lib';
use ATM::Schema;
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

my $rs = $schema->resultset('SingleTransaction')->search(
  {
    'account_number' => 10001,
  },
  {
    join     => { 'trans' => 'account',
                  'transactiontype' => 'single_trans' },
    '+select' => [qw(transaction_date transactiontype.name amount new_balance)],
    '+as'     => [qw(transaction_date name amount new_balance)],
  }
);

my $i1 = 0;
while (my $acc = $rs->next) {
  say "transaction_date: "      . $acc->transaction_date    . ", name: "  . $acc->get_column('name') .
      ", amount: " . $acc->amount . ", new_balance: " . $acc->new_balance;
  $i1++;
}

my $i2 = 0;
my $acc = $schema->resultset('Account')->search({ account_number => 10001 })->first;
foreach my $st ($acc->get_transaction_list) {
    say "transaction_date: " . $st->single_trans->transaction_date . ", tid: " . $st->single_trans->tid .
      ", amount: " . $st->single_trans->amount . ", new_balance: " . $st->single_trans->new_balance;
  $i2++;
}

ok ($i1 == $i2, "Both methods get the same number of rows");

done_testing();
exit(0);
