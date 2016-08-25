#!/usr/bin/perl -w
use strict;

use lib qw(/users/jedwards3/mylib/lib/perl5);
use CGI qw/:standard/;
use CGI::Carp qw(fatalsToBrowser);
use Bank;
use ATMlib;

my $account_number;
my $password;
my $hmesg='Transaction Status';

validate();

my @account = Bank::Account->search( account_number => $account_number );
if (!(scalar(@account))) {
  display_message_with_submit($hmesg,"Access Denied", "atm_login.cgi",
	                      $account_number, "Return to FBO ATM Login");
}
else {
  my $encrypted_pswd = crypt $password, "ab";
  my $ref_h = $account[0];
  if ($ref_h->password eq $encrypted_pswd) {
    my $query=new CGI;
    print $query->redirect("menu.cgi?account_number=$account_number");
  }
  else {
    my $message= "Account Number or Password is not valid";
    display_message_with_submit($hmesg,$message, "atm_login.cgi",
	                        $account_number, "Return to FBO ATM Login");
  }
}
exit(0);

sub validate {
  $account_number=param('account_number');
  if (!valid_integer($account_number) {
    error_message("Data passed","Account number not an integer");
    exit(0);
  }

  $password=param('password');
  if ($password eq "") {
    error_message("Data passed","Password length is 0");
    exit(0);
  }
  return;
}

=head1 NAME

atm_process_login.cgi

=head1 DESCRIPTION

Part of the "First Bank of O'Reilly" ATM web system.

Called by ATM's login program (atm_login.cgi) .

Will verify that the account id and password combination is
valid. If valid will call redirect.cgi to initiate the ATM
menu system. If the information entered on the login screen
is not correct the user will receive a message screen with
the option to return to the login screen.

=head1 Modules Used

CGI.pm

Bank.pm (Class::DBI)
ATMlib.pm

=head1 Author

James Edwards Mar-2014

=cut

