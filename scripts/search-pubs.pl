#!/usr/bin/perl -w

use BOSS::Config;
use Manager::Dialog qw(SubsetSelect);

use Data::Dumper;
# use Rival::Yahoo::Search;
use Capability::WebSearch::API::Rival::Yahoo::Search;
use Capability::WebSearch::API::Rival::Yahoo::Search::AsList;

$specification = q(
	-l		List existing searches

	-d <depth>	Number or results to include in search
	-i		Include non-html documents
	-D		Include additional search parameters for software download
	-q		Perform query expansion

	-a <stuff>	Additional stuff for the query
	-o		Overwrite cached result

	-p		Prompt for download of systems

	-Q		Strip quotes

	--links		Do link analysis

	<search>...	Searches to be acted upon
  );

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;

my @topics = @{$conf->{'<search>'}};

if ($conf->{'-l'}) {
  foreach my $entry
    (SubsetSelect
     (Set => [split /\n/, `ls -1 /var/lib/myfrdcsa/codebases/internal/radar/data/pub-searches/`])) {
    $entry =~ s/_/ /g;
    push @topics, $entry;
  }
}

foreach my $topic (@topics) {
  Search($topic);
}

sub Search {
  my $topic = shift;
  return unless $topic;
  my $filename;
  my $file = "/var/lib/myfrdcsa/codebases/internal/radar/data/pub-searches/$topic";
  $file =~ s/\s+/_/g;
  if (-f $file and ! exists $conf->{'-o'}) {

  } else {
    # attempt refinement of the search topic

    my $additional = "";
    if (exists $conf->{'-a'}) {
      $additional .= $conf->{'-a'};
    }
    if ($conf->{'-Q'}) {
      $mytopic = $topic;
    } else {
      $mytopic = "\"$topic\"";
    }
    my $query = "$mytopic $additional $expansion $refinement";
    # http://search.yahoo.com/search?n=10&ei=UTF-8&va_vt=any&vo_vt=any&ve_vt=any&vp_vt=any&vd=all&vst=0&vf=pdf&vm=p&fl=0&fr=yfp-t-501&p="definitional+question+answering"&vs=
    print "QUERY: ".$query."\n";
    # my @Results = Rival::Yahoo::Search->Results
    my @Results = Capability::WebSearch::API::Rival::Yahoo::Search->Results
      (Doc => $query,
       AppId => "Documentation-Searcher",
       # The following args are optional.
       # (Values shown are package defaults).
       Mode         => 'all', # all words
       Start        => 0,
       Count        => $conf->{'-d'} || 100,
       Type         => "pdf",
       AllowAdult   => 0, # no porn, please
       AllowSimilar => 0, # no dups, please
       Language     => undef,
      );
    warn $@ if $@;		# report any errors



    my @all;
    for my $Result (@Results) {
      printf "Result: #%d\n",  $Result->I + 1;
      printf "Url:%s\n",       $Result->Url;
      printf "%s\n",           $Result->ClickUrl;
      printf "Summary: %s\n",  $Result->Summary;
      printf "Title: %s\n",    $Result->Title;
      system "/var/lib/myfrdcsa/codebases/internal/radar/scripts/radar-method-publication.pl \"".$Result->Url."\"";
    }

    #     my $OUT;
    #     open(OUT,">$file") or die "can't open\n";
    #     print OUT Dumper(\@all);
    #     close(OUT);
  }
}
