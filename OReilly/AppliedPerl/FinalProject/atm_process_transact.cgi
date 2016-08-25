#!/usr/bin/perl -w
use strict;

use lib qw(/users/jedwards3/mylib/lib/perl5);
use CGI qw/:standard/;
use CGI::Carp qw(fatalsToBrowser);
use Bank;
use ATMlib;

my ($account_number,$amount,$type,$account);
my $message="Transaction was successful";
validate();

if (!($amount)) {
  $account->add_transaction( $type, $amount );
}
else
{
   $message="The dollar amount was not valid";
}
print	header,
        start_html(-title=>"First Bank of O\'Reilly"),
        h1("First Bank of O\'Reilly"),
        p('Automated Teller Machine'),
	h2('Transaction Status'),
	p($message),
	start_form(-action=>"menu.cgi"),
	hidden(-name => 'account_number', -value => $account_number),
	submit(-name=>'Return to Main Menu'),
	end_form,
        end_html;
exit(0);

sub validate {
  $account_number=param('account_number');
  if (!valid_integer($account_number)) {
    error_message("Data passed","Account number not an integer");
    exit(0);
  }
  if ($account = account_on_file($account_number)) {
    error_message("Data passed","Account number not on file");
    exit(0);
  }
  $amount=param('amount');
  if (!valid_integer($account_number)) {
    error_message("Data passed","Amount not an integer");
    exit(0);
  }
  $type=param('type');
  if (!defined($type)) 
    error_message("Data passed","Amount not an integer");
    exit(0);
  }
  else {
    if (!(($type eq "credit") or ($type eq "debit"))) {
      error_message("Data passed","Type is not valid");
      exit(0);
    }
  }
  return;
}


=head1 NAME

atm_process_transact.cgi

=head1 DESCRIPTION

Part of the "First Bank of O'Reilly" ATM web system.

Called by ATM's withdrawl and depsit programs (atm_transCR.cgi and atm_transDB.cgi).

This program receives the user's account number, type of transaction (debit or credit) and
the dollar amount. It then updates the RDBMS and display a screen so the user can
then return to the main menu.

When the user presses the "Return to Main Menu" button, this program calls "menu.cgi"
passing it the user's account number.

=head1 Modules Used

CGI.pm
Class::DBI

Bank.pm

=head1 Author

James Edwards Mar-2014

=cut

