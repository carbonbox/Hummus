use Test::More tests => 202;
use strict;
use warnings;

my $class = 'Hummus::Util::KeyGen';
use_ok $class;

# test key generation
can_ok $class, 'key';
for my $i (0..99) {
    my $key = $class->key($i);
    is length $key, $i, "key length $i";
    like $key, qr/^\w*$/, "key character set";
}
