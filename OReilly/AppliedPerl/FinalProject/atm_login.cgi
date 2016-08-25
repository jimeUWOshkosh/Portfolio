#!/usr/local/bin/perl
use strict;
use warnings;

use lib qw(/users/jedwards3/mylib/lib/perl5);
use CGI qw(param);
use CGI::Carp qw(fatalsToBrowser);
use MyTemplate;

my $template = MyTemplate->new;
print $template->html_output;
exit(0);

=head1 NAME

atm_process_login.cgi

=head1 DESCRIPTION

Part of the "First Bank of O'Reilly" ATM web system.

This is the login screen for the ATM system.

Upon entering the user's account number and password, the process of validating
access to the system is done by "atm_process_login.cgi". This program passes
the validation process the user's account and password to the program.

If the user information is not correct the user is given the option to return
to the login screen.

If validation is successful the user will be displayed the ATM menu system.

=head1 Modules Used

CGI.pm
HTML::Template

MyTemplate.pm

=head1 Author

James Edwards Mar-2014

=cut

