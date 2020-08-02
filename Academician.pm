package Academician;

use Academician::Agent;
use Academician::Resources;

use Moose;

use BOSS::Config;
# use MyFRDCSA;
use PerlLib::SwissArmyKnife;

has Config =>
  (
   is => 'rw',
   isa => 'BOSS::Config',
  );

has Resources =>
  (
   is => 'rw',
   isa => 'Academician::Resources',
   default => sub { Academician::Resources->new },
  );

has Agent =>
  (
   is => 'rw',
   isa => 'Academician::Agent',
   default => sub {
     my ($self) = @_;
     Academician::Agent->new(Academician => $self);
   },
  );

sub BUILD {
  my ($self,$args) = @_;
  my %args = %$args;
  my $specification = "
	-u [<host> <port>]	Run as a UniLang agent

	-w			Require user input before exiting
";
  # $UNIVERSAL::systemdir = ConcatDir(Dir("internal codebases"),"academician");
  $self->Config
    (BOSS::Config->new
     (Spec => $specification,
      ConfFile => ""));
  my $conf = $self->Config->CLIConfig;

  if (exists $conf->{'-u'}) {
    $UNIVERSAL::agent->DoNotDaemonize(1);
    $UNIVERSAL::agent->Register
      (Host => defined $conf->{-u}->{'<host>'} ?
       $conf->{-u}->{'<host>'} : "localhost",
       Port => defined $conf->{-u}->{'<port>'} ?
       $conf->{-u}->{'<port>'} : "9000");
  }
}

sub Execute {
  my ($self,%args) = @_;
  my $conf = $self->Config->CLIConfig;
  if (exists $conf->{'-u'}) {
    # enter in to a listening loop
    while (1) {
      $UNIVERSAL::agent->Listen(TimeOut => 10);
    }
  }
  if (exists $conf->{'-w'}) {
    Message(Message => "Press any key to quit...");
    my $t = <STDIN>;
  }
}

sub ProcessMessage {
  my ($self,%args) = @_;
  my $m = $args{Message};
  my $it = $m->Contents;
  if ($it) {
    if ($it =~ /^echo\s*(.*)/) {
      $UNIVERSAL::agent->SendContents
	(Contents => $1,
	 Receiver => $m->{Sender});
    } elsif ($it =~ /^(quit|exit)$/i) {
      $UNIVERSAL::agent->Deregister;
      exit(0);
    } elsif ($it =~ /^ListDocuments$/) {
      $self->Agent->LoadLogicbase();
      $UNIVERSAL::agent->SendContents
	(
	 Contents => 'documents',
	 Data => {
		  Documents => $self->Agent->ListDocuments(),
		 },
	 Receiver => $m->{Sender},
	);
      $self->Agent->ClearLogicbase();
    } elsif ($it =~ /^FirstUnreadPage$/) {
      $self->Agent->LoadLogicbase();
      my $res = $self->Agent->FirstUnreadPage
	(Doc => exists $m->{Data}{Doc} ? $m->{Data}{Doc} : undef);
      print Dumper({Res => $res});
      $UNIVERSAL::agent->SendContents
	(
	 Contents => 'FirstUnreadPage',
	 Data => $res,
	 Receiver => $m->{Sender},
	);
      $self->Agent->ClearLogicbase();
    } elsif ($it =~ /^PageReadRanges$/) {
      $self->Agent->LoadLogicbase();
      $UNIVERSAL::agent->SendContents
	(
	 Contents => 'page-read-ranges',
	 Data => {
		  Documents => $self->Agent->PageReadRanges(),
		 },
	 Receiver => $m->{Sender},
	);
      $self->Agent->ClearLogicbase();
    }
  }
}

1;
