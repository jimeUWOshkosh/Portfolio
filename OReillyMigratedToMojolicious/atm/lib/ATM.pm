package ATM;
use Mojo::Base 'Mojolicious';
use strict;
use warnings;
use lib 'lib';
use ATM::Schema;
use Try::Tiny;
use Carp 'croak';
use Mojolicious::Plugin::JSONConfig;

our $VERSION = qw('0.01');

sub startup {
    my $self = shift;

    # Allows to set the signing key as an array,
    # where the first key will be used for all new sessions
    # and the other keys are still used for validation, but not for new sessions.
    $self->secrets(
        [
            'This secret is used for new sessionsLeYTmFPhw3q',
            'This secret is used _only_ for validation QrPTZhWJmqCjyGZmguK'
        ]
    );

    # The cookie name
    $self->app->sessions->cookie_name('atm');

    # Expiration reduced to 10 Minutes
    $self->app->sessions->default_expiration('600');

    # Bcrypt with cost factor 8
    $self->plugin( 'bcrypt', { cost => 8 } );

    #  # Logout Plugin
    #  $self->plugin('Logout');

    # Template Toolkit
    $self->plugin('tt_renderer');
    $self->renderer->default_handler('tt');

    # Router
    my $r = $self->routes;

    # Login routes
    $r->get('/login')->name('atm_login')->to( controller => 'login', action => 'login' );
    $r->post('/login')->name('do_login')->to( controller => 'login', action => 'on_user_login' );

    # menu
    $r->get(q{/})->name('menu')->to( controller => 'main', action => 'menu' );
    $r->post('/menu')->name('menu')->to( controller => 'main', action => 'menu' );

    # find out what was selected and redirect them
    $r->post('chose')->to( controller => 'main', action => 'chose' );

    # Process a withdrawl
    $r->get('transCR')->to( controller => 'trans', action => 'transCR' );

    # Process a depoist
    $r->get('transDB')->to( controller => 'trans', action => 'transDB' );

    # View statement
    $r->get('viewST')->to( controller => 'trans', action => 'viewST' );

    # Transfer money between accounts
    $r->get('transfer')->to( controller => 'trans', action => 'transfer' );
    $r->post('process')->to( controller => 'trans', action => 'process' );

    my $config = $self->plugin('JSONConfig');

    my $schema;
    try {
        $schema = ATM::Schema->connect( $config->{DSN}, $config->{USER}, $config->{PASSWORD} );
    }
    catch {
        croak 'RDBMS Issue:';
    };

    # DBIX::Class::Schema helper
    $self->helper( db => sub { return $schema; } );

    # trick to get $schema to Mojolicious Models
    ( ref $self )->attr( db => sub { return $schema } );

    # Logout route
    $r->route('/logout')->name('do_logout')->to(
        cb => sub {
            my $self = shift;

            # Expire the session (deleted upon next request)
            $self->session( expires => 1 );

            # Go back to home
            $self->redirect_to(q{/});
        }
    );

    #  $self->app->log->debug("exiting Startup");
    return;
}
1;
__END__

=pod

=head1 NAME

ATM

=head1 DESCRIPTION

Part of the "First Bank of O'Reilly" ATM web system.

This module is the startup routine to Mojolicious

  Loads Plugins
     Bcrypt
     TemplateToolkit
     JSONConfig
  Defines Routes
  Connects to the RDBMS

=head1 Controllers Used

  Login: Handle Login process for user
  Menu:  Display Menu and direct selections
  Trans: Process a user's transaction

=head1 Author

James Edwards Mar-2015

=cut

