package Cite::Parser;

use Cite::Util;

use Lingua::EN::Segmenter::TextTiling qw(segments);
use Lingua::EN::Splitter;
use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / / ];

sub init {

}

sub parse {
  my ($self) = (shift);
  my @matches;
  foreach my $citation ($self->parse_manually(shift)) {
    #if (Approve($citation)) {
      push @matches, $citation;
    #}
  }
  return @matches;
}

sub parse_manually {
  my ($self,$contents) = (shift,shift);
  return split(/\n\n+/, $contents);
}

sub parse_with_tiling {
  my ($self,$contents) = (shift,shift);
  my $num_segment_breaks = 1;
  print "$contents\n";
  my @segments = segments($num_segment_breaks,$contents);
  print Dumper($segments);
  #return @segments;
}

1;
