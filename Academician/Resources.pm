package Academician::Resources;

use Moose;

has 'Context' =>
  (
   is => 'rw',
   isa => 'Str',
   default => 'Org::FRDCSA::Academician',
  );

has 'Client' =>
  (
   is => 'rw',
   isa => 'KBS2::Client',
   default => sub {
     my ($self) = @_;
     KBS2::Client->new
	 (
	  Debug => 0,
	  Method => "MySQL",
	  Database => "freekbs2",
	  Context => $self->Context,
	 );
   },
  );

has 'ImportExport' =>
  (
   is => 'rw',
   isa => 'KBS2::ImportExport',
   default => sub {
     KBS2::ImportExport->new();
   },
  );

1;
