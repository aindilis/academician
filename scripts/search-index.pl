#!/usr/bin/perl -w

use KBS2::Util;
use PerlLib::MySQL;
use PerlLib::SwissArmyKnife;

my $mysql = PerlLib::MySQL->new
  (
   DBName => "academician",
  );

my $res = $mysql->Do
  (
   Statement => "select * from papers",
   Array => 1,
  );

my $elisp = "'(";
foreach my $result (@$res) {
  my $title = EmacsQuote(Arg => $result->[1]);
  my $file = EmacsQuote(Arg => $result->[0]);
  $elisp .= "($title . $file)\n\t";
}
$elisp .= ")\n";
print $elisp;
