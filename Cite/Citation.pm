package Cite::Citation;

use Cite::Util;
use Data::Dumper;
use String::Similarity;
use Text::Capitalize;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / Citation ParsedCitation Document PaperID SectionID
                          StringType Status HashRef Type AuthorIDs / ];

sub init {
  # create a new citation object, used to store and manipulate citation information
  my ($self,%args) = (shift,@_);
  $self->Document($args{Document});
  $self->Citation($args{Citation});
}

sub Clean {
  my ($self,%args) = (shift,@_);
  $self->ParsedCitation(undef);
}

sub Parse {
  my ($self,%args) = (shift,@_);

  Message("Parse citation string");
  if (0 && ! $args{Automatic}) {
    $self->Clean;
    if (! Approve("Parse this citation?\n".$self->Citation)) {
      return;
    }
  }

  $self->ParsedCitation($UNIVERSAL::cite->CitationParser->parse($self->Citation));
  if ($self->ParsedCitation->{atitle} =~ /"[^"]+"/) {
    $self->ParsedCitation->{atitle} =~ s/^.*"([^"]+)".*/$1/;
    $self->ParsedCitation->{atitle} =~ s/[,.]+$//;
  }

  if (! $args{Automatic}) {
    print "TITLE: ".$self->ParsedCitation->{atitle}."\n";
    if (!Approve("Correct?")) {
      $self->ParsedCitation->{atitle} = Query ("Enter your own:");
    }
  }

  # Message("Do a DB lookup on the PAPER_ID");
  my ($limit,$similarity,@matches) = (0,0,());
  foreach my $ref (@{$UNIVERSAL::cite->HashRefs}) {
    $similarity = similarity($self->ParsedCitation->{atitle}, $ref->{TITLE},0);
    push @matches, [$ref, $similarity];
  }

  my @tmp = sort {$b->[1] <=> $a->[1]} @matches;
  my @sorted = splice(@tmp,0,$args{SearchWidth});
  my @menu = qw (correct not-found widen-search misparsed other-contents unusable);
  my $count = scalar @menu;
  my @items = map {"<<<" . $_->[1] . ">\t<" . $_->[0]->{TITLE} . ">>>\n"} @sorted;
  push @menu, @items;
  my $matchingref = $sorted[0]->[0];

  if (! $args{Automatic}) {
    my $ans = Choose(@menu);
    if ($ans < $count) {
      return $menu[$ans];
    } else {
      $matchingref = $sorted[$ans - $count]->[0];
    }
  }

  # now lets go ahead and update the database
  my $command = "select * from PAPERINFO where TITLE='".$matchingref->{TITLE}."';";
  my $sth = $UNIVERSAL::cite->DBH->prepare($command);
  $sth->execute();
  my @hashrefs = ();
  while (my $ref = $sth->fetchrow_hashref()) {
    push @hashrefs, $ref;
  }
  if (@hashrefs) {
    $self->HashRef($hashrefs[0]);
  } else {
    Message $matchingref->{TITLE}." not found";
  }
  $self->SectionID($self->Document->Subject);
  return "correct";
}

sub Display {
  my ($self) = (shift);
  print "\n-----------------------------------------------------\n";
  if (defined $self->ParsedCitation) {
    print "Parsed:\t\t<<<".$self->ParsedCitation->{atitle}.">>>\n";
  }
  if (defined $self->HashRef && defined $self->HashRef->{PAPER_ID}) {
    print "PaperID:\t<<<".$self->HashRef->{PAPER_ID}.">>>\n";
  }
  if (defined $self->SectionID) {
    print "SectionID:\t<<<".$self->SectionID.">>>\n";
  }
  print "Citation:\t<<<".$self->Citation.">>>\n";
  print "-----------------------------------------------------\n\n";
}

sub PrintPaperID {
  my ($self) = (shift);
  return $self->SafePrintPaperID;
  my $text = $self->ParsedCitation->{authors}->[0]->{given};
  $text .= $self->ParsedCitation->{authors}->[0]->{family};
  $text .= "_";
  $text .= $self->HashRef->{YEAR};
  $text .= "_";

  my %words = $UNIVERSAL::cite->Tagger->get_words( $self->HashRef->{TITLE} );
  foreach my $key (keys %words) {
    push @keywords, split /\s+/,$key;
  }
  $text .= join("",splice(@keywords,0,2));
  return $text;
}

