#!/usr/bin/perl

use Test::More tests => 2;

use Namespace::Pollute qw(-verbose basic Carp);
ok( say 'hi' );
ok( carp 'ho' );

