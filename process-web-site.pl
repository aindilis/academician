#!/usr/bin/perl -w

use PerlLib::Cacher;

use Biblio::Document::Parser::Standard;
use Biblio::Document::Parser::Utils;
use Biblio::Document::Parser::Brody;
use Biblio::Citation::Parser::Standard;
use Biblio::Citation::Parser::Citebase;
use Data::Dumper;
use File::Slurp;

my $content;
if (0) {
  my $cacher = PerlLib::Cacher->new;
  my $page = "http://www.cs.rochester.edu/~schubert/projects/world-knowledge-mining.html";
  $cacher->get($page);
  my $res = $cacher->ToText;

  print Dumper($res);
  return unless $res->{Success};
  $content = $res->{Result};
} else {
  $content = read_file("sample.txt");
}

my $parser1 = Biblio::Document::Parser::Brody->new;
my $parser2 = Biblio::Document::Parser::Standard->new;

my $citpar1 =  Biblio::Citation::Parser::Citebase->new;
my $citpar2 = Biblio::Citation::Parser::Standard->new;

my @citationstrings1 = $parser1->parse($content);
my @citationstrings2 = $parser2->parse($content);

# my @citationstrings3 = $citpar1->parse($content);
# my @citationstrings4 = $citpar2->parse($content);

print Dumper(\@citationstrings1);
print Dumper(\@citationstrings2);
# print Dumper(\@citationstrings3);
# print Dumper(\@citationstrings4);

