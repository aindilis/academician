package Academician::Util;

require Exporter;
our @ISA=qw(Exporter);
our @EXPORT=qw(TurnToPage MarkPageAsRead);

use KBS2::Util;

use Data::Dumper;

# TurnToPage
# 	(
# 	 PageNo => 2,
# 	 File => "/home/andrewdo/Teregowda.pdf",
# 	);

sub TurnToPage {
  my (%args) = @_;
  my $pageno;
  if (! $args{PageNo}) {
    $pageno = 0;
  } elsif ($args{PageNo} =~ /^[0-9]+$/) {
    $pageno = $args{PageNo};
  } else {
    print STDERR "not a valid page no (1) <$args{PageNo}>\n";
    return;
  }
  my $contents = "eval (academician-goto-page-of-doc ".($pageno + 1)." ".EmacsQuote(Arg => $args{File}).")";
  print $contents."\n";
  $UNIVERSAL::agent->QueryAgent
    (
     Receiver => $args{Receiver} || "Emacs-Client",
     Contents => $contents,
     Data => {
	      _DoNotLog => 1,
	     },
    );
}

sub MarkPageAsRead {
  my (%args) = @_;
  my $pageno;
  if (! $args{PageNo}) {
    $pageno = 0;
  } elsif ($args{PageNo} =~ /^[0-9]+$/) {
    $pageno = $args{PageNo};
  } else {
    print STDERR "not a valid page no (2) <$args{PageNo}>\n";
    return;
  }
  my $contents = 'eval (academician-declare-page-of-document-read-skimmed-or-partly-read '.EmacsQuote(Arg => $args{File}).' '.EmacsQuote(Arg => ($pageno + 1)).')';
  print $contents."\n";
  $UNIVERSAL::agent->QueryAgent
    (
     Receiver => "Emacs-Client",
     Contents => $contents,
     Data => {
  		_DoNotLog => 1,
  	       },
    );
}

1;
