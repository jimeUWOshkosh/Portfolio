#!/usr/local/bin/perl
use strict;
use warnings;

use lib qw(/users/jedwards3/mylib/lib/perl5);
use CGI qw(param);
use CGI::Carp qw(fatalsToBrowser);

my $account_number=param('account_number');
my $url=param('select');
my $query=new CGI;

# if no selection was made, return to main menu
$url="menu.cgi" if (!(defined($url)));

print $query->redirect("$url?account_number=$account_number");
exit(0);

=head1 NAME

redirect.cgi

=head1 DESCRIPTION

Part of the "First Bank of O'Reilly" ATM web system.

Called by ATM's main menu that is displaying a scrolling list of menu
selections.

The ATM's login screen passes the current user's account number to
the main menu, now "redirect" must pass that information onto the
next program to be executed.

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

