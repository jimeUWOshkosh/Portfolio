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
  $c->render('logind');
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
        template => 'imaged',
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
        template => 'indexd',
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
__DATA__

@@ logind.html.tt
[% 
    WRAPPER 'layouts/maind.html.tt' 
    title = mytitle
%]
<div class="jumbotron">
  <h1>Well, Hello!</h1>

  <form action="/" method="post">
    <div class="form-group has-success">

      <label class="control-label" for="NameField">Enter your name:</label>
      <input type="text" class="form-control" id="NameField" name="login_user">

      <!--
      <label class="control-label" for="BankBalanceField">Enter your bank balance:</label>
      <input type="text" class="form-control" id="BankBalanceField" placeholder="1000"  name="bank_balance">
      -->
    </div>

    <input class="btn" type="submit" value="Submit" />
  </form>

</div>
[% END %]

@@ imaged.html.tt
[% 
    WRAPPER 'layouts/maind.html.tt' 
    title = mytitle
%]
<ul class="pager">
  <li class="previous"> <a href="/">Gallery</a></li>
  <li class="next"><a href="/logout">Logout</a></li>
</ul>

<img class="media-object" src="/images/[% image_data.filename %]" width="500">

<div>
  <h3>[% image_data.real_title %]</h3>
  <p>[% image_data.real_artist %], [% image_data.year %], Price: [% image_data.price %]</p>
</div>
[% END %]

@@ indexd.html.tt
[% 
    WRAPPER 'layouts/maind.html.tt' 
    title = mytitle
%]
<ul class="media-list">

<ul class="pager">
  <li class="previous disabled">
    <a href="#">Bank balance: [% cash_reserve %]</a>
  </li>
  <li class="next">
    <a href="/logout">Logout</a>
  </li>
</ul>

[% FOREACH artwork IN artworks %]
  <li class="media">
    <a class="pull-left" href="/closeup/[% artwork.key %]">
      <img src="images/[% artwork.value.filename %]" height="150px">
    </a>
    <div>
      <h3>[% artwork.value.title %]</h3>
      <p>[% artwork.value.artist %], [% artwork.value.year %], Price: [% artwork.value.price %]
        [% IF artwork.value.own %]
          <a href="sell/[% artwork.key %]">
            <span class="label label-danger">Sell</span> </a>
        [% ELSIF artwork.value.price <= cash_reserve %]
          <a href="buy/[% artwork.key %]">
            <span class="label label-success">Buy</span> </a>
        [% ELSE %]
          <span class="label label-default">Too ritzy for me!</span>
        [% END %]
      </p>
    </div>
  </li>

[% END %]
</ul>
[% END %]

@@ layouts/maind.html.tt
<!DOCTYPE html>
<html>
  <head>
    <!-- minor adaptation (with no downloads) of http://getbootstrap.com/getting-started/#template -->
    <title>GuArt Exchange</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.0-rc1/css/bootstrap.min.css">
  </head>
  <body>
    <div class="container">

    <div class="page-header">
      <h1>
        GuArt Exchange
        [% IF index_user %]<small>[% message %]</small>
        [% END %]
      </h1>
    </div>

    [% content %]

    </div> 
    <script src="http://code.jquery.com/jquery.js"></script>
    <script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.0-rc1/js/bootstrap.min.js"></script>
  </body>
</html>
