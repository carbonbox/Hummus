use Test::More tests => 13;
use strict;
use warnings;

use DBI;
use File::Temp;
use TryCatch;
use Dancer qw//;

my $file = File::Temp::mktemp("004_model_user_XXXX");
Dancer::set db => $file;

use DBI;
my $dbh = DBI->connect("dbi:SQLite:dbname=$file", "", "");
$dbh->do(<<'SQL');
CREATE TABLE user (
  user     integer  not null  primary key autoincrement,
  email    text not null,
  password text,
  key      text,
  UNIQUE(email)
)
SQL

# general class tests
my $class = 'Hummus::Model::User';
use_ok $class;
map { can_ok $class, $_ } qw/is_password set_password register generate_key/;

# test generate key
like $class->generate_key, qr/\w{12}/, "generated a key";

# register some users
my $user1 = $class->register('foo@hi.com', 'foobar');
my $user2 = $class->register('bar@hi.com', 'boobar');
my $user3 = $class->register('baz@hi.com', 'zoobar');

# check that users are users
isa_ok($user1, $class);
isa_ok($user2, $class);
isa_ok($user3, $class);

# check the password of a user
# change it and check it again
ok $user1->is_password('foobar');
ok !$user1->is_password('foo');
$user1->set_password('foo');
ok $user1->is_password('foo');

# try to register the same user again
try {
    $class->register('foo@hi.com', 'barfoo');
}
catch ($e) {
    like $e, qr/already registered/;
}

unlink $file;
