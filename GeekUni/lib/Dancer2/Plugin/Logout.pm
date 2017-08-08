package Dancer2::Plugin::Logout;
use Dancer2::Plugin;
 
register logout => sub {
   my $dsl     = shift;
   my $app     = $dsl->app;
   my $conf    = plugin_setting();
	  
   $app->destroy_session;
	    
   #  return $app->redirect( $conf->{after_logout} );
   return $app->redirect( '/' );
};

register_plugin for_versions => [ 2 ] ;

1;
