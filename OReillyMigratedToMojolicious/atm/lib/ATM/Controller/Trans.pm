package ATM::Controller::Trans;

use Mojo::Base 'Mojolicious::Controller';
use Try::Tiny;
use lib 'lib';
use ATM::Model::Bank;
use ATM::Model::Library;

our $VERSION = qw('0.01');

sub transCR {
    my $self = shift;
    $self->render(
        message  => 'Enter the amount you wish to withdraw',
        template => 'trans/transCR',
        format   => 'html',
        handler  => 'tt',
    );
    return;
}

sub transDB {
    my $self = shift;
    $self->render(
        message  => 'Enter the amount you wish to deposit',
        template => 'trans/transDB',
        format   => 'html',
        handler  => 'tt',
    );
    return;
}

sub viewST {
    my $self = shift;

    # get list of owner(s), and their names
    #   get Account id asscociated with Account Number
    my $account_model = $self->db->resultset('Account');
    my $account       = $account_model->get_account_info( $self->session('account_number') );
    my $owners_str    = get_owners_names($account);

    my @transactions = get_transaction_list_for_html( $self->db, $account );

    $self->render(
        account_number => $account->account_number,
        owners         => $owners_str,
        balance        => $account->balance,
        transactions   => \@transactions,
        template       => 'trans/viewST',
        format         => 'html',
        handler        => 'tt',
    );
    return;
}

sub transfer {
    my $self = shift;

    # get list of owner(s)
    #   get Account id asscociated with Account Number
    my $account_model = $self->db->resultset('Account');
    my $account       = $account_model->get_account_info( $self->session('account_number') );

    #   You have the Account id. find all customer associated with this account.
    #   Gather all the Person ids
    my $ra_owners = get_owners_person_objs($account);

    # Find all accounts associated with this owners
    # You Person ids of each owner, query the Customer table
    my $ra_dest_accs = accounts_to_transfer_to( $self->db, $ra_owners, $account );

    if ( scalar @{$ra_dest_accs} ) {

        # you have a list of customer objs, put the values in order according to the html layout
        my $ra_acc_2display = get_customer_list_for_html( $self->db, $ra_dest_accs );
        $self->render(
            list     => $ra_acc_2display,
            size     => scalar @{$ra_acc_2display},
            template => 'trans/transfer',
            format   => 'html',
            handler  => 'tt',
        );
    }
    else {
        # error screen
        $self->render(
            message  => 'No Accounts to transfer to',
            template => 'trans/process',
            format   => 'html',
            handler  => 'tt',
        );
    }
    return;
}

sub process {
    my $self = shift;
    my $err  = 0;

    my $amount = $self->param('amount');

    #    $err = 1 unless ( defined $amount );
    #    $err = 1 unless ( valid_integer($amount) );
    $err = 1 unless ( ( defined $self->param('amount') ) && valid_integer( $self->param('amount') ) );
    if ($err) {
        $self->render(
            message  => 'Amount not an integer',
            template => 'trans/process',
            format   => 'html',
            handler  => 'tt',
        );
        return;
    }

    if ( $self->param('type') eq 'transfer' ) {

        # was a transfer to acount chosen
        my $to_account = $self->param('listname');
        unless ( defined $to_account ) {
            $self->render(
                message  => 'No To Account Chosen',
                template => 'trans/process',
                format   => 'html',
                handler  => 'tt',
            );
            return;
        }

        if (
            add_transaction(
                $self, $self->session('account_number'),
                'credit', $self->param('amount'),
            )
          )
        {
            $err = 1
              unless (
                add_transaction( 
					$self, $to_account, 
					'debit', $self->param('amount'), ) );
        }
        else {
            $err = 1;
        }
    }
    else {
        $err = 1
          unless (
            add_transaction( 
				$self, $self->session('account_number'),
                $self->param('type'), $self->param('amount'),
            )
          );
    }
    if ($err) {
        $self->render(
            message  => 'Transaction failed',
            template => 'trans/process',
            format   => 'html',
            handler  => 'tt',
        );
    }
    else {
        $self->render(
            message  => 'Transaction was successful',
            template => 'trans/process',
            format   => 'html',
            handler  => 'tt',
        );
    }

    return;
}

sub valid_integer {
    my $intgr = shift;
    return ( $intgr =~ m/\A\d+\z/smx );
}
1;
__END__


=head1 NAME

ATM::Controller::Trans

=head1 DESCRIPTION

Part of the "First Bank of O'Reilly" ATM web system.

Called by ATM's withdrawl and deposit processes

1)  Display Withdrawl from Account Screen (transCR)
2)  Display Deposit to Account Screen (transDB)
3)  Display View Statement Screen (viewST)
4)  Display Transfer to Another Account Screen (transfer)

Upon pressing the Submit button, the subroutine "process" preforms the 
needed setup for bank transaction. The RDBMS transaction is completed
by ATM::Model::Bank::add_transactions.

The user can press the "Return to Main Menu" button, instead of doing
a banking transaction.

The view statement (viewST) and transfer (transfer) processes call
html formating functions in ATM::Model::Library modules.

=head1 Methods

    transCR
    transDB
    viewST
    transfer
    process

=head1 Subroutines

    valid_integer

=head1 Modules Used

ATM::Model::Bank;
ATM::Model::Library;

=head1 Author

James Edwards Mar-2015

=cut


