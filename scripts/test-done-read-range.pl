#!/usr/bin/perl -w

use KBS2::Client;
use KBS2::ImportExport;
use KBS2::Util;
use PerlLib::SwissArmyKnife;

my $client = KBS2::Client->new
  (
   Context => "Org::FRDCSA::Academician::Test",
  );

print DumperQuote2
  ($client->MyAgent->QueryAgent
   (
    Receiver => "KBS2",
    Data => {
	     "_DoNotLog" => 1,
	     "Command" => "query",
	     "Method" => "MySQL",
	     "Database" => "freekbs2",
	     "Context" => "Org::FRDCSA::Academician::Test",
	     "FormulaString" => "(\"done\" (\"read-range\" var-user (\"page-no\" var-page-no-1) (\"page-no\" var-page-no-2) (\"FileClassID\" var-file-class-id)))",
	     "InputType" => "Emacs String",
	     "OutputType" => "CycL String",
	     "Flags" => {
			 "OutputType" => "CycL String",
			},
	    },
   ));


