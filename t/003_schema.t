use Test::More tests => 1;
use strict;
use warnings;

use Dancer qw//;
Dancer::set db => '/tmp/db';

my $class = 'Hummus::Schema';
use_ok $class;
