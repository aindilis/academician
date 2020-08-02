package Cite::Document;

use Cite::Util;
use Cite::Citation;

use Biblio::Document::Parser::Utils;
use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / RootFile HTMLFile TextFile LogFile URL ConvertedFile ParserChoice Citations
                          Subject OtherContents Content NotFound NotFound2 Unusable SQLFile Type / ];

sub init {
  my ($self,%args) = (shift,@_);
  my $file = $args{File};
  Message("Intializing document...");
  $file =~ s/\.html$//;
  $self->RootFile($file);
  $self->HTMLFile($self->RootFile . ".html");
  $self->SQLFile($self->RootFile . ".sql");
  $self->TextFile($self->RootFile . ".txt");
  $self->LogFile($self->RootFile . ".log");
  $self->URL("file://".$self->HTMLFile);
  my $subject = $file;
  $subject =~ s/^.*cache\///;
  $subject =~ s|\/|-|g;
  $self->Subject($args{Subject} || $subject);
  $self->OtherContents([]);
  $self->NotFound([]);
  $self->NotFound2([]);
  $self->Unusable([]);
  $self->Citations({});
  Message("Done.");
}

sub IterateOverCitations {
  my ($self) = (shift);
  my $citation;

  Message("Iterating over citations...");
  my @extractedcitations;

  # allow the user to edit the file before it gets read
  system "emacsclient ".$self->TextFile;

  Message("Extract citation strings for document: ".$self->TextFile);
  $self->Content(Biblio::Document::Parser::Utils::get_content($self->TextFile));
  my @citationstrings = $UNIVERSAL::cite->DocumentParser->parse($self->Content);

  Attention();
  Message("Create and automatically parse citation objects");
  my @menu = qw(citation other-contents);
  my $t = @citationstrings;
  my $i = 1;
  foreach $citationstring (@citationstrings) {
    if (! $self->LookupCitationByString($citationstring)) {
      $citation = Cite::Citation->new(Citation => $citationstring,
				      Document => $self);
      $self->Citations->{$citationstring} = $citation;
      if (! defined $citation->StringType) {
	print "$i/$t\n";
	Message("What is this string?");
	$citation->Display;
	my $ans = Choose(@menu);
	if ($menu[$ans] eq "citation") {
	  $citation->StringType("citation");
	} elsif ($menu[$ans] eq "other-contents") {
	  $citation->StringType("other-contents");
	}
      }
    }
    ++$i;
  }

  Attention();
  Message("Parse citations automatically for review.");
  foreach $citation (filter(
			    sub {
			      my $it = shift;
			      if ((defined $it) && 
				  (defined $it->StringType) && 
				  ($it->StringType eq "citation")) {
			       return 1;
			     }
			    }, values %{$self->Citations})) {
    if (! defined $citation->Status) {
      $citation->Parse(Automatic => 1,
		       SearchWidth => 10);
      push @extractedcitations, $citation;
    }
  }

  Attention();
  Message("Review citation object quality");
  @menu = qw(correct misparsed not-found other-contents);
  my (@correct,@misparsed,@othercontents,@notfound,@notfound2,@unusable);
  foreach $citation (@extractedcitations) {
    $citation->Display;
    my $ans = Choose(@menu);
    if ($menu[$ans] eq "correct") {
      push @correct, $citation;
    } elsif ($menu[$ans] eq "misparsed") {
      push @misparsed, $citation;
    } elsif ($menu[$ans] eq "not-found") {
      push @notfound, $citation;
      push @notfound2, $citation->Citation;
    } elsif ($menu[$ans] eq "other-contents") {
      push @othercontents, $citation;
    }
  }

  Attention();
  Message("Manually correct misparsed citation objects");
  while ($citation = shift @misparsed) {
    $citation->Display;
    my %args;
    $args{Automatic} = 0;
    $args{SearchWidth} = 10;
    my $loop = 1;
    while ($loop) {
      my $ans = $citation->Parse(%args);
      if ($ans eq "correct") {
	push @correct, $citation;
	$citation->Status("correct");
	$loop = 0;
      } elsif ($ans eq "not-found") {
	push @notfound, $citation;
	print Dumper($citation);
	push @notfound2, $citation->ParsedCitation->{atitle};
	$citation->Status("not-found");
      	$loop = 0;
      } elsif ($ans eq "widen-search") {
	$args{SearchWidth} = "1000";
      } elsif ($ans eq "misparsed") {
	push @misparsed, $citation;
	$citation->Status("misparsed");
      	$loop = 0;
      } elsif ($ans eq "other-contents") {
	push @othercontents, $citation;
	$citation->Type("other-contents");
      	$loop = 0;
      } elsif ($ans eq "unusable") {
	push @unusable, $citation;
	$citation->Status("unusable");
	$loop = 0;
      }
    }
  }

  Attention();
  $self->OtherContents(\@othercontents);
  $self->NotFound(\@notfound);
  $self->NotFound2(\@notfound2);
  $self->Unusable(\@unusable);
  $self->SaveInformation;
}

