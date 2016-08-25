#!/usr/bin/perl
use strict;
use warnings;

use lib qw(/users/jedwards3/mylib/lib/perl5);
use CGI qw/:standard/;
#use CGI::Carp qw(fatalsToBrowser);
use Bank;

sub error_message {
  my $hmesg = shift;
  my $mesg= shift;
  print	header,
        start_html(-title=>"First Bank of O\'Reilly"),
        h1("First Bank of O\'Reilly"),
        p('Automated Teller Machine'),
	h2($hmesg),
	p($mesg),
        end_html;
  return;
}

sub display_message_with_submit {
  my $hmesg          = shift;
  my $message        = shift;
  my $pgm            = shift;
  my $account_number = shift;
  my $button_mesg    = shift;

  print	header,
  start_html(-title=>"First Bank of O\'Reilly"),
  h1("First Bank of O\'Reilly"),
  p('Automated Teller Machine'),
  h2($hmesg),
  p($message),
  start_form(-action=>$pgm),
  hidden(-name => 'account_number', -value => $account_number),
  submit(-name=>$button_mesg),
  end_form,
  end_html;
}

sub valid_integer {
  my $intgr = shift;
  return($intgr =~ m/^\d+$/);
}

sub account_on_file {
   my $acct = shift;
   my ($acc) = Bank::Account->search( account_number => $acct );
   return($acc);
}

=head1 NAME

ATMlib.pm

=head1 DESCRIPTION

Part of the "First Bank of O'Reilly" ATM web system.

This module contains a library of subroutines used in the validation of
data entered or passed to other programs.

Sub Routines
   error_message
   display_message_with_submit
   valid_integer
   account_on_file

=head1 Modules Used

CGI.pm

ATMlib.pm

=head1 Author

James Edwards Mar-2014

=cut

1;