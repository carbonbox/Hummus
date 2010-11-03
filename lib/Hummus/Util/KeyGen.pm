package Hummus::Util::KeyGen;

=head1 NAME

Hummus::Util::KeyGen - Key generator

=head1 SYNOPSIS

  use Hummus::Util::KeyGen;

  my $key = Hummus::Util::KeyGen->key(10);

=cut

use Modern::Perl;

our $VERSION = '0.01';

=head1 METHODS

=head2 key

   my $key = Hummus::Util::KeyGen->key(10);

Generates a key of letters and numbers of the specified length.

=cut

sub key {
    my ($class, $length) = @_;
    my @set = ('a'..'z','A'..'Z',0..9);
    return join "", map { $set[ int rand scalar @set ] } (1..$length);
}

1;

=head1 AUTHOR

Erik J. Sturcke

=cut
