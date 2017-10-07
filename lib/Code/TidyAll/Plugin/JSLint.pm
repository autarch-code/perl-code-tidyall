package Code::TidyAll::Plugin::JSLint;

use strict;
use warnings;

use IPC::Run3 qw(run3);
use Text::ParseWords qw(shellwords);

use Moo;

extends 'Code::TidyAll::Plugin';

with 'Code::TidyAll::Role::RunsCommand';

our $VERSION = '0.70';

sub _build_cmd {'jslint'}

sub validate_file {
    my ( $self, $file ) = @_;

    my $output = $self->_run_or_die($file);
    die "$output\n" if $output =~ /\S/ && $output !~ /.+ is OK\./;

    return;
}

sub _is_bad_exit_code { return $_[1] > 1 }

1;

# ABSTRACT: Use jslint with tidyall

__END__

=pod

=head1 SYNOPSIS

   In configuration:

   [JSLint]
   select = static/**/*.js
   argv = --white --vars --regex

=head1 DESCRIPTION

Runs L<jslint|http://www.jslint.com/>, a JavaScript validator, and dies if any
problems were found.

=head1 INSTALLATION

Install L<npm|https://npmjs.org/>, then run

    npm install jslint

=head1 CONFIGURATION

This plugin accepts the following configuration options:

=head2 argv

Arguments to pass to C<jslint>.

=head2 cmd

The path for the C<jslint> command. By default this is just C<jslint>, meaning
that the user's C<PATH> will be searched for the command.

=cut
