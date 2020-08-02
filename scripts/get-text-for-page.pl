#!/usr/bin/perl -w

use BOSS::Config;
use PerlLib::SwissArmyKnife;

$specification = q(
	-p <pagenos>...		List of page numbers or ranges to fetch
	-f <filename>		Filename containing the text
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;
# $UNIVERSAL::systemdir = "/var/lib/myfrdcsa/codebases/minor/system";

if (! exists $conf->{'-p'}) {
  die "Need the -p arg for the page numbers\n";
}

my $pagenos = {};
foreach my $pagenoorrange (@{$conf->{'-p'}}) {
  if ($pagenoorrange =~ /^(\d+)\s*-\s*(\d+)$/) {
    foreach my $page ($1..$2) {
      $pagenos->{$page} = 1;
    }
  } elsif ($pagenoorrange =~ /^(\d+)$/) {
    $pagenos->{$1} = 1;
  } else {
    die "Unknown page number or range <$pagenoorrange>\n";
  }
}

if (! exists $conf->{'-f'}) {
  die "Need the -f arg for the file containing the text\n";
}

if (! -f $conf->{'-f'}) {
  die "File must exist containing the text\n";
}

my $c = read_file($conf->{'-f'});
my $pages;

my $i = 1;
foreach my $page (split //, $c) {
  $pages->{$i++} = $page;
}

my $result = {};
foreach my $pageno (keys %$pagenos) {
  $results->{$pageno} = $pages->{$pageno};
}

print Dumper($results);
