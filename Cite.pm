package Cite;

use Cite::Util;
use Cite::Document;

use DBI;
use Data::Dumper;
use Cite::Parser;

use Lingua::EN::Tagger;

use Biblio::Document::Parser::Standard;
use Biblio::Document::Parser::Utils;
use Biblio::Document::Parser::Brody;
use Biblio::Citation::Parser::Standard;
use Biblio::Citation::Parser::Citebase;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / Documents Files ProjectDir CacheDir Refs Mappings HashRefs DocumentParser
                          LoggingFile CitationParser ParserChoice DBH DocumentFile MappingsFile
                          Project Tagger Commands / ];

sub init {
  my ($self,%args) = (shift,@_);
  Message("Init...");
  $self->ProjectDir($args{ProjectDir} || "/var/lib/myfrdcsa/codebases/minor/academician");
  $self->CacheDir($args{CacheDir} || $self->ProjectDir."data/cache");
  $self->ParserChoice($args{ParserChoice} || "Custom");
  $self->Refs([]);
  $self->Commands([]);
  $self->Project($args{Project} || "default");
  $self->MappingsFile($args{MappingsFile} || "input-data/".$self->Project.".map");
  $self->DocumentFile($args{DocumentFile} || "output-data/".$self->Project.".doc");
  $self->Tagger(Lingua::EN::Tagger->new(stem => 0));

  Message("Load documents...");
  if (-f $self->DocumentFile) {
    my $file = $self->ProjectDir."/".$self->DocumentFile;
    eval `cat $file`;
    $self->Documents($VAR1);
  } else {
    $self->Documents([]);
  }

  Message("Load mappings...");
  my $file = $self->MappingsFile;
  my $mappings = eval `cat $file`;
  $self->Mappings($mappings);
  if (! -d $self->CacheDir) {
    Message("CacheDir does not exist");
    system "mkdirhier ".$self->CacheDir;
    $self->CacheWebsites;
  }

  Message("Load cache...");
  my $cachedir = $self->CacheDir;
  my @files = map {s/^.*cache//} split /\n/,`ls $cachedir/*.html`;
  $self->Files(\@files);
  $self->LoadDB;
  $self->ChooseParser;
}

sub Execute {
  my ($self) = (shift);
  Message("Execute...");
  $self->IterateOverDocuments;
}

sub LoadDB {
  my ($self) = (shift);
  Message("Load DB...");
  my @hashrefs;
  $self->DBH(DBI->connect("DBI:mysql:database=CASOS;host=localhost",
		      "root", "",
		      {'RaiseError' => 0}));
  $command = "select * from PAPERINFO";
  my $sth = $self->DBH->prepare($command);
  $sth->execute();
  while (my $ref = $sth->fetchrow_hashref()) {
    push @hashrefs, $ref;
  }
  $self->HashRefs(\@hashrefs);
}

sub ChooseParser {
  my ($self) = (shift);
  if ($self->ParserChoice eq "Brody") {
    $self->DocumentParser(new Biblio::Document::Parser::Brody());
  } elsif ($self->ParserChoice eq "Custom") {
    $self->DocumentParser(new Cite::Parser());
  } else {
    $self->DocumentParser(new Biblio::Document::Parser::Standard());
  }
  $self->CitationParser(new Biblio::Citation::Parser::Standard());
}

sub CacheWebsites {
  my ($self) = (shift);
  my $it;
  my $i = 0;
  foreach my $url (keys %{$self->Mappings}) {
    $self->CacheURL($url);
  }
}

sub CacheURL {
  my ($self,$url) = (shift,shift);
  my $file = $url;
  $file =~ s/^.*\.edu\///;
  my $subject = $file;
  $subject =~ s/\.html$//;
  $subject =~ s|\/|-|g;
  my $textfile = $subject;
  $textfile =~ s/$/.txt/;
  system "wget -O ".$self->CacheDir."/${subject}.html $url";
  print "lynx -force_html -dump ".$self->CacheDir."/${subject}.html | " .
    "perl -e 'while (<>) { \$it .= \$_ }; \$it  =~ s/References.*//sm; print \$it' > ".$self->CacheDir."/$textfile";
  system "lynx -force_html -dump ".$self->CacheDir."/${subject}.html | " .
    "perl -e 'while (<>) { \$it .= \$_ }; \$it  =~ s/References.*//sm; print \$it' > ".$self->CacheDir."/$textfile";
}

sub IterateOverDocuments {
  my ($self) = (shift);
  Message("Iterate over documents...");
  my $i = 0;
  my $cachedir = $self->CacheDir;
  chdir "$cachedir";
  foreach my $url (keys %{$self->Mappings}) {
    my $file = $url;
    $file =~ s/^.*\.edu\///;
    my $subject = $file;
    $subject =~ s/\.html$//;
    $subject =~ s|\/|-|g;
    my $textfile = $subject;
    $textfile =~ s/$/.txt/;
    if (! -f $textfile) {
      Message("Retrieving <$url>...");
      $self->CacheURL($url);
    }
    if (-f $textfile) {
      Message("Looking at citations for <$url>...");
      my $document = Cite::Document->new(File => $subject,
					 Subject => $self->Mappings->{$url});
      $self->AddDocument($document);
      if (! -f $document->SQLFile) {
	$document->IterateOverCitations();
	Message("Creating SQL file...");
	$document->SaveSQLFile();
	$document->SaveInformation();
	$self->SaveInformation;
      }
    }
  }
}

sub InitializeDocuments {
  my ($self) = (shift);
  Message("Initialize documents...");
  my $i = 0;
  my $cachedir = $self->CacheDir;
  chdir "$cachedir";
  foreach my $url (keys %{$self->Mappings}) {
    my $file = $url;
    $file =~ s/^.*\.edu\///;
    my $subject = $file;
    $subject =~ s/\.html$//;
    $subject =~ s|\/|-|g;
    my $textfile = $subject;
    $textfile =~ s/$/.txt/;
    if (-f $textfile) {
      my $document = Cite::Document->new
	(
	 File => $subject,
	 Subject => $self->Mappings->{$url},
	);
      $self->AddDocument($document);
    }
  }
}

sub List {
  my ($self) = (shift);
  foreach my $document (@{$self->Documents}) {
    $document->List;
  }
}

sub SaveInformation {
  my ($self) = (shift);
  my $OUT;
  chdir $self->ProjectDir;
  Message("Saving information...");
  my $answer = $self->DocumentFile;
  if (!open(OUT,">$answer")) {
    do {
      print "Can't open file: <".$answer.">!\n";
      print "Please enter alternate file name.\n";
      $answer = <STDIN>;
      chomp $answer;
    } while (!open(OUT,">".$answer));
  }
  $Data::Dumper::Purity = 1;
  # $Data::Dumper::Deepcopy = 1;
  print OUT Dumper($self->Documents);
  close(OUT);
  Message("Done.");
}

sub AddDocument {
  my ($self,$doc) = (shift,shift);
  Message("Adding document...");
  # print Dumper($self->Documents);
  push @{$self->Documents}, $doc;
  Message("Done.");
}

sub Todo {
  my ($self) = (shift);
  if ($self->Project eq "techreports") { # stage 1 get all of the papers loaded into the database
    # add any missing papers
    $self->FixTechReports;
  } elsif ($self->Project eq "all") {
    $self->FixDocuments;
  }
  $self->AddMissingCitations;
  # don't forget then to upload this back to the server
}

sub FixTechReports {
  my ($self) = (shift);
  Message "Fixing Technical Reports...";
  # get things
  # verify that we are indeed using the correct project
  foreach my $doc (@{$self->Documents}) {
    $doc->AddNotFoundCitationsToDB;
    foreach my $cit ($doc->ListCitations) {
      $cit->FixCit;
    }
  }
  $UNIVERSAL::cite->ReviewCommands;
}

sub AddMissingCitations {
  my ($self) = (shift);
  Message "Adding Missing Citations to Database...";
  foreach my $doc (@{$self->Documents}) {
    $doc->AddNotFoundCitationsToDB;
  }
  $UNIVERSAL::cite->ReviewCommands;
}

sub FixDocuments {
  my ($self) = (shift);
  foreach my $doc (@{$self->Documents}) {
    # first, for each document, find its corresponding paper in the database
    $doc->FixDoc;
  }
}

sub AuthorIDCache {
  my ($self) = (shift);
  return;
}

sub AddAuthorIDCache {
  my ($self,$ref,$result) = (shift,shift,shift);
}

sub AddCommand {
  my ($self,$command) = (shift,shift);
  push @{$self->Commands},$command;
}

sub ReviewCommands {
  my ($self) = (shift);
  while ($command = shift @{$self->Commands}) {
    if (Approve($command."\n")) {
      $self->DBH->do($command);
    }
  }
}

1;
