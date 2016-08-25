package Bank;
use strict;
use warnings;

use lib qw(/users/jedwards3/mylib/lib/perl5);
use base 'Class::DBI';
use Email::Stuff;
use Sys::Hostname;
use Cwd;

my ($USER) = (cwd() =~ m!/.*?/(.*?)/!);
my $PASSWORD = 'Perl2014';   # XXX change to your password
my $SERVER   = 'sql';

__PACKAGE__->connection( "dbi:mysql:database=$USER;host=$SERVER", $USER, $PASSWORD );

package Bank::Account;

use base 'Bank';

__PACKAGE__->table( 'account' );
__PACKAGE__->columns( All => qw(id account_number password balance) );
__PACKAGE__->has_many( owners => [ 'Bank::Customer' => 'person' ] );
__PACKAGE__->has_many( transactions => [ 'Bank::Transactions' => 'single_transaction' ] );
__PACKAGE__->autoupdate( 1 );

sub add_transaction {
  my $self = shift;
  my $type = shift;
  my $amount = shift;
  my $balance = $self->get( 'balance' );
  my ($trans_type) = Bank::Transaction::Type->search( name => $type );
  my $new_balance = $balance + ($type eq 'debit' ? 1 : -1) * $amount;
  my $single_trans = Bank::Transaction::Single->insert( { amount => $amount,
                                     transaction_type => $trans_type,
                                     previous_balance => $balance,
                                     new_balance => $new_balance,
                                     } );
  Bank::Transactions->insert( { single_transaction => $single_trans,
                                account => $self } );
  $self->set( balance => $new_balance );
  if ($new_balance < 0) {
    my $acc = $self->account_number;
    my $report = "$acc has a balance of $new_balance\n";
    my $to = "mr_osh_vegas\@yahoo.com";
    my $from    = "DickCheney\@whitehouse.gov";
    my $subject = 'A account has a balance less than zero';

    Email::Stuff->to( $to ) ->from( $from ) ->subject( $subject ) ->text_body( $report ) ->send;
  }
}


package Bank::Customer;

use base 'Bank';

__PACKAGE__->table( 'customer' );
__PACKAGE__->columns( Primary => qw(account person) );
__PACKAGE__->has_a( person => 'Bank::Person' );
__PACKAGE__->has_a( account => 'Bank::Account' );


package Bank::Person;

use base 'Bank';

__PACKAGE__->table( 'person' );
__PACKAGE__->columns( All => qw(id first_name last_name) );
__PACKAGE__->has_many( accounts => [ 'Bank::Customer' => 'account' ] );


package Bank::Transactions;

use base 'Bank';

__PACKAGE__->table( 'transactions' );
__PACKAGE__->columns( Primary => qw(account single_transaction) );
__PACKAGE__->has_a( single_transaction => 'Bank::Transaction::Single' );
__PACKAGE__->has_a( account => 'Bank::Account' );


package Bank::Transaction::Single;

use base 'Bank';

__PACKAGE__->table( 'single_transaction' );
__PACKAGE__->columns( All => qw(id amount transaction_type previous_balance new_balance transaction_date) );
__PACKAGE__->has_a( transaction_type => 'Bank::Transaction::Type' );
__PACKAGE__->has_many( accounts => [ 'Bank::Transactions' => 'account' ] );

sub type
{
  return shift->get( 'transaction_type' )->name;
}

package Bank::Transaction::Type;

use base 'Bank';

__PACKAGE__->table( 'transaction_type' );
__PACKAGE__->columns( All => qw(id name) );

1;
