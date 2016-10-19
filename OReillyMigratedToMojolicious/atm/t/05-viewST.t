#!/usr/bin/env perl
use strict; use warnings;
use feature 'say';
use Test::More;
use Try::Tiny;
use lib 'lib';
use ATM::Schema;
use ATM::Model::Library;
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



my $account_obj = $schema->resultset('Account');
say ref($account_obj);

my $account = $account_obj->get_account_info(10001);
ok ($account->isa("ATM::Schema::Result::Account"), "Account object");

my $owner_str = ATM::Model::Library::get_owners_names($account);
say $owner_str;
ok($owner_str eq "Emily Dickinson, Robert Frost", "list of owners names is correct");

my @transactions = ATM::Model::Library::get_transaction_list_for_html($schema, $account);

foreach my $t (@transactions) {
    ok(ref($t) eq "HASH", "transaction element is a HASH");
    say "$t->{transaction_date} $t->{tid} $t->{amount} $t->{new_balance}";
}

done_testing();
exit(0);
