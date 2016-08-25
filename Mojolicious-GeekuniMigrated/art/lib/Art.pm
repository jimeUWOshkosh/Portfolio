package Art;
use Mojo::Base 'Mojolicious';

use Art::Model::GuArt;

# This method will run once at server start
sub startup {
  my $self = shift;

  $self->plugin('tt_renderer');
  $self->plugin('Logout');
  $self->renderer->default_handler('tt');

  my $r = $self->routes;

  $r->route('/')->via(qw(GET POST))->to(controller=>'main',action=>'index');

#  $r->get('/login')->to(controller=>'main',action=>'login');
  $r->get('/logi(n.*)')->to(controller=>'main',action=>'login');
  $r->get('/logout')->to(controller=>'main',action=>'logout');
  $r->get('/closeup')->to(controller=>'main',action=>'image');
  $r->get('/closeup/:image_id')->to(controller=>'main',action=>'image');
  $r->get('/buy/:idx')->to(controller=>'main',action=>'buy');
  $r->get('/sell/:idx')->to(controller=>'main',action=>'sell');

  my $data = Art::Model::GuArt::get_data;
  $self->helper(gallery => sub { return $data; });

  $self->hook(before_routes => sub {
    my $c = shift;
#    $c->app->log->debug('before_routes hook');

    # Mojo::Path
    my $Mojo_Path = $c->req->url->path;
    my $path = $Mojo_Path->{path}; #$c->app->log->debug("$path");

    unless ($c->session('user') || $c->param('login_user') ||
           $path =~ m{/login}   ||
           $path eq '/favicon.ico') {
      # We need to log in
      if ($path ne '/login/') {
        return $c->redirect_to("/login". $path);
      }

    }

    my $flg = $c->session('refresh_prices') // 0;
    if ($flg eq 1) {
#      $c->app->log->debug('get prices');
      Art::Model::GuArt::update_prices($c->session('data'));
      $c->session(refresh_prices => 0);
    }
  }

);

}

1;
