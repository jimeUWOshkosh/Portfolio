package TestsFor::ATM::Schema::Result::Customer;
use Test::Class::Moose parent => 'My::Test::Class';
use namespace::autoclean;
use ATM::Schema;
use Config::Any;

my $schema;
my $t_customer;

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

    $t_customer = $schema->resultset('Customer')->search({ cid => 1 })->first;
}

sub test_teardown { }
sub test_shutdown { }

#sub test_constructor : Tests(3) {
#sub test_constructor {
#    my ($test, $report) = @_;
#    $report->plan(3);
#}

sub test_result : Tests(2) {
    my ($test, $report) = @_;

    my $per = $t_customer->c_person;
    ok ($per->isa("ATM::Schema::Result::Person"), "Customer has one person");

    my $acc = $t_customer->c_accounts;
    ok ($acc->isa("ATM::Schema::Result::Account"), "Customer has one account");
}



__PACKAGE__->meta->make_immutable;

1;
