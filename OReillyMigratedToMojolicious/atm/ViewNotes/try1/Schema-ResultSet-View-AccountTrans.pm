package ATM::Schema::ResultSet::View::AccountTrans;
use strict;
use warnings;
use parent 'DBIx::Class::ResultSet';

sub get_account_transactions {
    my ( $self, $account_number ) = @_;
    return $self->search( {}, { bind => [ $account_number ] } );
}

1;
