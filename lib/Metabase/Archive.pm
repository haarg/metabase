use 5.006;
use strict;
use warnings;

package Metabase::Archive;
# ABSTRACT: Interface for Metabase storage

use Moose::Role;

requires 'store';    # store( $fact_struct ) -- die or return $guid
requires 'extract';  # extract( $guid ) -- die or return $fact_struct

1;

__END__

=head1 SYNOPSIS

  package Metabase::Archive::Foo;
  use Metabase::Fact;
  use Moose;
  with 'Metabase::Archive';
  
  # define Moose attributes
  
  sub store {
    my ( $self, $fact_struct ) = @_;
    # store a fact
  }

  sub extract {
    my ( $self, $guid ) = @_;
    # retrieve a fact
    return $fact;
  }

=head1 DESCRIPTION

This describes the interface for storing and retrieving facts.  Implementations
must provide the C<store> and C<extract> methods.

=head1 BUGS

Please report any bugs or feature using the CPAN Request Tracker.  
Bugs can be submitted through the web interface at 
L<http://rt.cpan.org/Dist/Display.html?Queue=Metabase>

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

=cut
