package Art::Controller::Main;
use Mojo::Base 'Mojolicious::Controller';

sub login {
  my $self = shift;
  my $Mojo_Path = $self->req->url->path;
  my $path = $Mojo_Path->{path}; #$c->app->log->debug("$path");
  my $suffix_url = substr $path, 6;
  $self->app->log->debug($suffix_url);

  $self->session(user => '');
  $self->session(refresh_prices => 1);
  $self->session(data => $self->gallery);
  if ($suffix_url ne '/') {
    $self->session(on_my_way_to => $suffix_url);
  }
  $self->render;
}

#sub login {
#  my $self = shift;
#  $self->session(user => '');
#  $self->session(refresh_prices => 1);
#  $self->session(data => $self->gallery);
#  $self->render;
#}

sub logout {
#  my $self = shift;

#  # destory session
#  $self->session(expires => 1);
#  return $self->redirect_to('/');

#  $self->my_helpers->logout();
  shift->my_helpers->logout();
}

sub image {
  my $self = shift;

  unless ($self->session('user')) {
    # We need to log in
    return $self->redirect_to('login')
  }

  my $data = $self->session('data');
  my $image_id = $self->param('image_id') || 1;
  $self->stash(message => generate_message($self));
  $self->render(
        index_user => $self->session('user'),
        image_data => $data->{$image_id},
        message  => $self->stash('message')
       );

}

sub index {
  my $self = shift;

  if ($self->param('login_user')) {
    # we're logging in
    $self->session(user => $self->param('login_user'));
    $self->session('cash_reserve' => 1_000);
  }

  unless ($self->session('user')) {
    # We need to log in
    return $self->redirect_to('login')
  }

  if (defined $self->param('login_user')) {
    $self->stash( message => 'Hello ' . $self->session('user') . '. A gin and tonic for you?');
  }
  else {
    $self->stash(message => generate_message($self));
  }

  if ($self->session('on_my_way_to')) {
    # let's not get stuck there
    my $goto = $self->session('on_my_way_to');
    delete $self->session->{on_my_way_to};

    return $self->redirect_to($goto)
  }


  $self->render(
	artworks     => $self->session('data'),
	index_user   => $self->session('user'),
        message      => $self->stash('message'),
        cash_reserve => $self->session('cash_reserve'),
            );
#  $self->render( 
#	images => \@filenames,
#	index_user => $name,
#        template => 'main/index', format => 'html', handler => 'tt',);
}

sub buy {
  my $self = shift;
  unless ($self->session('user')) {
    # We need to log in
    $self->redirect_to('/login');
  }

  $self->session->{cash_reserve} = $self->session('cash_reserve') -
         $self->session->{data}->{$self->param('idx')}->{price};
  $self->session->{'data'}->{$self->param('idx')}->{own} = 1;
  $self->session(refresh_prices => 1);
  $self->redirect_to('/');

}

sub sell {
  my $self = shift;
  unless ($self->session('user')) {
    # We need to log in
    $self->redirect_to('/login');
  }
#  session 'cash_reserve' => session('cash_reserve') + 
#                            session('data')->{param('idx')}->{price};
#  $c->session('data')->{$c->param('idx')}->{own} = 0;
#  my $idx = $self->param('idx') || 1;
#  $self->session->{'data'}->{$idx}->{own} = 0;
  $self->session->{cash_reserve} = $self->session('cash_reserve') +
         $self->session->{data}->{$self->param('idx')}->{price};
  $self->session->{'data'}->{$self->param('idx')}->{own} = 0;
  $self->session(refresh_prices => 1);

  $self->redirect_to('/');
}

sub generate_message {
   my $c = shift;
   my $user = $c->session('user');
   return "$user darling, we simply must have it all!";
}

1;
