#!/usr/bin/perl -w
use strict;

use lib qw(/users/jedwards3/mylib/lib/perl5);
use CGI qw/:standard/;
use CGI::Carp qw(fatalsToBrowser);
use Bank;
use ATMlib;

my ($account_number, $account_number2,$amount,$password,$acc);
my $fname1         =param('fname1');
my $lname1         =param('lname1');
my $fname2         =param('fname2');
my $lname2         =param('lname2');
my $hmesg='Transaction Status';

validate();


my $encrypted_pswd = crypt $password, "ab";
my $account = Bank::Account->create({ account_number => $account_number, balance => 0,
	                              password       => $encrypted_pswd               });

if ($account_number2 eq "") {
  # not link to another account
  my $per = Bank::Person->create({ first_name => $fname1, last_name => $lname1});
  Bank::Customer->create({ account =>$account->id, person => $per->id });
  if (defined($fname2)) {
    $per = Bank::Person->create({ first_name => $fname2, last_name => $lname2});
    Bank::Customer->create({ account => $account->id, person => $per->id});
  }
}
else {
  # Linked to another account. get account->id
  my @owners = $acc->owners;
  if ((scalar(@owners)) > 1 ) {
    foreach my $owner (@owners) {
      Bank::Customer->create({account => $account->id,person => $owner->id});
    }
  }
  else {
    Bank::Customer->create({account => $account->id, person => $owners[0]{id}});
  }
}

$account->add_transaction( "debit", $amount );

print	header,
        start_html(-title=>"First Bank of O\'Reilly"),
        h1("First Bank of O\'Reilly"),
        p('Automated Teller Machine'),
	h2('Transaction Status'),
	p('Transaction was successful'),
        end_html;
exit(0);

sub validate {
  $account_number =param('account_number');
  if (!valid_integer($account_number)) {
    error_message("Data passed","Account number not an integer");
    exit(0);
  }
  if ($account = account_on_file($account_number)) {
    error_message("Data passed","New account number not on file");
    exit(0);
  }

  $account_number2=param('account_number2');
  if ($account_number2 ne "") {
    if (!valid_integer($account_number2)) {
      error_message("Data passed","Link to Account number not an integer");
      exit(0);
    }
    if (($acc = account_on_file($account_number2))) {
      error_message("Data passed","Account number to link to not on file");
      exit(0);
    }
  }
  else {
    if ($fname1 eq "") or ($lname1 eq "") {
      error_message($hmesg,"Need at least one owner");
      exit(0);
    }
  }

  $amount=param('amount');
  if (!valid_integer($account_number)) {
    error_message("Data passed","Amount not an integer");
    exit(0);
  }

  $password       =param('password');
  if ($password eq "") {
    error_message($hmesg,"You need a password");
    exit(0);
  }
  return;
}


=head1 NAME

atm_process_newacct.cgi

=head1 SYNOPSIS

Part of the "First Bank of O\'Reilly" ATM web system.

This is the backend program to create a new bank account in the RDBMS.
It was called by the "create new account" front end program (atm_newacct.cgi).

The following data is passed to this program
   New account number
   Deposit dollar amount
   Password for new account uncypted

   If the new bank account is associated with an existing account that data is given

   If the new bank account is not associated with an existing account the owner(s) 
   first and last names will be provided.


=head1 Modules Used

CGI.pm

Bank.pm (Class::DBI)

=head1 Author

James Edwards Feb-2014

=cut
		                   
