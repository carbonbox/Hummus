use Test::More tests => 1;
use strict;
use warnings;

use DBI;
use Dancer qw//;

my $file = File::Temp::mktemp("001_base_XXXX");
Dancer::set db => $file;

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

use_ok 'Hummus';

unlink $file;
