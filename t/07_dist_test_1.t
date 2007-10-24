#!/usr/bin/perl

use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use Test::More tests => 9;
use File::Path ();
use File::Spec::Functions ':ALL';
use_ok( 't::lib::Test1' );

sub remake_path {
	my $dir = rel2abs( catdir( curdir(), @_ ) );
	File::Remove::remove( \1, $dir ) if -d $dir;
	File::Path::mkpath( $dir );
	ok( -d $dir, 'Created ' . $dir );
	return $dir;
}

# Prepare the test directories
my $output_dir   = remake_path( 't', 'data', 'output'   );
my $image_dir    = remake_path( 't', 'data', 'image'    );
my $source_dir   = remake_path( 't', 'data', 'source'   );
my $download_dir = remake_path( 't', 'data', 'download' );
my $build_dir    = remake_path( 't', 'data', 'build'    );

# Create the dist object
my $dist = t::lib::Test1->new(
	output_dir   => $output_dir,
	image_dir    => $image_dir,
	source_dir   => $source_dir,
	download_dir => $download_dir,
	build_dir    => $build_dir,
);
isa_ok( $dist, 't::lib::Test1' );

# Run the dist object, and ensure everything we expect was created
ok( $dist->run, '->run ok' );
ok( -f catfile( 't', 'data', 'image', 'dmake', 'bin', 'dmake.exe' ), 'Found dmake.exe' );
ok( -f catfile( 't', 'data', 'image', 'dmake', 'bin', 'startup', 'Makefile.in' ), 'Found startup' );
