package Academician::Agent;

use KBS2::Client;
use KBS2::ImportExport;
use KBS2::Util;
use PerlLib::SwissArmyKnife;
use UniLang::Util::TempAgent;

use Language::Prolog::Yaswi ':query', ':load', ':interactive', ':run';
use Language::Prolog::Sugar
  functors => {
	       'page_report' => 'page_report',
	       'page_read_p' => 'page_read_p',
	       'first_unread_page' => 'first_unread_page',
	      },
  vars => [qw(Doc X Page)];

use Moose;

has 'Academician' =>
  (
   is => 'rw',
   isa => 'Academician',
   handles => {
	       Resources => 'Resources',
	      },
  );

# has 'TopLevel' =>
#   (
#    is => 'ro',
#    isa => 'FileHandle',
#    default => swi_toplevel(),
#   );

sub LoadLogicbase {
  my ($self,%args) = @_;
  my $command = 'kbs2 -c '.shell_quote($self->Resources->Context).' --output-type Prolog show 2> /dev/null';
  my $output = `$command`;
  my $logic = read_file('/var/lib/myfrdcsa/codebases/minor/academician/frdcsa/prolog/academician.pl');
  my $database = $output."\n".$logic;
  my $fh = IO::File->new();
  $fh->open('>/tmp/academician.tmp.txt');
  print $fh $database;
  $fh->close();
  swi_inline($database);
  $self->PageReport();
}

sub ClearLogicbase {
  my ($self,%args) = @_;
  # FIXME: do something more elegant here, like having DB revision
  # hashes
  swi_cleanup();
}

sub LoadLogicbaseOrig {
  my ($self,%args) = @_;
  my $res = $self->Resources->Client->Send
    (
     QueryAgent => 1,
     Command => "all-asserted-knowledge",
     Database => "freekbs2",
     Context => $self->Resources->Context,
    );
  if (exists $res->{Data}) {
    if (exists $res->{Data}{Result}) {
      my $res2 = $self->Resources->ImportExport->Convert(InputType => 'Interlingua', OutputType => 'Prolog', Input => $res->{Data}{Result});
      if ($res2->{Success}) {
	# FIXME:  problem is it's not sorted.
	my $logic = read_file('/var/lib/myfrdcsa/codebases/minor/academician/frdcsa/prolog/academician.pl');
	my $database = $logic.$res2->{Output};
	print $database."\n";
	swi_inline($database);
      }
    }
  }
}

sub ListDocuments {
  my ($self,%args) = @_;
  my $documents = {};
  swi_set_query(page_read_p(Doc,Page));
  while (swi_next) {
    $documents->{swi_var(Doc)} = 1;
  }
  return $documents;
}

sub FirstUnreadPage {
  my ($self,%args) = @_;
  if ($args{Doc}) {
    swi_set_query(first_unread_page($args{Doc},Page));
    my $value;
    if (swi_next()) {
      swi_query();
      $value = swi_var(Page);
    }
    print Dumper({Value => $value})."\n";
    return {
	    Page => $value,
	   };
  } else {
    swi_set_query(first_unread_page(Doc,Page));
    my $documents = {};
    while (swi_next()) {
      swi_query();
      $documents->{swi_var(Doc)} = swi_var(Page);
    }
    return {
	    Documents => $documents,
	   };
  }
}

sub PageReport {
  my ($self,%args) = @_;
  swi_call(page_report);
}

1;
