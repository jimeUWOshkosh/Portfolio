#!/usr/bin/env perl
use strict; use warnings; use feature 'say'; use Carp 'croak'; use English;
use Try::Tiny;
use XML::Writer;
use Net::AMQP::RabbitMQ;
use XML::LibXML;

our $VERSION = '0.01';
 
my $xml;
try {
   my $writer = XML::Writer->new(OUTPUT => 'self', DATA_MODE => 1, 
                                 DATA_INDENT => 2, );
   $writer->xmlDecl('UTF-8');
   $writer->startTag('people');
   $writer->startTag('person');
   $writer->dataElement('firstname', 'John');
   $writer->dataElement('lastname',  'Smith');
   $writer->dataElement('birthdate', '2004-05-03T00:00:00');
   $writer->endTag('person');
   $writer->endTag('people');
   $xml = $writer->end();
} catch {
   croak  "caught error: $ARG"; # Try::Tiny POD, $_ not $@
};

#say $xml;

try {
   XML::LibXML->load_xml(string => $xml);
} catch {
   croak  "caught error: $ARG"; # Try::Tiny POD, $_ not $@
};

my $server  = 'localhost';
my $queue   = 'SuperSecret';
my $parms   = { user => "guest", password => "guest" };
my $chanID  = 1;
my $message = $xml;
#say STDERR "Will try to send message $message through channel $chanID";
say STDERR "Will try to send message through channel $chanID";

my $mq;

try {
   $mq = Net::AMQP::RabbitMQ->new();
   $mq->connect($server, $parms );
   $mq->channel_open($chanID);
   $mq->queue_declare($chanID,$queue);
   $mq->publish($chanID,$queue,$message,{ exchange => "" });
} catch {
   croak  "caught error: $ARG"; # Try::Tiny POD, $_ not $@
};

say STDERR "Message $message sent to queue $queue";

$mq->disconnect;
exit 0;
__END__
