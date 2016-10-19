package Mojolicious::Command::setpassword;
use Mojo::Base 'Mojolicious::Command';

has description => "Update a Customer's password.";
has usage => "APPLICATION [ACCCOUNT NUMBER] [PASSWORD]\n";

sub run {
  my ($self, $user, $password) = @_;
  die "Missing attributes" unless ($user && $password);
  my $account = $self->app->db->resultset('Account')
                  ->search( { account_number => $user } )->first;
  $account->update({
    account_number => $user,
    password => $self->app->bcrypt($password),
  });
  say "Updated user ${user}'s password";
}

1;
