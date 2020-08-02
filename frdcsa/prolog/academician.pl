:- dynamic seen/1.
:- dynamic max/2.
:- dynamic min/2.
:- dynamic total_read/2.
:- dynamic new_total/1.

new_total(0).

page_read_p(Doc,Page) :-
	done('page-read'(andrewdo, 'page-no'(PageAtom, 'publication-fn'(Doc)))),
	atom_number(PageAtom,Page),
	integer(Page).

page_report :-
	do_report,
	fail.
page_report :-
	nl,nl,write('Pages read over all books: '), 
	total_read(Doc,Total),
	% write(Total),tab(5),write(Doc),nl,
	new_total(X),
	retract(new_total(X)),
	Y is X + Total,
	assertz(new_total(Y)),
	fail.
page_report :-
	new_total(Total),write(Total),nl.


do_report :-
	page_read_p(Doc,_),
	not(seen(Doc)),
	asserta(seen(Doc)),
	asserta(total_read(Doc,0)),
	asserta(max(Doc,0)),
	nl,write(Doc),nl,
	list_properties(Doc),
	fail.


list_properties(Doc) :-
	tab(3),write('First unread: '),
	first_unread_page(Doc,Page),
	write(Page),
	fail.
list_properties(Doc) :-
	nl,
	fail.
% list_properties(Doc) :-
% 	tab(3),write('Min: '),
% 	min(Doc,Page),
% 	write(Page),
% 	fail.
% list_properties(Doc) :-
% 	nl,
% 	fail.
% list_properties(Doc) :-
% 	tab(3),write('Max: '),
% 	max(Doc,Page),
% 	write(Page),
% 	fail.
% list_properties(Doc) :-
% 	nl,
% 	fail.
list_properties(Doc) :-
	tab(3),write('Ranges read (inclusive): '),
	maximal_contiguous(Doc,X,Y),
	write_range(Doc,X,Y),write(','),tab(1),
	fail.
list_properties(Doc) :-
	nl,
	tab(3),write('Total read: '),
	total_read(Doc,Total),
	write(Total),nl.

write_range(Doc,X,Y) :-
	X \= Y,
	total_read(Doc,Total),
	retract(total_read(Doc,Total)),
	Diff is (Y - X) + 1,
	NewTotal is Total + Diff,
	asserta(total_read(Doc,NewTotal)),
	write(X),write('-'),write(Y).
write_range(Doc,X,Y) :-
	X = Y,
	total_read(Doc,Total),
	retract(total_read(Doc,Total)),
	NewTotal is Total + 1,
	asserta(total_read(Doc,NewTotal)),
	write(X).

first_unread_page(Doc,Page) :-
	get_max(Doc),
	get_min(Doc),
	fail.
first_unread_page(Doc,Page) :-
	min(Doc,X),
	X >= 2,
	Page is 1.
first_unread_page(Doc,Page) :-
	min(Doc,X),
	X = 1,
	maximal_contiguous(Doc,X,Y),
	Page is Y + 1.

% a_leading_unread_page(Doc,0,1) :-
% 	not(page_read_p(Doc,1)).
% a_leading_unread_page(Doc,X,Y) :-
% 	page_read_p(Doc,X),
% 	Y is X + 1,
% 	not(page_read_p(Doc,Y)).

get_max(Doc) :-
	page_read_p(Doc,X),
	max(Doc,Y),
	X > Y,
	retract(max(Doc,Y)),
	asserta(max(Doc,X)),
	fail.
get_max(Doc) :-
	max(Doc,X),
	asserta(min(Doc,X)).

get_min(Doc) :-
	page_read_p(Doc,X),
	min(Doc,Y),
	X < Y,
	retract(min(Doc,Y)),
	asserta(min(Doc,X)),
	fail.
get_min(Doc) :-
	true.

contiguous(Doc,X,X) :-
	page_read_p(Doc,X).
contiguous(Doc,X,Y) :-
	page_read_p(Doc,Y),
	Z is Y - 1,
	contiguous(Doc,X,Z).

maximal_contiguous(Doc,X,Y) :-
	contiguous(Doc,X,Y),
	A is X - 1,
	not(page_read_p(Doc,A)),
        B is Y + 1,
	not(page_read_p(Doc,B)).

total_unread(Doc,Total) :-
	Total is 0.
