#!/usr/bin/perl -Ilib
use warnings;
use Dancer2;
use Dancer2::Plugin::Logout;
use GuArt::Model;

our $VERSION = '0.1';

get qr{/login(.*)} => sub {
   my ($suffix_url) = splat; # whatever matches the wildcard

  session 'user'  => undef; 
  session refresh_prices => 1;
  session 'data' => GuArt::Model::get_data;
  if ($suffix_url ne '/') {
    session on_my_way_to => $suffix_url;
  }
  return template 'login';
};

#get '/login' => sub {
#   session 'user'  => "";
#   session 'refresh_prices' => 1;
#   session 'data' => GuArt::Model::get_data;
#   return template '/login';
#};

get '/logout' => sub { 
   #   session 'user'  => "";
   #   session 'refresh_prices' => 1;
   #   session 'data' => GuArt::Model::get_data;
   warning 'User '.session('user').' is logging out';
   logout;
};

get '/closeup/:image_id' => sub {
  unless (session('user')) {
    # We need to log in
    return redirect '/login';
  }
  my $data = session 'data';
  my $image_id = params->{image_id} // "";
  var message => generate_message();
  return template 'image' => { 
                      index_user => session('user'),
                      image_data => $data->{$image_id},
                      message      => var('message'),
  };
};

sub retrieve_data {
   my $retval = to_json({
      artworks      => session('data'),
      cash_reserve  => session('cash_reserve'),
      index_user    => session('user'),
      message       => generate_message(),
   }, {pretty => 1 });

    return $retval;
}

get '/retrieve-data' => sub {
   return retrieve_data();
};

get '/toggle-ownership/:idx' => sub {
   my $selling = session('data')->{param('idx')}->{own};
   session('data')->{param('idx')}->{own} = !  session('data')->{param('idx')}->{own};

   my $delta = $selling ? 1 : -1;
   session 'cash_reserve' => session('cash_reserve') +
       $delta * session('data')->{param('idx')}->{price};
   if (defined session('transactions')) {
      session 'transactions' => session('transactions') + 1;
   } else {
      session 'transactions' => 1;
   }
   GuArt::Model::update_prices(session('data'));

   return retrieve_data();
};

any ['get', 'post'] => '/' => sub {

  if (defined params->{login_user} ) {
    # we're logging in
    session 'user'  => params->{login_user};
    session 'cash_reserve' => 1_000;
  }
  unless (session('user')) {
    # We need to log in
    return redirect '/login';
  }

  if (defined params->{login_user} ) {
    var message => 'Hello ' . session('user') . '. A gin and tonic for you?';
  } 
  else {
    var message => generate_message();
  }

  if (session('on_my_way_to')) {
    # let's not get stuck there
    my $goto = session->delete('on_my_way_to');

    # see 'forward method' in perldoc Dancer2::Manual
    return forward $goto, { }, { method => 'GET' };
  }

  return template 'index' => { 
                      index_user   => session('user'),
                      artworks     => session('data'),
                      message      => var('message'),
                      cash_reserve => session('cash_reserve'),
  };
};

hook before => sub {
  debug 'request->path : '.request->path;
  unless (session('user') || params->{login_user} || 
           request->path =~ m{/login} ||
           request->path =~ m{/retrieve-data} ||
           request->path =~ m{/\.css\z} ||
           request->path eq '/favicon.ico') {
    # We need to log in
    if (request->path ne '/login/') {
      return redirect '/login'.request->path;
    }
  }
  my $flg = session('refresh_prices') // 0;
  if ($flg eq 1) {
    GuArt::Model::update_prices(session('data'));
    session 'refresh_prices' => 0;
  }
};

sub generate_message {
   # when you logout, retrieve_data calls generate_message with 
   # no session 'user'
   my $user = session('user') // 'stuff';
   if (defined session('transactions')) {
      return "Hello ${user}. A gin and tonic for you?";
   } else {
      return "$user darling, we simply must have it all!";
   }
}

dance;
true;