sub SafePrintPaperID {
  my ($self) = (shift);
  if (0) {
    my $text = $self->ParsedCitation->{authors}->[0]->{family};
    $text .= $self->ParsedCitation->{authors}->[0]->{given};
    $text .= "_";
    $text .= $self->ParsedCitation->{authors}->[0]->{date} || "unknown";
    $text .= "_";
    my %words = $UNIVERSAL::cite->Tagger->get_words( $self->ParsedCitation->{atitle} );
    foreach my $key (keys %words) {
      push @keywords, split /\s+/,$key;
    }
    $text .= join("",splice(@keywords,0,2));
    return $text;
  } else {
    my $text = $self->ParsedCitation->{authors}->[0]->{family};
    $text .= $self->ParsedCitation->{authors}->[0]->{date} || "unknown";
    my $temp = $self->ParsedCitation->{atitle};
    $temp = join("_",split / /,$temp);
    $text .= $temp;
    $text =~ /^(.{64})/;
    return $1 || $text;
  }
}

sub LookupAuthor {
  my ($self) = (shift);
  return "hi?";
}

sub ParsedCitationToSQL {
  my ($self) = (shift);
  if (! scalar $self->LookupPaper($self->ParsedCitation->{atitle})) {
    Message "Generating PAPERINFO SQL statement from Parsed Citation...";
    my $OUT;
    open(OUT,">/tmp/parsedcitation");
    print OUT Dumper($self->ParsedCitation);
    close (OUT);
    #system "emacsclient /tmp/parsedcitation";
    my $it = eval `cat /tmp/parsedcitation`;
    $self->ParsedCitation($it);

    # PAPERINFO statement
    print Dumper($self->Citation);
    my $command = "insert into PAPERINFO values (".
      "'".($self->SafePrintPaperID||"NULL")."',".
	"'".($self->ParsedCitation->{atitle}||"NULL")."',".
	  "'".($self->ParsedCitation->{date}||"unknown")."',".
	    "NULL,NULL,'NULL, Tech Reports',NULL,NULL,NULL,NULL,'CMU-ISRI-',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);";

    $UNIVERSAL::cite->AddCommand($command);
    $UNIVERSAL::cite->ReviewCommands;

    # _AUTHORS_ (_YEAR_). _TITLE_. Carnegie Mellon University, School of Computer Science, Institute for Software Research International,
    # Technical Report _TECHREPORT_ID_. URL: _URL_

    # now, from the database, extract the hashref
    # now lets go ahead and update the database

    my @hashrefs = $self->LookupPaper($self->ParsedCitation->{atitle});
    $self->HashRef($hashrefs[0] || {});
  }
}

sub ExtractAuthors {
  my ($self) = (shift);
  # first, parse out the authors from marked
  my $marked = $self->ParsedCitation->{marked};
  if ($marked =~ /<authors>(.*)<\/authors>/) {
    $self->ParsedCitation->{authors} = [];
    my $authors = $1;
    Message "Extracting authors from the parsed citation...";
    my $i = 0;
    foreach my $author (split(/\s*,\s*/,$authors)) {
      my $ref = $self->ParsedCitation->{authors}->[$i];
      if (!defined $ref) {
	$ref = {};
      }
      if ($author =~ /^\s*([\w.]+)\s+(([\w.]+)\s+)?(\w+)\s*$/) {
	$ref->{given} = $1;
	$ref->{mi} = $3;
	$ref->{family} = $4;
      }
      $self->ParsedCitation->{authors}->[$i] = $ref;
      ++$i;
    }
  }
}

sub LookupPaper {
  my ($self,$title) = (shift,shift);
  $command = "select * from PAPERINFO where TITLE='".$title."';";
  my $sth = $UNIVERSAL::cite->DBH->prepare($command);
  $sth->execute();
  my @hashrefs = ();
  while (my $ref = $sth->fetchrow_hashref()) {
    push @hashrefs, $ref;
  }
  return @hashrefs;
}

sub LookupAuthors {
  my ($self) = (shift);
  my $i = 0;
  Message "Looking up authors...";
  if (!defined($self->AuthorIDs)) {
    $self->AuthorIDs([]);
  }
  while (defined $self->ParsedCitation->{authors}->[$i]) {
    my $ref = $self->ParsedCitation->{authors}->[$i];
    $result = $UNIVERSAL::cite->AuthorIDCache($ref);
    if ($result) {
      $self->AuthorIDs->[$i] = $result;
    } else {
      # create an sql query to retrieve
      my $auth = $self->GetAuthor($ref);
      if (!$auth) {
	if ($ref->{given} || $ref->{family}) {
	  Message "Author $ref->{given} $ref->{mi} $ref->{family} not in database, inserting into database.";
	  $command = "insert into AUTHORINFO values (" .
	    "NULL,".
	      "'".($ref->{family}||"NULL")."',".
		"'".($ref->{given}||"NULL")."',".
		  "'".($ref->{mi}||"NULL")."',".
		    "NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);";
	  $UNIVERSAL::cite->AddCommand($command);
	  $auth = $self->GetAuthor($ref);
	}
      }
      # cache the result
      if ($auth) {
	$self->AuthorIDs->[$i] = $auth->{AUTHOR_ID};
	#$UNIVERSAL::cite->AddAuthorIDCache($ref,$authid);
      }
    }
    ++$i;
  }
}

