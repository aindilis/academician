#!/usr/bin/perl -w

use KBS2::ImportExport::Wrapper;
use KBS2::Util;
use PerlLib::SwissArmyKnife;

my $c = read_file('/var/lib/myfrdcsa/codebases/minor/academician/scripts/example-parscit-perl.dat');

my $data = DeDumper($c);
# print Dumper({Data => $data});

my $h = $data->{'algorithm'}{'ParsHed'}{'variant'};


my $id = 'paper1';

my $items = [['and',
	      ['hasTitle',$id,$h->{title}{content}],
	      ['hasAuthor',$id,Prologify($h->{author}{content})],
	      ['hasNL',Prologify($h->{author}{content}),$h->{author}{content}],
	      ['hasEmail',Prologify($h->{author}{content}),$h->{email}{content}],
	      ['hasAffiliation',Prologify($h->{author}{content}),Prologify($h->{affiliation}{content})],
	      ['hasNL',Prologify($h->{affiliation}{content}),$h->{affiliation}{content}],
	      ['hasAddress',Prologify($h->{affiliation}{content}),$h->{address}{content}],
	     ]];

print QuoteProlog($items);
