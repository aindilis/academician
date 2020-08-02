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
    Query => '(+ 1 2)',
    InputType => 'KIF String',
   ));

print Dumper
  ($client->Send
   (
    Command => 'query-cyclike',
    Query => '(+ 1 2)',
    InputType => 'KIF String',
   ));
