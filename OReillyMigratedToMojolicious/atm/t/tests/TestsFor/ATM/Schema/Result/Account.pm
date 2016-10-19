package TestsFor::ATM::Schema::Result::Account;
use Test::Class::Moose parent => 'My::Test::Class';
use namespace::autoclean;
use ATM::Schema;
use Config::Any;
use feature 'say';

my $schema;
my $t_account;

sub test_startup  { 
    my ($test, $report) = @_;
#    $test->next::method($report); # call parent method

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
        # exit value  signal       core dump
        die "system $cmd : failed $mesg $?";
    };

    $schema = ATM::Schema->connect( $cfg->{DSN},
                                    $cfg->{USER},
                                    $cfg->{PASSWORD} );
}

sub test_setup {
    my ($test, $report) = @_;
    $test->next::method($report); # call parent method

    $t_account = $schema->resultset('Account')->search({ account_number => 10001 })->first;
}

sub test_teardown { }
sub test_shutdown { }

#sub test_constructor : Tests(3) {
#sub test_constructor {
#    my ($test, $report) = @_;
##    $report->plan(3);
#}

#sub test_balance : Tests(2) {
sub test_balance : Tests(1) {
    my ($test, $report) = @_;

    cmp_ok $t_account->balance, '>=', 0.0,
      '... and it should return non negative balance';
}

sub test_result : Tests(4) {
    my ($test, $report) = @_;

    my $count = $t_account->a_customers->all;
    ok ($count == 2, "Correct number of owners");

    $count = $t_account->get_owner_list;
    ok ($count == 2, "Correct number of owners");

    $count = $t_account->trans->all;
    ok ($count == 2, "Correct number of transactions");

    $count = $t_account->get_transaction_list;
    ok ($count == 2, "Correct number of owners");
}

sub test_resultset : Test(1) {
    my ($test, $report) = @_;

    my $account_model = $schema->resultset('Account');
    my $account = $account_model->get_account_info(10001);
    ok($account->isa("ATM::Schema::Result::Account"), "object is correct");
}

__PACKAGE__->meta->make_immutable;

1;
