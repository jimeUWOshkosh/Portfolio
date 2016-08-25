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
my ($account) = Bank::Account->search( account_number => $account_number );

$template->param( owners => join ', ', map { $_->first_name . " " . $_->last_name } $account->owners );

$template->param( account_number => $account_number,
                    balance => $account->get( 'balance' ) );
$template->param( account_number2 => $account_number);
my @ATTRS = qw(transaction_date type amount new_balance);
my @transactions = map { my $t = $_; +{ map { $_, $t->$_ } @ATTRS } }
                       $account->transactions;
$template->param( transaction_loop => \@transactions );
print $template->html_output;
exit(0);

sub validate {
  $account_number=param('account_number');
  if (!valid_integer($account_number) {
    error_message("Data passed","Account number not an integer");
    exit(0);
  }
  if ($account = account_on_file($account_number)) {
    error_message("Data passed","Account number not on file");
    exit(0);
  }
  return;
}


=head1 NAME

atm_vewST.cgi

=head1 DESCRIPTION

Part of the "First Bank of O'Reilly" ATM web system.

Displays the account's owner information with all the transactions associated with
that account.

The ATM's menu screen passes the current user's account number to
this program (via "redirect.cgi"). 

When the user presses the "Return to Main Menu" button, this program calls "menu.cgi"
passing it the user's account number.

=head1 Modules Used

CGI.pm
HTML::Template
Class::DBI

MyTemplate.pm
Bank.pm

=head1 Author

James Edwards Mar-2014

=cut

