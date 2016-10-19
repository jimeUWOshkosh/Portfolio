package ATM::Model::Library;
use strict;
use warnings;
use lib 'lib';
use ATM::Schema;

our $VERSION = qw('0.01');

sub get_owners_person_objs {
    my $acc = shift;

    #   You have the Account id. find all customer associated with this account.
    #   Gather all the Person ids

    my @owners;
    foreach my $o ( $acc->a_customers ) {
        push @owners, $o->c_person;
    }

    return \@owners;
}

sub get_owners_names {
    my $acc = shift;

    # Concatenate the list of owners names
    my $ra_owners = get_owners_person_objs($acc);

    my $str = join ', ', map { $_->first_name . ' ' . $_->last_name } @$ra_owners;

    return $str;
}

sub get_transaction_list_for_html {
    my $schema  = shift;
    my $account = shift;

    # get list of transactions
    my @trans;
    foreach my $tran ( $account->trans ) {
        push @trans, $tran->single_trans;
    }

    # We need to display the verbage of the type of transaction, DBIx::Class will not
    # let us coerce an attribute. Create our own list of hashes.

    # you have a list of transaction objs, put the values in order according to the html layout
    my @ATTRS        = qw(transaction_date tid amount new_balance);
    my @transactions = map {
        my $t = $_;
        +{ map { $_ => $t->$_ } @ATTRS }
    } @trans;

    # need to change transaction id to verbage
    my @all_types = $schema->resultset('TransactionType')->search( {} )->all;

    # coerce TypeID to verbage
    foreach my $t (@transactions) {
        foreach my $type (@all_types) {
            if ( $t->{tid} == $type->tid ) {
                $t->{tid} = $type->name;
                last;
            }
        }
    }
    return @transactions;
}

sub accounts_to_transfer_to {
    my $schema    = shift;
    my $ra_owners = shift;
    my $account   = shift;

    # Find all accounts associated with this owners
    # You Person ids of each owner, query the Customer table
    my @dest_accs;
    foreach my $o (@$ra_owners) {
        my @accounts = $schema->resultset('Customer')->search( { pid => $o->pid } )->all;

        # remove source account
        my @tmp_accs = grep { $_->aid != $account->aid } @accounts;
        push @dest_accs, @tmp_accs;
    }
    return \@dest_accs;
}

sub get_customer_list_for_html {
    my $schema       = shift;
    my $ra_dest_accs = shift;

    # you have a list of customer objs, put the values in order according to the html layout
    my @acc_2display;
    for my $a (@$ra_dest_accs) {
        my $account = $schema->resultset('Account')->search( { aid => $a->aid } )->first;

        my $str = sprintf "%d Balance: \$ %d", $account->account_number, $account->balance;
        push @acc_2display, { account_number => $account->account_number, desc => $str };
    }

    return \@acc_2display;
}

1;
__END__

=pod

=head1 NAME

ATM::Model::Library

=head1 DESCRIPTION

Part of the "First Bank of O'Reilly" ATM web system.

   Subroutines
       get_owners_person_objs 
       get_owners_names 
           These subroutines should be move to a ResultSet
       get_transaction_list_for_html 
           prepares transaction list for HTML (Trans/viewST)
       accounts_to_transfer_to
           Figure out what accounts the customer can transfer to.
           This subroutine should be move to a ResultSet
       get_customer_list_for_html
           Prepare the Account To Transfer To for HTML to display
           account and current balance (Trans/Transfer).

=head1 Modules Called By

ATM::Controller::Transaction 

=head1 Author

James Edwards Mar-2015

=cut

