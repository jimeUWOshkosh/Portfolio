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
#print Dumper(\$config);
#print Dumper(\$cfg);

ok ($cfg->{DSN}      eq "DBI:mysql:atm", "DSN correct");
ok ($cfg->{RDBMS}    eq "mysql",         "RDBMS correct");
ok ($cfg->{USER}     eq "wds",           "DB user id correct");
ok ($cfg->{PASSWORD} eq "wds",           "DB user password  correct");

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


my $trans_type = $schema->resultset('TransactionType')->search({ name => 'credit' })->first;
ok (defined($trans_type), "Transaction Type Hash");
ok ($trans_type->name eq 'credit', "Transaction Type Credit");

$trans_type = $schema->resultset('TransactionType')->search({ name => 'debit' })->first;
ok (defined($trans_type), "Transaction Type Hash");
ok ($trans_type->name eq 'debit', "Transaction Type Debit");

my $account = $schema->resultset('Account')->search({ account_number => 10001 })->first;
ok (defined($account), "Account Hash");

#say $account->balance;
my $type = 'credit';
my $amount = 1;
my $new_balance = $account->balance + ($type eq 'debit' ? 1 : -1) * $amount;
ok ($new_balance == 10399, "New Balance is correct for a CR");

$type = 'debit';
$new_balance = $account->balance + ($type eq 'debit' ? 1 : -1) * $amount;
ok ($new_balance == 10401, "New Balance is correct for a DB");

my $single_trans;
my $transaction;
try {
    $single_trans = $schema->resultset('SingleTransaction')->create({
                                     amount           => $amount,
                                     tid              => $trans_type->tid,
                                     previous_balance => $account->balance,
                                     new_balance      => $new_balance,
                                   });
    $transaction = $schema->resultset('Transaction')->create({
                             sid => $single_trans->id,
                             aid => $account->aid,
                                   });
    $account->balance( $new_balance );
    $account->update;
} catch {
    die("RDBMS Issue: $@\n$_" );
};

done_testing();
exit(0);
