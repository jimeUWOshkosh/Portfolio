package ATM::Controller::Login;
use Mojo::Base 'Mojolicious::Controller';
use Try::Tiny;
use Readonly;

Readonly::Scalar my $SERVICE_UNAVAILABLE => 503;
Readonly::Scalar my $FORBIDDEN           => 403;

our $VERSION = qw('0.01');

# display login screen
sub login {
    my $self = shift;
    $self->render(
        template => 'login/login',
        format   => 'html',
        handler  => 'tt',
    );
    return;
}

# test session if to see if user is logged in
sub is_logged_in {
    my $self = shift;
    return 1 if $self->session('logged_in');
    $self->render(
        inline =>
          q{<h2>Forbidden</h2><p>You're not logged in. <%= link_to 'Go to login page.' => 'login_form' %>},
        status => $FORBIDDEN,
    );
    return;
}

# validate user id and password
sub user_exists {
    my ( $self, $account, $password, $text, $status ) = @_;

    # Determine if a user with 'username' exists
    my $user;
    try {
        $self->db->txn_do(
            sub {
                $user = $self->db->resultset('Account')->search( { account_number => $account } )->first;
            }
        );
    }
    catch {
        ${$text}   = "Database Issues:  $_";
        ${$status} = $SERVICE_UNAVAILABLE;
        return;
    };

    # Validate password against hash, return user object
    if ( defined $user && $self->bcrypt_validate( $password, $user->password ) ) {
        return $user;
    }
    return;
}

# Get inputed account number and password
# Validate info
#   if not valid, goto message screen
#   if valid, setup session info and send to menu screen (Main.pm)
sub on_user_login {
    my $self = shift;

    # Grab the request parameters
    my $account_number = $self->param('account_number');
    my $password       = $self->param('password');
    my $text           = 'Wrong account number/password';
    my $status         = $FORBIDDEN;
    if ( my $user = $self->user_exists( $account_number, $password, \$text, \$status ) ) {
        $self->session( logged_in      => 1 );
        $self->session( account_number => $account_number );
        $self->session( user_id        => $user->id );
        $self->redirect_to('menu');
    }
    else {
        $self->render( text => $text, status => $status );
    }
    return;
}
1;
__END__

=pod

=head1 NAME

ATM::Controller::Login

=head1 DESCRIPTION

Part of the "First Bank of O'Reilly" ATM web system.

This is the login screen for the ATM system.

Upon entering the user's account number and password, validate
access to the system. 

If the user information is not correct the user is given the option to return
to the login screen.

If validation is successful the user will be displayed the ATM menu system.

=head1 Modules Used

Main.pm: Menu screen

=head1 Author

James Edwards Mar-2015

=cut

