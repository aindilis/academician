#!/usr/bin/perl -w

# system to resolve problems with  each item, and take a set theoretic
# approach to fixing them

use Cite::Util;
use Data::Dumper;

my $file = $ARGV[0] || die "Usage: problems.pl <ENTRY>*\n";
my %properties;
my @entries = split /\n/,`cat $file`;
my @previousentries;
my @commands = qw(save ignore covered correct translate next_entry previous_entry add_problem_type remove_problem_type save_and_exit);
my @problems = qw(ignore covered);
my %sizes;
my $entry = shift @entries;
my $count = 0;
while (@entries) {
  ++$count;
  if (!($count % 20)) {
    Save();
    $count = 0;
  }
  $size{commands} = scalar @commands;
  $size{problems} = scalar @problems;
  my @menu = @commands;
  push @menu, @problems;

  my $translated = $entry;
  $translated =~ s/\s+/_/g;

  print "#" x 80;
  print "\n";
  print "<<<$entry>>>\n";
  print "<<<$translated>>>\n";
  print Dumper($properties{$entry});
  print "\n";
  my $choice = Choose(@menu);
  if ($choice >= 0) {
    if ($choice < $size{commands}) {
      my $command = $commands[$choice];
      if ($command eq "next_entry") {
	Advance();
      } elsif ($command eq "ignore") {
	$properties{$entry}->{"ignore"} = ! $properties{$entry}->{"ignore"};
	Advance();
      } elsif ($command eq "covered") {
	$properties{$entry}->{"covered"} = ! $properties{$entry}->{"covered"};
	Advance();
      } elsif ($command eq "correct") {
	$properties{$entry}->{"translate"} = $translated;
	Advance();
      } elsif ($command eq "save") {
	Save();
      } elsif ($command eq "save_and_exit") {
	Save();
	exit(0);
      } elsif ($command eq "translate") {
	print "Please enter translation:\n";
	$translated = <STDIN>;
	chomp $translated;
	$properties{$entry}->{"translate"} = $translated;
	Advance();
      } elsif ($command eq "previous_entry") {
	if (scalar @previousentries) {
	  unshift @entries,$entry;
	  $entry = pop @previousentries;
	} else {
	  print "Previous entries empty\n";
	}
      } elsif ($command eq "add_problem_type") {
	push @problems, Query("New problem type name?");
      } elsif ($command eq "remove_problem_type") {
	print "Remove which problem?\n";
	my $response = Choose(@problems);
	if ($response >= 0 and $response < scalar @problems) {
	  splice(@problems,$response,1);
	}
      }
    } elsif ($choice < $size{commands} + $size{problems}) {
      if (defined ($properties{$entry}->{$problems[$choice-$size{commands}]})) {
	delete $properties{$entry}->{$problems[$choice-$size{commands}]};
      } else {
	$properties{$entry}->{$problems[$choice-$size{commands}]} = 1;
      }
    }
  }
}

sub Save {
  my $LOG;
  open(LOG,">problems.log") or die "can't open problems.log\n";
  print LOG Dumper({%properties});
  close(LOG);
}

sub Advance {
  if (scalar @entries) {
    push @previousentries, $entry;
    $entry = shift @entries;
  } else {
    print "Entries empty\n";
  }
}
