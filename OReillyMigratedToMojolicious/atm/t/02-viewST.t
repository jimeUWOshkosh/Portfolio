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



my $account = $schema->resultset('Account')->search({ account_number => 10001 })->first;
ok ($account->isa("ATM::Schema::Result::Account"), "Account object");

my @owners;
#foreach my $o ($account->owners) {
foreach my $o ($account->get_owner_list) {
    my $account = $o->c_accounts;
    my $person  = $o->c_person;
    ok ($account->isa("ATM::Schema::Result::Account"), "Account object");
    ok ($person->isa("ATM::Schema::Result::Person")  , "Person object");
    say $o->id . "---" . $account->account_number . "---". $person->first_name;
#    push @owners, $o->person;
    push @owners, $person;
}
my $str = join ', ', map { $_->first_name . " " . $_->last_name } @owners;

say $str;

my @trans;
foreach my $t ($account->get_transaction_list) {
    my $x = $t->single_trans;
    my $type = $x->tid eq 1 ? 'credit' : 'debit';
    my $t = { 
              date => $x->transaction_date,
              type => $type,
              amount => $x->amount,
              new_balance => $x->new_balance,
            };
    push @trans, $x;
}

#my @ATTRS = qw(transaction_date transaction_type amount new_balance);
my @ATTRS = qw(transaction_date tid amount new_balance);
my @transactions = map { my $t = $_; +{ map { $_, $t->$_ } @ATTRS } } @trans;
foreach my $t (@transactions) {
        $t->{tid} = $t->{tid}== 1 ? 'credit' : 'debit';
}

my @s = $schema->resultset('TransactionType')->search({ })->all;
foreach my $r (@s) {
    say $r->name;
}


done_testing();
exit(0);
