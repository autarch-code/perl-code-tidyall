package Code::TidyAll::Util;

# These are loaded aned exported purely for backwards compat since some of Jon
# Swartz's plugins use these in their tests :(
use File::Basename qw(dirname);
use File::Path qw(mkpath);
use File::Slurp::Tiny qw(read_file write_file);

use Guard;
use Path::Tiny qw(cwd tempdir);
use Try::Tiny;
use strict;
use warnings;
use base qw(Exporter);

our $VERSION = '0.53';

our @EXPORT_OK = qw(can_load pushd tempdir_simple dirname mkpath read_file write_file);

sub can_load {

    # Load $class_name if possible. Return 1 if successful, 0 if it could not be
    # found, and rethrow load error (other than not found).
    #
    my ($class_name) = @_;

    my $result;
    try {
        eval "require $class_name";    ## no critic
        die $@ if $@;
        $result = 1;
    }
    catch {
        if ( /Can\'t locate .* in \@INC/ && !/Compilation failed/ ) {
            $result = 0;
        }
        else {
            die $_;
        }
    };
    return $result;
}

sub tempdir_simple {
    my $template = shift || 'Code-TidyAll-XXXX';
    my $tempdir = tempdir( $template, CLEANUP => 1 );

    # This is a terrible hack to work around the fact that calling ->realpath
    # loses the File::Temp::Dir object stored in the $root_dir object. We
    # stick it back in $real_dir so it doesn't get garbage collected, which
    # deletes the temp dir.
    my $real_dir = $tempdir->realpath;
    $real_dir->[5] = $tempdir->[5];

    return $real_dir;
}

sub pushd {
    my ($dir) = @_;

    my $cwd = cwd();
    chdir($dir);
    return guard { chdir($cwd) };
}

1;
