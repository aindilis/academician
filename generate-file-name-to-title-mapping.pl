#!/usr/bin/perl -w

use KBS2::Util;
use PerlLib::SwissArmyKnife;
use Sayer;

use File::Fingerprint;

my $sayer =
  Sayer->new
  (
   DBName => "sayer_academician",
  );
# $sayer->Debug(1);
$sayer->Quiet(1);


# get the fingerprint, see if it's in the database

my @data;
foreach my $file (split /\n/, `find /var/lib/myfrdcsa/codebases/internal/digilib/data/collections/academician-papers | grep -iE '\\\.(ps|pdf)\$'`) {
  # print "<$file>\n";
  my $res = ProcessFile(File => $file);
  if ($res->{Success}) {
    my $elispdata = $res->{Result}->[0];
    push @data, "(cons ".EmacsQuote($file)." ".$elispdata.")";
  }
}
print "'(".join("\n",@data).")\n";

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
  return $sayer->ExecuteCodeOnData
    (
     GiveHasResult => 1,
     CodeRef => sub {return RunParsCit();},
     Data => [{
	       Fingerprint => $fingerprint,
	      }],
    );
}

sub RunParsCit {

}
