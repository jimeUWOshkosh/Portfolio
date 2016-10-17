#!/usr/bin/env perl
use strict; use warnings; use feature 'say'; use English; use Carp 'croak';
use Try::Tiny;
use Net::AMQP::RabbitMQ;
use XML::LibXML;

our $VERSION = '0.01';

my $server = 'localhost';
my $parms  = { user => "guest", password => "guest" };
my $queue  = 'SuperSecret';
my $chanID = 1;

# Note: Use xmlgrid.net to create XSD from XML
my $mq;
try {
   $mq = Net::AMQP::RabbitMQ->new();
   $mq->connect($server, $parms );
   $mq->channel_open($chanID);
   $mq->queue_declare($chanID,$queue);
   my $schema = XML::LibXML::Schema->new( location => 'peoplev2.xsd' );

   # they say get is non-blocking vs recv which is blocking. 
   while (defined(my $message = $mq->get($chanID,$queue))) {
      say STDERR "Received from queue $queue: ", $message->{body};
      my $parser = XML::LibXML->new;
      my $dom = XML::LibXML->load_xml( string => $message->{body} );
      $schema->validate( $dom );
   }
} catch {
   croak  "caught error: $ARG"; # Try::Tiny POD, $_ not $@
};

say STDERR 'No more messages in queue';
$mq->disconnect;
exit 0;
__END__
