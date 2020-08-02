#!/usr/bin/perl -w

use AI::Prolog;
use KBS2::Client;
use KBS2::ImportExport;
use KBS2::Util;
use PerlLib::SwissArmyKnife;
use UniLang::Util::TempAgent;

# my $context = "Org::FRDCSA::System::LogicMOO::test";

my $importexport = KBS2::ImportExport->new();

my $context = "Org::FRDCSA::Academician";
my $client = KBS2::Client->new
  (
   Debug => 0,
   Method => "MySQL",
   Database => "freekbs2",
   Context => $context,
  );

my $res = $client->Send
  (
   QueryAgent => 1,
   Command => "all-asserted-knowledge",
   Database => "freekbs2",
   Context => $context,
  );


if (exists $res->{Data}) {
  if (exists $res->{Data}{Result}) {
    my $res2 = $importexport->Convert(InputType => 'Interlingua', OutputType => 'Prolog', Input => $res->{Data}{Result});
    if ($res2->{Success}) {
      FirstUnreadPage(Contents => $res2->{Output});
    }
  }
}

sub FirstUnreadPage {
  my (%args) = @_;

  my $logic = <<'END_PROLOG';

max(0).

seen(Page) :-
   done(seen(andrewdo, 'page-no'(Page,
	'publication-fn'('Object-Oriented-Programming-in-Common-Lisp')))).

first_unread_page(X) :-
	get_max(_),
	get_min(_),
	min(X).

unread_page(X,Y) :-
	seen(X),
	Y is X + 1,
	not(seen(Y)).

get_max(X) :-
	seen(X),
	max(Y),
	X > Y,
	retract(max(Y)),
	assert(max(X)),
	fail.
get_max(X) :-
	max(X),
	assert(min(X)).

get_min(X) :-
	min(Y),
	unread_page(_,X),
	X < Y,
	retract(min(Y)),
	assert(min(X)),
	fail.
get_min(X) :-
	true.

END_PROLOG

  $args{Contents} =~ s/\bread\b/seen/sg;

  my $database = $logic.$args{Contents};

  if (1) {
    foreach my $line (split /\n/, $database) {
      ++$i;
      print "$i $line\n";
    }
  }

  my $prolog = AI::Prolog ->new($database);

  $prolog->query("first_unread_page(X).");
  while (my $result = $prolog->results) {
    print Dumper({Results => $result});
  }
}


# % greater_than(X,Y) :-
# % 	seen(X),
# %         seen(Y),
# % 	X >= Y.
# %
# % first_unread_page(Y) :-
# % 	greater_than(X,Y).
# % first_unread_page(Y) :-
# % 	true.
