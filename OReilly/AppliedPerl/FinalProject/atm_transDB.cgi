#!/usr/local/bin/perl
use strict;
use warnings;

use lib qw(/users/jedwards3/mylib/lib/perl5);
use CGI qw(param);
use CGI::Carp qw(fatalsToBrowser);
use MyTemplate;
use Bank;
use ATMlib;

my $account_number;
validate();

my $template = MyTemplate->new;
$template->param( account_number=> $account_number);
my $message = "Enter the amount you wish to deposit";
$template->param( message=> $message);

print $template->html_output;
exit(0);

sub validate {
  $account_number=param('account_number');
  if (!valid_integer($account_number)) {
    error_message("Data passed","Account number not an integer");
    exit(0);
  }
  my $account;
  if ($account = account_on_file($account_number)) {
    error_message("Data passed","Account number not on file");
    exit(0);
  }
  return;
}


=head1 NAME

atm_transDB.cgi

=head1 DESCRIPTION

Part of the "First Bank of O'Reilly" ATM web system.

Called by ATM's menu program (menu.cgi via redirect.cgi) .

This program handles the initial input for a user who wants to deposit money
to their account. The user to enters the dollar amount they wish
to deposit and presses the "submit" button. The process to handle the
transaction of the addition is passed to "atm_process_transact.cgi".

The user can cancel the entry of data by returning to the main menu.

The ATM's menu screen passes the current user's account number to
this program (via "redirect.cgi"). When the user submits this transaction, 
the operation is given to "atm_process_transact.cgi" and passed the user's 
account number, the type of transaction (debit) & & the amount to be withdrawn.

=head1 Modules Used

CGI.pm
HTML::Template
Class::DBI

MyTemplate.pm
Bank.pm

=head1 Author

James Edwards Mar-2014

=cut
