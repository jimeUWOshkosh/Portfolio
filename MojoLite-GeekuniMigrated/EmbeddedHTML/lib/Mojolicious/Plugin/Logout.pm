package Mojolicious::Plugin::Logout;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

sub register {
  my ($self, $app) = @_;
  $app->helper('my_helpers.logout' => sub {
    my ($c) = @_;
    $c->session(expires => 1);
    $c->redirect_to('/');
  });
}

1;
__END__

=encoding utf8

=head1 NAME

Mojolicious::Plugin::Logout - Mojolicious Plugin

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('Logout');

  # Mojolicious::Lite
  plugin 'Logout';

=head1 DESCRIPTION

L<Mojolicious::Plugin::Logout> is a L<Mojolicious> plugin.

=head1 METHODS

L<Mojolicious::Plugin::Logout> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
