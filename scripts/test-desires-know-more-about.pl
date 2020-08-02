#!/usr/bin/perl -w

use KBS2::Client;
use KBS2::ImportExport;
use PerlLib::SwissArmyKnife;

my $client = KBS2::Client->new
  (
   Context => "Org::FRDCSA::Academician",
  );

print Dumper
  ($client->Send
   (
    Command => 'query-cyclike',
    Query => '("desires" var-PERSON ("know-more-about" var-PERSON var-TOPIC))',
    InputType => 'Emacs String',
   ));
