use utf8;
package ATM::Schema::ResultSet::Account;

=head1 NAME

ATM::Schema::ResultSet::Account

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
#use MooseX::MarkAsMethods autoclean =>1;
extends 'DBIx::Class::ResultSet';
use ATM::Schema;

sub BUILDARGS { $_[2] } # ::RS::new() expects my ($class, $rsrc, $args) = @_

#sub get_owner_list {
#    my $self           = shift;
#    return $self->a_customers->all;
#}

#sub get_transaction_list {
#    my $self           = shift;
#    return $self->trans->all;
#}

sub get_account_info {
    my $self           = shift;
    my $account_number = shift;
    return $self->search( { account_number => $account_number } )->single;
}

#sub get_transactions_info {
#    my $self           = shift;
#    my $account_number = shift;
#    my $schema = $self->result_source->schema;
#
#    my $rs = $schema->resultset('SingleTransaction')->search(
#      {
#        'account_number' => $account_number,
#      },
#      {
#        join     => { 'trans' => 'account' },
#      }
#    );
#    return $rs->all();
#}

__PACKAGE__->meta->make_immutable;

1;
