package Code::TidyAll::Plugin::JSON;

use strict;
use warnings;

use JSON::MaybeXS ();
use Moo;

our $VERSION = '0.28';

extends 'Code::TidyAll::Plugin';

has 'ascii' => ( is => 'ro', default => 0 );

sub transform_source {
    my $self   = shift;
    my $source = shift;

    my $json = JSON::MaybeXS->new(
        canonical => 1,
        pretty    => 1,
        relaxed   => 1,
        utf8      => 1,
    );

    $json = $json->ascii if $self->ascii;

    return $json->encode( $json->decode($source) );
}

1;

# ABSTRACT: Use the JSON::MaybeXS module to tidy JSON documents with tidyall

__END__

=pod

=head1 SYNOPSIS

   In configuration:

   [JSON]
   select = **/*.json
   ascii = 1

=head1 DESCRIPTION

Uses L<JSON::MaybeXS> to format JSON files. Files are put into a canonical
format with the keys of objects sorted.

=head1 CONFIGURATION

=over

=item ascii

Escape non-ASCII characters. The output file will be valid ASCII.

=back
