#!/usr/bin/perl -w

use KBS2::Util;
use PerlLib::MySQL;
use PerlLib::SwissArmyKnife;
use Sayer;

use File::Fingerprint;
use XML::Simple;

my $sayer =
  Sayer->new
  (
   DBName => "sayer_academician",
  );
# $sayer->Debug(1);
$sayer->Quiet(1);

my $mysql = PerlLib::MySQL->new
  (
   DBName => "academician",
  );

# $mysql->Do(Statement => "delete from papers");

# get the fingerprint, see if it's in the database

my $textfile;
my @results;
my $i = 1;
foreach my $file (split /\n/, `find /var/lib/myfrdcsa/codebases/internal/digilib/data/collections/academician-papers | grep -iE '\\\.(ps|pdf)\$'`) {
  print "<$file>\n";
  $textfile = GetTextFileForFile(File => $file);
  my $res = ProcessFile
    (
     File => $file,
    );

  if (0) {
    my $fh = IO::File->new();
    $fh->open(">/tmp/academician/$i.txt");
    print $fh Dumper($res);
    $fh->close();
    ++$i;
  }
  my $elispdata = $res->[0];

  my $title;
  if ($elispdata =~ /\("title" . \(\(\("content" . "([^"]+)"\)/) {
    $title = $1;
  } elsif ($elispdata =~ /\("title" . \(\("content" . "([^"]+)"\)/) {
    $title = $1;
  } elsif ($elispdata =~ /\("title" . "([^"]+)"\)/) {
    $title = $1;
  }
  if (! defined $title) {
    print "Title not found\n";


    # print $elispdata."\n";
    # GetSignalFromUserToProceed();
    my $title2 = $file;
    $title2 =~ s/.*\///;
    $mysql->Do
      (Statement => "insert into papers values (".$mysql->Quote($file).",".$mysql->Quote($title2).")");

  } else {
    $mysql->Do
      (Statement => "insert into papers values (".$mysql->Quote($file).",".$mysql->Quote($title).")");
  }
}

sub GetTextFileForFile {
  my %args = @_;
  print Dumper($args{File});
  my $name = $args{File}.".txt";
  if (-f $name) {
    return $name;
  } else {
    die "No file named $name\n";
  }
}

sub ProcessFile {
  my %args = @_;
  my $fingerprintobj = File::Fingerprint->roll( $args{File} );
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
  my @res = $sayer->ExecuteCodeOnData
    (
     Overwrite => 1,
     CodeRef => sub {return RunParsCit();},
     Data => [{
	       Fingerprint => $fingerprint,
	      }],
    );
  return \@res;
}

sub RunParsCit {
  my $txtfile = $textfile;
  die unless -e $txtfile;
  my ($fh,$filename) = tempfile();
  print $fh read_file($txtfile);
  my $command = "/var/lib/myfrdcsa/sandbox/parscit-110505/parscit-110505/bin/citeExtract.pl -m extract_all ".
    $filename;
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
    return "'".PerlDataStructureToStringEmacs(DataStructure => $ref);
  }
}
