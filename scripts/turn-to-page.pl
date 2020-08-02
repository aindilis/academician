#!/usr/bin/perl -w

use UniLang::Agent::Agent;
use UniLang::Util::Message;
use KBS2::Util;

use Data::Dumper;

$UNIVERSAL::agent = UniLang::Agent::Agent->new
  (
   Name => "CLEAR",
   ReceiveHandler => \&Receive,
  );

sub Receive {
  my %args = @_;
  $command = $args{Message}->Contents;
  print Dumper($command);
}

sub TurnToPage {
  my (%args) = @_;
  if ($args{PageNo} =~ /^[0-9]+$/) {
    my $contents = "eval (academician-goto-page-of-doc ".$args{PageNo}." ".EmacsQuote(Arg => $args{File}).")";
    print $contents."\n";
    $UNIVERSAL::agent->QueryAgent
      (
       Receiver => "Emacs-Client",
       Contents => $contents,
       Data => {
		_DoNotLog => 1,
	       },
      );
  } else {
    print STDERR "not a valid page no $args{PageNo}\n";
  }
}

$UNIVERSAL::agent->DoNotDaemonize(1);
$UNIVERSAL::agent->Register
  (Host => "localhost",
   Port => "9000");

my $i = 0;
my $done;
while (1) {
  $UNIVERSAL::agent->Listen(TimeOut => 0.05);
  ++$i;
  if ($i > 10000) {
    if (! $done) {
      TurnToPage
	(
	 PageNo => 2,
	 File => "<REDACTED>",
	);
      $done = 1;
    }
  }
}
