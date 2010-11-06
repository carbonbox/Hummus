package Hummus::Model::User;

=head1 NAME

Hummus::Model::User - User model

=head1 SYNOPSIS



=cut

use Modern::Perl;
use Fey::ORM::Table;
use Hummus::Schema;
use Hummus::Util::KeyGen;

use constant ALREADY_REGISTERED => 'already registered';
use constant KEYGEN_FAILED      => 'key generation failed';

our $VERSION = '0.01';

my $schema = Hummus::Schema->Schema();
has_table $schema->table('user');

=head1 METHODS

=head2 is_password

  if ($user->is_password('p@ssw0rD')) { ... }

Checks if the password is correct.

=cut

sub is_password {
    my ($self, $password) = @_;
    $self->password eq crypt $password, $self->password;
}

=head1 METHODS

=head2 set_password

  $user->set_password('p@ssw0rD');

Sets the password for a user.

=cut

sub set_password {
    my ($self, $password) = @_;
    my $salt = join '', ('.','/',0..9,'A'..'Z','a'..'z')[rand 64, rand 64];
    $self->update( password => crypt($password, $salt) );
}

=head1 METHODS

=head2 register

  my $user = $class->register('tom@foo.com', 'p@ssw0rD');

Registers a new user.

=cut

sub register {
    my ($class, $email, $password) = @_;
    die ALREADY_REGISTERED if $class->new( email => $email );
    my $key  = $class->generate_key();
    my $user = $class->insert( email => $email, key => $key );
    $user->set_password($password);
    return $user;
}

=head1 METHODS

=head2 generate_key

  $key = $class->generate_key();

Generates a unique key to be used for user registration.

=cut

sub generate_key {
    my ($class) = @_;
    for (1..10) {
        my $key = Hummus::Util::KeyGen->key(12);
        return $key unless $class->new( key => $key );
    }
    die KEYGEN_FAILED;
}

1;

=head1 AUTHOR

Erik J. Sturcke

=cut
