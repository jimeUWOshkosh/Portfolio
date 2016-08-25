#!/usr/bin/env perl
use Mojolicious::Lite;
use lib 'lib';

plugin 'tt_renderer';
plugin 'Mojolicious::Plugin::Logout';

use GuArt::Model;

#app->secrets('no-secret-warnings off');
#app->secrets(['Mojolicious rocks']);

get '/logi(n.*)' => sub {
#get qr!/login! => sub {
  my $c = shift;
  my $Mojo_Path = $c->req->url->path;
  my $path = $Mojo_Path->{path}; #$c->app->log->debug("$path");
  my $suffix_url = substr $path, 6;
  $c->app->log->debug($suffix_url);
  
  $c->session(user => '');
  $c->session(refresh_prices => 1);
  $c->session(data => GuArt::Model::get_data);
  if ($suffix_url ne '/') {
    $c->session(on_my_way_to => $suffix_url);
  }
  $c->render('login');
};

#get '/login' => sub {
#  my $c = shift;
#  $c->session(user => '');
#  $c->session(refresh_prices => 1);
#  $c->session(data => GuArt::Model::get_data);
#  $c->render('logind');
#};

# found the plugin notes in Mojolicious v5.77 Guides::Cookbook
get '/logout' => sub { my $c = shift; $c->my_helpers->logout(); };

get '/closeup/:image_id' => sub {
  my $c = shift;

  unless ($c->session('user')) {
    # We need to log in
    return $c->redirect_to('/login')
  }

  my $data = $c->session('data');
  my $image_id = $c->param('image_id') || 1;
  $c->stash(message => generate_message($c));
  $c->render(
        index_user => $c->session('user'),
        image_data => $data->{$image_id},
        message  => $c->stash('message'),
        template => 'image',
       );
};

get '/buy/:idx' => sub {
  my $c = shift;
  unless ($c->session('user')) {
    # We need to log in
    $c->redirect_to('/login');
  }
#  session 'cash_reserve' => session('cash_reserve') - 
#                            session('data')->{param('idx')}->{price};
  $c->session->{cash_reserve} = $c->session('cash_reserve') - 
         $c->session->{data}->{$c->param('idx')}->{price};
  $c->session->{'data'}->{$c->param('idx')}->{own} = 1;
  $c->session(refresh_prices => 1);
  $c->redirect_to('/');
};

get '/sell/:idx' => sub {
  my $c = shift;
  unless ($c->session('user')) {
    # We need to log in
    $c->redirect_to('/login');
  }
#  session 'cash_reserve' => session('cash_reserve') + 
#                            session('data')->{param('idx')}->{price};
  $c->session->{cash_reserve} = $c->session('cash_reserve') + 
         $c->session->{data}->{$c->param('idx')}->{price};
  $c->session->{'data'}->{$c->param('idx')}->{own} = 0;
  $c->session(refresh_prices => 1);
  $c->redirect_to('/');
};


any ['get', 'post'] => '/' => sub {
  my $c = shift;

  if ($c->param('login_user')) {
    # we're logging in
    $c->session(user => $c->param('login_user'));
    $c->session('cash_reserve' => 1_000);
  }

  unless ($c->session('user')) {
    # We need to log in
    return $c->redirect_to('login')
  }

  if (defined $c->param('login_user')) {
    $c->stash( message => 'Hello ' . $c->session('user') . '. A gin and tonic for you?');
  }
  else {
    $c->stash(message => generate_message($c));
  }

  if ($c->session('on_my_way_to')) {
    # let's not get stuck there
    my $goto = $c->session('on_my_way_to');
    delete $c->session->{on_my_way_to};

    # see 'forward method' in perldoc Dancer2::Manual
#    return forward $goto, { }, { method => 'GET' };
    return $c->redirect_to($goto)
  }


  $c->render(
        artworks => $c->session('data'),
        index_user => $c->session('user'),
        message  => $c->stash('message'),
        cash_reserve => $c->session('cash_reserve'),
        template => 'index',
       );

};

app->hook(before_routes => sub {
    my $c = shift;
#    $c->app->log->debug('before_routes hook');

    # Mojo::Path
    my $Mojo_Path = $c->req->url->path;
    my $path = $Mojo_Path->{path}; #$c->app->log->debug("$path");

#    my $user = $c->session('user'); $c->app->log->debug("$user");
#    my $login_user = $c->param('login_user'); $c->app->log->debug("$login_user");

    unless ($c->session('user') || $c->param('login_user') ||
           $path =~ m{/login}    ||
           $path eq '/favicon.ico') {
      # We need to log in
      if ($path ne '/login/') {
        return $c->redirect_to("/login". $path);
      }
    }

    my $flg = $c->session('refresh_prices') // 0;
    if ($flg eq 1) {
#      $c->app->log->debug('get prices');
      GuArt::Model::update_prices($c->session('data'));
      $c->session(refresh_prices => 0);
    }
  }
);

sub generate_message {
   my $c = shift;
   my $user = $c->session('user');
   return "$user darling, we simply must have it all!";
}

app->start;
