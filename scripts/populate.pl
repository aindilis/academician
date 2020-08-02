#!/usr/bin/perl -w


use BOSS::Config;
use KBS2::ImportExport::Wrapper;
use PerlLib::SwissArmyKnife;
use PerlLib::ToText;
use Text::Capitalize;

$specification = q(
	-f <document>	The filename of the document
	-t <txtfile>	Text file containing contents of document
	-o		Overwrite result
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;
# $UNIVERSAL::systemdir = "/var/lib/myfrdcsa/codebases/minor/system";



my $id = 'paper1';

my $documentname = $conf->{'-f'};
my $textfilename = $conf->{'-t'} || '';
if (! $textfilename or ! -f $textfilename) {
  my $totext = PerlLib::ToText->new();
  my $res1 = $totext->ToText(File => $documentname);
  # print Dumper({Res1 => $res1});
  if ($res1->{Success}) {
    $textfilename = WriteToTempFile
      (
       Pattern => "/tmp/academician-text-XXXX",
       Contents => $res1->{Text},
      );
  }
}
# print 'TextFileName: '.$textfilename."\n";
my $command = '/var/lib/myfrdcsa/codebases/minor/academician/scripts/process-parscit-results.pl -f '.shell_quote($documentname).' -o -t '.shell_quote($textfilename).' -p';
# print 'Command: '.$command."\n";
my $c = `$command`;
my @lines = split /\n/, $c;
shift @lines;
my $c2 = join("\n",@lines);
my $data = DeDumper($c2);
# print Dumper({Data => $data});
my $h = $data->{'algorithm'}{'ParsHed'}{'variant'};
# print Dumper({H => $h});
my $ref = ref($h);
# print 'Ref: '.$ref."\n";

my $title = getValue($h,'title');
push @items, ['hasTitle',$id, $title] if $title;
my $author = getValue($h,'author');
push @items, ['hasAuthor',$id,Prologify($author)] if $author;
push @items, ['hasNL',Prologify($author),$author] if $author;
my $email = getValue($h,'email');
push @items, ['hasEmail',Prologify($author),['emailFn',$email]] if ($author and $email);
my $affiliation = getValue($h,'affiliation');
push @items, ['hasAffiliation',Prologify($author),Prologify($affiliation)] if ($author and $affiliation);
push @items, ['hasNL',Prologify($affiliation),$affiliation] if $affiliation;
my $address = getValue($h,'address');
push @items, ['hasAddress',$affiliation, ['addressFn',$address]] if ($affiliation and $address);

unshift @items, 'and';
print QuoteProlog([\@items]);

sub Prologify {
  my ($item) = @_;
  my @tokens = split / /, $item;
  my $head = lc(shift @tokens);
  $head =~ s/[^a-zA-Z0-9]+/_/sg;
  my @new;
  push @new, $head;
  foreach my $token (map {capitalize($_)} @tokens) {
    $token =~ s/[^a-zA-Z0-9]+/_/sg;
    push @new, $token;
  }
  my $prolog = join('',@new);
  # check that the term doesn't already exist in the KB

  # my $res1 = FormalogQuery(['_prolog_list',Var('?Results')],['allTermAssertions',$prolog,Var('?Results')]);
  # print Dumper($res1);
}

sub getValue {
  my ($hash,$key) = @_;
  if (exists $hash->{$key}) {
    my $ref = ref($hash->{$key});
    if ($ref eq 'HASH') {
      return $hash->{$key}{content};
    } elsif ($ref eq 'ARRAY') {
      my $confidence = -1;
      my $content = undef;
      foreach my $entry (@{$h->{$key}}) {
	if ($entry->{confidence} > $confidence) {
	  $confidence = $entry->{confidence};
	  $content = $entry->{content};
	}
      }
      return $content;
    }
  }
}

