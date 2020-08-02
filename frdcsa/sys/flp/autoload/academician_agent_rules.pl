%% (we need to import academician's kb to talk to
%%  /var/lib/myfrdcsa/codebases/minor/packager-agent/agent_rules/agent.pl,
%%  and add rules, such as if we have a definition of something, we
%%  need to periodically quiz the user until we're sure they know
%%  it.  then later, when they've forgotten it.  Develop ML model of
%%  how soon people will forget things.)

%% (academician should allow us to record symbols we want
%%  definitions for, and the context, for instance, 'defclaim'
%%  common lisp operator.  Then, when we define it it should store
%%  the definition as such, awaiting it to being formalized, in the
%%  meantime, it should periodically quiz us on the meaning of the
%%  term until we know it rote)

%% 'requires-definition-of'(X,Y) :-
