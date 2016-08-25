#!/usr/local/bin/perl
use strict;
use warnings;

use lib qw(/users/jedwards3/mylib/lib/perl5);
use CGI qw/:standard/;
use CGI::Carp qw(fatalsToBrowser);
use Bank;
use Array::Utils qw(:all);

my ($account_number,$acc);
#my @this_account;
my @acc_2display;

validate();

my @owners = $acc->owners;
my $owner = $owners[0];
my @list_of_accnts = $owner->accounts;
my @account_list = map { $_->account_number } @list_of_accnts;
if ((scalar(@owners)) == 1) {
  if ((scalar(@account_list)) == 1) {
    error_message("Account Information","No account to transfer to");
  }
  else {
    # remove this account from list
    my @this_account = ($acc->account_number);
#    $this_account[0] = $acc->account_number;
    # difference
#    @acc_2display = array_diff(@this_account,@account_list);
    my @acc_2display = grep(!defined $this_account{$_}, @account_list    );
    display_menu();
  }
}
else {
  my $i=0;
  foreach my $own (@owners) {
    if ($i == 0) { $i++; next; }
    my @list_of_accnts = $owner->accounts;
    my @acc_list = map { $_->account_number } @list_of_accnts;
    # the intersection
    my @isect = grep( $account_list{$_}, @acc_list );
#    my @isect = intersect(@acc_list,@account_list);
    $i++;
    @account_list = @isect;
  }
  if ((scalar(@account_list)) == 1) {
    error_message("Account Information","No account to transfer to");
  }
  else {
    # remove this account from list
    my @this_account = ($acc->account_number);
#    $this_account[0] = $acc->account_number;
    # difference
    my @acc_2display = grep(!defined $this_account{$_}, @account_list);
#    @acc_2display = array_diff(@this_account,@account_list);
    display_menu();
  }
}
exit(0);

sub display_menu {
my %a2d;
for (@acc_2display) {
  $a2d{$_}++;
}
for my $i (@acc_2display) {
   my ($accnt) = Bank::Account->search( account_number => $i );
   $a2d{$i} = sprintf("%d Balance: \$ %d", $accnt->account_number, $accnt->balance);
}
print	header,
        start_html(-title=>"First Bank of O\'Reilly"),
        h1("First Bank of O\'Reilly"),
        p('Automated Teller Machine'),
	h2('Transaction Status'),
	p("Choose Account to Transfer to"),
	start_form(-action=>"param_list.cgi"),
        scrolling_list(-name=>'listname', -values=>[@acc_2display], 
	                     -size=>(scalar(@acc_2display)),
		             -labels=>\%a2d ),
	br,	
	hidden(-name => 'account_number', -value => $account_number),
	"Amount: ",
	textfield(-name=>'amount', -size=>8, -maxlength=>8),
	br,
	submit(-name=>'Submit', -value=>'Submit'),
	end_form,
	br,
	start_form(-action=>"menu.cgi"),
	hidden(-name => 'account_number', -value => $account_number),
	submit(-name=>'Submit', -value=>'Return to Main Menu'),
	end_form,
        end_html;
}
exit(0);

sub validate {
  $account_number=param('account_number');
  if (!valid_integer($account_number)) {
    error_message("Data passed","Account number not an integer");
    exit(0);
  }
  if (!($acc = account_on_file($account_number))) {
    error_message("Data passed","Account number not on file");
    exit(0);
  }
}
=head1 NAME

atm_transfer.cgi

=head1 SYNOPSIS

Part of the "First Bank of O\'Reilly" ATM web system.

Called via the main menu.

Given a bank account, display to the user a list of their accounts that
they can transfer money to. Upon choosing an account and entering the
amount they wish to transfer, the user will press the submit button and
the process of updating the RDBMS will be done by atm_process_transfer.cgi 
given the "to" account, "from" account & the amount to transfer.

The user does have the option to return to the main menu if they choose
not to continue the process.

=head1 Author

James Edwards Feb-2014

=cut