sub LookupCitationByString {
  my ($self,$string) = (shift,shift);
  if (defined $string and defined $self->Citations->{$string}) {
    return $self->Citations->{$string};
  }
}
 
sub Display {
  Message("Display the document information");
  my ($self) = (shift);
  print "<File:" . $self->HTMLFile . ">\n";
  print "<URL:" . $self->URL . ">\n";
  print "<TextFile:" . $self->TextFile . ">\n";
  system "mozilla -remote 'openURL(".$self->URL.")'";
}

sub SaveInformation {
  my ($self) = (shift);
  my $OUT;
  open (OUT,">".$self->LogFile) or die "Ouch!";
  print OUT Dumper($self);
  close (OUT);
}

sub LoadInformation {
  my ($self) = (shift);
  my $file = $self->LogFile;
  if (-f $file) {
    my $copy = eval `cat $file`;
    foreach my $key (keys %{$self}) {
      $self->{$key} = $copy->{$key};
    }
    # print Dumper($self);
    return 1;
  }
}

sub Attention {
  Message("");
  Message("***************************************************");
  Message("***************************************************");
  Message("***************************************************");
  Message("");
}

sub filter {
  my ($sub,@list) = (shift,@_);
  my @res;
  foreach my $elt (@list) {
    if (&$sub($elt)) {
      push @res,$elt;
    }
  }
  return @res;
}

sub List {
  my ($self) = (shift);
  # process it again to get the order
  #$self->Content(Biblio::Document::Parser::Utils::get_content($self->LogFile));
  my $file = $self->TextFile;
  my $contents = `cat $file`;
  my $results;
  $self->Content($contents);
    print "<<<".$self->Content.">>>\n";
  my @citationstrings = $UNIVERSAL::cite->DocumentParser->parse($self->Content);
  foreach $citationstring (@citationstrings) {
    if (defined $self->{'Citations'}->{$citationstring}) {
      $results .= $self->{'Citations'}->{$citationstring}->List;
    }
  }
  return $results;
}

sub ListCitations {
  my ($self) = (shift);
  return values %{$self->Citations};
}

sub AddNotFoundCitationsToDB {
  my ($self) = (shift);
  foreach my $text (@{$self->NotFound2}) {
    my $citation = $self->LookupCitationByString($text);
    if ($citation) {
      $citation->ParsedCitationToSQL;
    }
  }
}

sub FixDoc {
  my ($self) = (shift);
  foreach my $cit ($self->ListCitations) {
    $cit->FixCit;
  }
}

sub SaveSQLFile {
  my ($self) = (shift);
  my $OUT;
  open (OUT,">".$self->SQLFile) or die "ouch";
  my $result = $self->List;
  print $result;
  print OUT $result;
  close (OUT);
}

sub DESTROY {
  my ($self) = (shift);
  $self->SaveInformation;
}

1;
