package ATM::Controller::Main;
use Mojo::Base 'Mojolicious::Controller';
use Try::Tiny;

our $VERSION = qw('0.01');

sub menu {
    my $self = shift;

    # display menu to user
    if ( $self->param('login_account') ) {

        # we're logging in
        $self->session( user => $self->param('login_account') );
    }

    unless ( $self->session('account_number') ) {

        # We need to log in
        return $self->redirect_to('login');
    }

    $self->render(
        message  => 'Menu',
        template => 'main/menu',
        format   => 'html',
        handler  => 'tt'
    );
    return;
}

sub chose {
    my $self = shift;

    # find out what was selected and redirect them
    if ( !defined $self->param('select') ) {

        # you didn't choose an option
        $self->redirect_to('menu');
    }
    elsif ( $self->param('select') eq 'transCR' ) {
        $self->redirect_to('transCR');
    }
    elsif ( $self->param('select') eq 'transDB' ) {
        $self->redirect_to('transDB');
    }
    elsif ( $self->param('select') eq 'viewST' ) {
        $self->redirect_to('viewST');
    }
    elsif ( $self->param('select') eq 'transfer' ) {
        $self->redirect_to('transfer');
    }
    else {
        $self->redirect_to('menu');
    }
    return;
}
1;
__END__

=pod


=head1 NAME

ATM::Controller::Main

=head1 DESCRIPTION

Part of the "First Bank of O'Reilly" ATM web system.

This is the menu screen for the ATM system.

The user can preform the following tasks

   1. Process a credit. Take out money from their account.
   2. Process a debit. Place money into their account.
   3. View their Bank Statement
   4. Transfer money to an other account of theirs
   5. Logout

=head1 Modules Used

    Trans: Process transaction type.
    Login: When a user logs out, they are sent to the login screen.

=head1 Author

James Edwards Mar-2015

=cut

