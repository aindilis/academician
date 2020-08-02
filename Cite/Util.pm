package Cite::Util;

use strict;
use Exporter;
use Carp;
use Lingua::Stem::AutoLoader;
use vars qw (@ISA @EXPORT_OK @EXPORT $VERSION);

my $prompt = "> ";

BEGIN {
    $VERSION     = '0.1';
    @ISA         = qw (Exporter);
    @EXPORT      = qw (Approve ApproveCommand Message Query YesNoQuery Choose Debug);
    @EXPORT_OK   = qw (Approve ApproveCommand Message Query YesNoQuery Choose Debug);
}

sub Approve {
  my ($message) = (shift);
  print "<<<$message>>>\n";
  my $response = <STDIN>;
  if ($response =~ /y/i) {
    return 1;
  }
}

sub ApproveCommand {
  my ($command) = (shift);
  if (Approve("Execute this command? <<<$command>>>")) {
    system $command;
  }
}

sub Message {
  my ($message) = (shift);
  $message =~ s/[\n\s]+$//;
  print "$message\n";
}

sub Query {
  my ($query) = (shift);
  Message($query);
  print $prompt;
  my $ans = <STDIN>;
  chomp $ans;
  print "($ans)\n";
  return $ans;
}

sub YesNoQuery {
  my ($query) = (shift);
  my $ans;
  while (($ans = Query($query)) && ($ans !~ /^([yn]|yes|no)$/i)) { }
  return $ans =~ /y(es)?/i;
}

sub Choose {
  my (@options) = (@_);
  if (scalar @options > 1) {
    my $i = 0;
    foreach my $option (@options) {
      chomp $option;
      print "$i) $option\n";
      $i = $i + 1;
    }
    print $prompt;
    my $ans = <STDIN>;
    chomp $ans;
    print "($ans)\n";
    return $ans;
  } elsif (scalar @options == 1) {
    return $options[0];
  } else {
    return;
  }
}

sub Debug {
  my $message = shift;
  if ($UNIVERSAL::debug) {
    Message($message);
  }
}

1;
