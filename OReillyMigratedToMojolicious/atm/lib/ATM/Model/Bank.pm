package ATM::Model::Bank;
use strict;
use warnings;
use Try::Tiny;
use Readonly;

#use Email::Stuff;

our $VERSION = qw('0.01');

Readonly::Scalar my $NEGATIVE_ONE => -1;

sub add_transaction {
    my $mojo           = shift;
    my $account_number = shift;
    my $type           = shift;
    my $amount         = shift;

    my $account = $mojo->db->resultset('Account')->search( { account_number => $account_number } )->first;

    my $trans_type = $mojo->db->resultset('TransactionType')->search( { name => $type } )->first;

    my $new_balance = $account->balance + ( $type eq 'debit' ? 1 : $NEGATIVE_ONE ) * $amount;

    my ( $single_trans, $transaction );
    try {
        $single_trans = $mojo->db->resultset('SingleTransaction')->create(
            {
                amount           => $amount,
                tid              => $trans_type->tid,
                previous_balance => $account->balance,
                new_balance      => $new_balance,
            }
        );
        $account->balance($new_balance);
        $account->update;
        $transaction = $mojo->db->resultset('Transaction')->create(
            {
                sid => $single_trans->sid,
                aid => $account->aid,
            }
        );
    }
    catch {
        return 0;
    };

    #  if ($new_balance < 0) {
    #    my $report = "$account_number has a balance of $new_balance\n";
    #    my $to = "mr_osh_vegas\@yahoo.com";
    #    my $from    = "DickCheney\@whitehouse.gov";
    #    my $subject = 'A account has a balance less than zero';
    #    Email::Stuff->to( $to ) ->from( $from ) ->subject( $subject ) ->text_body( $report ) ->send;
    #  }
    return 1;
}

1;
__END__


=pod

=head1 NAME

ATM::Model::Bank

=head1 DESCRIPTION

Part of the "First Bank of O'Reilly" ATM web system.

Business Logic for creating a bank transaction.

    Insert entry into the SingleTransaction table
        Amount, TransactionType's ID, Previous Balance, New Balance
    Update the Account table
        Balance
    Insert entry into the Transaction table
        SingleTransaction's ID, Account's ID

This written for MySQL, which does not handle SQL transactions.

Since Mojolicious Models are "entirely model layer agnostic" had to 
modify Mojo Object to pass the DB handle (mojo->db in ATM.pm).

=head1 Modules Called By

ATM::Controller::Transaction 

=head1 Author

James Edwards Mar-2015

=cut

