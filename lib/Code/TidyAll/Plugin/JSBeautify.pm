package Code::TidyAll::Plugin::JSBeautify;

use File::Slurp::Tiny qw(write_file);
use IPC::Run3 qw(run3);
use Moo;
use Try::Tiny;
extends 'Code::TidyAll::Plugin';

our $VERSION = '0.48';

sub _build_cmd {'js-beautify'}

sub transform_file {
    my ( $self, $file ) = @_;

    try {
        my $cmd = join( " ", $self->cmd, $self->argv, $file );

        my $output;
        my $exit = run3( $cmd, \undef, \$output, \$output );
        die "exitted with $?\n" if $?;
        write_file( $file, $output );
    }
    catch {
        die sprintf(
            "%s failed - possibly bad arg list '%s'\n    $_", $self->cmd,
            $self->argv
        );
    };
}

1;

# ABSTRACT: Use js-beautify with tidyall

__END__

=pod

=head1 SYNOPSIS

   In configuration:

   [JSBeautify]
   select = static/**/*.js
   argv = --indent-size 2 --brace-style expand

=head1 DESCRIPTION

Runs L<js-beautify|https://npmjs.org/package/js-beautify>, a JavaScript tidier.

=head1 INSTALLATION

Install L<npm|https://npmjs.org/>, then run

    npm install js-beautify -g

Do not confuse this with the C<jsbeautify> package (without the dash).

=head1 CONFIGURATION

=over

=item argv

Arguments to pass to js-beautify

=item cmd

Full path to js-beautify

=back
