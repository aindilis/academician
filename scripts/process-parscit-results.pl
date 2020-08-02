#!/usr/bin/env perl

use BOSS::Config;
use KBS2::Util;
use PerlLib::SwissArmyKnife;
use Sayer;

use Rival::File::Fingerprint;
use XML::Simple;

$specification = q(
	-f <document>	The filename of the document
	-t <txtfile>	Text file containing contents of document
	-o		Overwrite result

	-e		Output Emacs (on by default)
	-p		Output Perl
	-x		Output XML
);

my $sayer =
  Sayer->new
  (
   DBName => "sayer_academician",
  );
$sayer->Debug(0);
$sayer->Quiet(1);

my $config =
  BOSS::Config->new
  (Spec => $specification);
$UNIVERSAL::conf = $config->CLIConfig;
# $UNIVERSAL::systemdir = "/var/lib/myfrdcsa/codebases/minor/system";

# get the fingerprint, see if it's in the database
my $file = $UNIVERSAL::conf->{'-f'};
if (-f $file) {
  my $fingerprintobj = Rival::File::Fingerprint->roll( $file );
  my $fingerprint =
    [
     md5 => $fingerprintobj->md5,
     mmagic => $fingerprintobj->mmagic,
     # basename => $fingerprintobj->basename,
     # extension => $fingerprintobj->extension,
     size => $fingerprintobj->size,
     # lines => $fingerprintobj->lines,
     crc16 => $fingerprintobj->crc16,
     crc32 => $fingerprintobj->crc32,
    ];
  # print Dumper(Dumper([{Fingerprint => $fingerprint}]));
  # this means we have this file stored, so retrieve it and print the contents
  my @res1 =  $sayer->ExecuteCodeOnData
    (
     CodeRef => sub {return RunParsCit();},
     Overwrite => $UNIVERSAL::conf->{'-o'},
     Data => [{
	       Fingerprint => $fingerprint,
	      }],
    );
  print $res1[0];
} else {
  # we have an error condition here
  
}

sub RunParsCit {
  my $txtfile = $UNIVERSAL::conf->{'-t'};
  die unless -e $txtfile;
  my ($fh,$filename) = tempfile();
  print $fh read_file($txtfile);
  my $command = "/var/lib/myfrdcsa/sandbox/parscit-110505/parscit-110505/bin/citeExtract.pl -m extract_all ".
    shell_quote($filename);
  # print $command."\n";
  my $xmlcontents = `$command 2> /dev/null`;
  $fh->close();
  my $ref = XMLin($xmlcontents);
  if (0) {
    my $citations = $ref->{'algorithm'}->{'ParsCit'}->{'citationList'}->{'citation'};
    my $elisp = "'(";
    foreach my $citation (@$citations) {
      if (exists $citation->{'rawString'}) {
	my $rawstring = EmacsQuote(Arg => $citation->{'rawString'});
	my $emacsstring = PerlDataStructureToStringEmacs(DataStructure => $citation);
	$elisp .= "($rawstring . $emacsstring)\n\t";
      }
    }
    $elisp .= ")\n";
    return $elisp;
  } else {
    my $res = "";
    if ($UNIVERSAL::conf->{'-x'}) {
      $res .= $xmlcontents."\n";
    }
    if ($UNIVERSAL::conf->{'-p'}) {
      $res .= Dumper($ref)."\n";
    }
    if ((not ($UNIVERSAL::conf->{'-p'} or $UNIVERSAL::conf->{'-x'})) or $UNIVERSAL::conf->{'-e'}) {
      $res .= "'".PerlDataStructureToStringEmacs(DataStructure => $ref);
    }
    return $res;
  }
}
