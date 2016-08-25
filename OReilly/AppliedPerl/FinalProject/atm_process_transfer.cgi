#!/usr/bin/perl -w
use strict;

use lib qw(/users/jedwards3/mylib/lib/perl5);
use CGI qw/:standard/;
#use CGI::Carp qw(fatalsToBrowser);
use Bank;

my ($account_number,$amount,$to_account);
my $message;
validate();

$account->add_transactions( { type           => "credit",
		              amount         => $amount } );
if (!($amount)) {
  my ($to_accnt) = Bank::Account->search( account_number => $to_account );
  $to_accnt->add_transactions( { type           => "debit",
   	                         amount         => $amount } );
}
print	header,
        start_html(-title=>"First Bank of O\'Reilly"),
        h1("First Bank of O\'Reilly"),
        p('Automated Teller Machine'),
	h2('Transaction Status'),
	p('Transaction was successful'),
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
  if (!($account = account_on_file($account_number))) {
    error_message("Data passed","Account number not on file");
    exit(0);
  }

  $to_account    =param('list_name');
  if (!valid_integer($to_account)) {
    error_message("Data passed","To account number not an integer");
    exit(0);
  }
  if (!($to_accnt = account_on_file($to_account))) {
    error_message("Data passed","To account number not on file");
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

atm_process_transfer.cgi

=head1 DESCRIPTION

Part of the "First Bank of O\'Reilly" ATM web system.

Called by atm_transfer.cgi

Given the "to" account, "from" account & the amount to transfer for
a customer, update the RDBMS.

The user is give the option to return to the main menu.

=head1 Modules Used

CGI.pm

Bank.pm (Class::DBI)

=head1 Author

James Edwards Feb-2014

=cut

