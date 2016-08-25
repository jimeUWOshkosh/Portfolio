#!/usr/bin/perl -w
use strict;

use CGI qw/:standard/;
use ATMlib;

my $account_number;
validate();

print	header,
        start_html(-title=>"First Bank of O\'Reilly"),
        h1("First Bank of O\'Reilly"),
        p('Automated Teller Machine'),
	h2('Menu'),
	start_form(-action=>"redirect.cgi"),
	hidden(-name => 'account_number', -value => $account_number);
print   "<select name=select SIZE=4>";
print   "<option value=atm_transCR.cgi>Process Credit</option>";
print   "<option value=atm_transDB.cgi>Process Debt</option>";
print   "<option value=atm_viewST.cgi>View Statement</option>";
print   "<option value=atm_transfer.cgi>Transfer Money Between Accounts</option>";
print   "</select><br>";
print	submit(-name=>'Submit'),
	end_form,
        end_html;
exit(0);

sub validate {
  $account_number=param('account_number');
  if (!valid_integer($account_number)) {
    error_message('Data passed','Account number not an integer');
    exit(0);
  }
  if (!account_on_file($account_number)) {
    error_message('Data passed', 'Account number not on file');
    exit(0);
  }
}

=head1 NAME

menu.cgi

=head1 DESCRIPTION

Part of the "First Bank of O'Reilly" ATM web system.

Called by ATM's login screen (atm_login.cgi) to displaying a scrolling list 
of menu selections.

The ATM's login screen passes the current user's account number to
the main menu. When the user makes a selection and presses the "submit" button,
the program "redirect.cgi" is called passing the menu option selected and
the user's login id.

At the current time the menu options consist of
  Process Credit (atm_viewCR.cgi)
  Process Debit (atm_viewDB.cgi)
  View Statement (atm_viewST.cgi)
  Transfer Money Between Accounts (atm_transfer.cgi)

If no selection is made and the user presses the "submit" button, the main
menu will once again be displayed to the user.

=head1 Modules Used

CGI.pm

=head1 Author

James Edwards Mar-2014

=cut

