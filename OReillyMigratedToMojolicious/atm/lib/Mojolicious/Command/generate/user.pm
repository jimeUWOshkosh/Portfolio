package Mojolicious::Command::generate::user;
use Mojo::Base 'Mojolicious::Command';

has description => "Update a user's password.";
has usage => "APPLICATION generate user [USERNAME] [PASSWORD]\n";

sub run {
  my ($self, $user, $password) = @_;
  die "Missing attributes" unless ($user && $password);
  my $users = $self->app->db->resultset('Account');
  my $created = $users->update({
    account_number => $user,
    password => $self->app->bcrypt($password),
  });
  say "Created user '$user' with id ";
}

1;
