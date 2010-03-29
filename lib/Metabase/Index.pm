use 5.006;
use strict;
use warnings;

package Metabase::Index;
# ABSTRACT: Interface for Metabase indexing

use Moose::Role;

requires 'add';
requires 'search';

sub exists {
    my ($self, $guid) = @_;
    return scalar @{ $self->search( 'core.guid' => lc $guid ) };
}

sub clone_metadata {
  my ($self, $fact) = @_;
  my %metadata;

  for my $type (qw(core content resource)) {
    my $method = "$type\_metadata";
    my $data   = $fact->$method || {};

    for my $key (keys %$data) {
      # I'm just starting with a strict-ish set.  We can tighten or loosen
      # parts of this later. -- rjbs, 2009-03-28
      die "invalid metadata key" unless $key =~ /\A[-_a-z0-9.]+\z/;
      $metadata{ "$type.$key" } = $data->{$key};
    }
  }

  for my $key ( qw/resource creator/ ) {
    $metadata{"core.$key"} = $metadata{"core.$key"}->resource
      if exists $metadata{"core.$key"};
  }
  
  return \%metadata;
}

1;

__END__

=head1 SYNOPSIS

  package Metabase::Index::Bar;
  use Metabase::Fact;
  use Moose;
  with 'Metabase::Index';
  
  # define Moose attributes
  
  sub add {
    my ( $self, $fact ) = @_;
    # index a fact
  }

  sub search {
    my ( $self, %spec ) = @_;
    # conduct search 
    return \@matches;
  }


=head1 DESCRIPTION

This describes the interface for indexing and searching facts.  Implementations
must provide the C<add> and C<search> methods.

=head1 USAGE

=head2 C<exists>

  if ( $index->exists( $guid ) ) { do_stuff() }

This interface provides an C<exists> method that calls C<search()> and 
returns a boolean value.

=head2 C<search>

  for $guid ( @{ $index->search( %spec ) } ) {
    # do stuff
  }

Returns an arrayref of GUIDs satisfying the search spec.  Exact semantics
of the search spec are still under development.  At a minimum, a list of
key value pairs should be considered to be an "AND" operation testing
for equality.

Keys should be keys from core, content, or resource metadata.  E.g.

  core.guid
  core.type
  core.resource
  content.somefield
  
=head1 BUGS

Please report any bugs or feature using the CPAN Request Tracker.  
Bugs can be submitted through the web interface at 
L<http://rt.cpan.org/Dist/Display.html?Queue=Metabase>

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

=cut
