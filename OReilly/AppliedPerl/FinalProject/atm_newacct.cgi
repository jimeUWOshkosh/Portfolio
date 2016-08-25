#!/usr/bin/perl -w
use strict;

use CGI qw/:standard/;

print	header,
        start_html(-title=>"First Bank of O\'Reilly"),
        h1("First Bank of O\'Reilly"),
        p('Automated Teller Machine'),
	h2('Enter New Account'),
	start_form(-action=>"atm_process_newacct.cgi");
print   "<TABLE>";
print   "<TR><TD>Account:</TD><TD>", textfield(-name=>'account_number', -size=>8, -maxlength=>8), "</TD></TR>";
print   "<TR><TD><BR></BR></TD></TR>";
print   "<TR><TD>Do you have another account you</TD></TR>";
print   "<TR><TD>wish to link to this new account?</TD></TR>";
print   "<TR><TD>Associated Account:</TD><TD>", textfield(-name=>'account_number2', -size=>8, -maxlength=>8), "</TD></TR>";
print   "<TR><TD><BR></BR></TD></TR>";
print   "<TR><TD>Owner(s)</TD></TR>";
print   "<TR><TD>Owner #1 First Name:</TD><TD>", textfield(-name=>'fname1', -size=>20, -maxlength=>20), "</TD>";
print       "<TD>Last Name:</TD><TD>", textfield(-name=>'lname1', -size=>40, -maxlength=>40), "</TD></TR>";
print   "<TR><TD>Owner #2 First Name:</TD><TD>", textfield(-name=>'fname2', -size=>20, -maxlength=>20), "</TD>";
print       "<TD>Last Name:</TD><TD>", textfield(-name=>'lname2', -size=>40, -maxlength=>40), "</TD></TR>";
print   "<TR><TD>Deposit:</TD><TD>",  textfield(-name=>'amount',   -size=>8, -maxlength=>8), "</TD></TR>";
print   "<TR><TD>Password:</TD><TD>", textfield(-name=>'password', -size=>8, -maxlength=>8), "</TD></TR>";
print   "</TABLE>";
print	submit(-name=>'Submit'),
	end_form,
        end_html;
exit(0);

=head1 NAME

atm_newacct.cgi

=head1 SYNOPSIS

Part of the "First Bank of O\'Reilly" ATM web system.

Create a new bank account. This is a maintenace program for the
ATM web system.

Data Entry:
The bank employee enters:
   The new account number
   If this new account has the same owners as an existing account the
    user can enter that account number.

   The next fields are the owner(s) first and last names for the owner of the account.
   If the account is linked to an existing account there is no need to enter in
   the owner(s)' names since they are already on file.

   The user then enters in the deposit associated with new account.

   The final field is the new accounts pasword.

The user presses the "submit" button to process the data entered. The new account
creation is done by "atm_process_newacct.cgi".

=head1 Modules Used

CGI.pm

=head1 Author

James Edwards Feb-2014

=cut
