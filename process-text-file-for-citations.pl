#!/usr/bin/perl -w

use BOSS::Config;
use PerlLib::SwissArmyKnife;

use Biblio::Document::Parser::Standard;
use Biblio::Document::Parser::Utils;
use Biblio::Document::Parser::Brody;
use Biblio::Citation::Parser::Standard;
use Biblio::Citation::Parser::Citebase;

$specification = q(
	-t <txtfile>	The textfile to extract citations from
	-p <parser>	The parser to use Brody, Custom or Standard
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;

my $parserchoice = $conf->{'-p'} || "Standard";;
my $documentparser;
if ($parserchoice eq "Brody") {
  $documentparser =  Biblio::Document::Parser::Brody->new();
} elsif ($parserchoice eq "Custom") {
  $documentparser = Cite::Parser->new();
} else {
  $documentparser = Biblio::Document::Parser::Standard->new();
}
my $citationparser = Biblio::Citation::Parser::Standard->new();

if (-f $conf->{'-t'}) {
  my $content = Biblio::Document::Parser::Utils::get_content($conf->{'-t'});
  my @citationstrings = $documentparser->parse($content);
  print Dumper(\@citationstrings);
}
