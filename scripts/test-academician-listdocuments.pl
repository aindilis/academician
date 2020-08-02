#!/usr/bin/perl -w

use PerlLib::Util;
use UniLang::Util::TempAgent;

use Data::Dumper;

my $tempagent = UniLang::Util::TempAgent->new;

# my $message1 = $tempagent->MyAgent->QueryAgent
#   (
#    Receiver => "Academician",
#    Contents => 'PageReport',
#    Data => {
# 	    _DoNotLog => 1,
# 	   },
#   );
# print Dumper($message1);

my $message2 = $tempagent->MyAgent->QueryAgent
  (
   Receiver => "Academician",
   Contents => 'FirstUnreadPage',
   Data => {
	    _DoNotLog => 1,
	   },
  );
print Dumper($message2);