sub GetAuthor {
  my ($self,$ref) = (shift,shift);
  if ($ref->{given} and $ref->{family}) {
    my $command = "select * from AUTHORINFO where FIRSTNAME like '%".$ref->{given}."%' and LASTNAME like '%".$ref->{family}."%';";
    my $sth = $UNIVERSAL::cite->DBH->prepare($command);
    $sth->execute();
    my %choicemap;
    while (my $match = $sth->fetchrow_hashref()) {
      $choicemap{"<".(join "> <",(map {$_ || ""} values %{$match})).">"} = $match;
    }
    if (scalar keys %choicemap) {
      # choose the correct result
      $resref = Choose(keys %choicemap);
      $result = $choicemap{$resref};
      if ($resref and $result) {
	return $result;
      }
    }
  }
}

sub GenAUTHORPAPER {
  my ($self) = (shift);
  Message "Generating AUTHORPAPER SQL statements from Parsed Citation...";
  my $i = 0;
  my $paperid = $self->HashRef->{PAPER_ID};
  $self->ExtractAuthors;
  $self->LookupAuthors;
  foreach my $authorid (@{$self->AuthorIDs}) {
    if ($authorid) {
      my $command = "update AUTHORPAPER set RANK='$i' where PAPER_ID='$paperid' and AUTHOR_ID='$authorid';";
      $UNIVERSAL::cite->AddCommand($command);
    }
    ++$i;
  }
}

sub FixCit {
  my ($self) = (shift);
  my @hashrefs = $self->LookupPaper($self->ParsedCitation->{atitle});
  print "################################################\n";
  print Dumper(@hashrefs);
  $self->HashRef($hashrefs[0] || {});
  $self->FixTitleExtension;
  $self->PrintPaperID;
  $self->UpdateKeywords;
  $self->GenAUTHORPAPER;
  $self->ReviewDataStructures;
  $UNIVERSAL::cite->ReviewCommands;
}

sub ReviewDataStructures {
  my ($self) = (shift);
}

sub FixTitleExtension {
  my ($self) = (shift);
  if ($self->ParsedCitation->{atitle} ne $self->HashRef->{TITLE}) {
    $self->DisplayInformation;
    Message "Fixing Title Extension...";
  }
}

sub DisplayInformation {
  my ($self) = (shift);
  print "****************************************\n";
  print $self->ParsedCitation->{atitle}."\n";
  print $self->HashRef->{TITLE}."\n";
  print $self->HashRef->{PAPER_ID}."\n";
  print "****************************************\n";
}

sub UpdateKeywords {
  my ($self,$keyword) = (shift,shift);
  $self->DisplayInformation;
  # first extract keywords field
  # remove all instances of the current sectionid there
  # reinsert sectionid
  $sectionid = $self->SectionID;
  if ($self->HashRef->{KEYWORDS} !~ /$sectionid/) {
    my $command =
      "update PAPERINFO set KEYWORDS=Concat(KEYWORDS,', ','".$self->SectionID."') where PAPER_ID='".$self->HashRef->{PAPER_ID}."';";
    $UNIVERSAL::cite->AddCommand($command);
  }
}

sub List {
  my ($self) = (shift);
  my $value;
  if ((defined $self->SectionID) && (defined $self->HashRef->{PAPER_ID})) {
    # relative
    # print "update PAPERINFO set KEYWORDS='".$self->SectionID."' where PAPER_ID='".$self->HashRef->{PAPER_ID}."';";
    $value = "update PAPERINFO set KEYWORDS=Concat(KEYWORDS,', ','".$self->SectionID."') where PAPER_ID='".$self->HashRef->{PAPER_ID}."';";
    $value .= "\n";
    if (defined $self->ParsedCitation) {
      $value .= "update PAPERINFO set TITLE='".$self->ParsedCitation->{'atitle'}."' where TITLE='".$self->HashRef->{TITLE}."';";
      $value .= "\n";
    }
    # now add the ability to fix the author rank
    return $value;
  }
}

1;
