use Test::More tests => 2;
use strict;
use warnings;

use DBI;
use Dancer qw//;
my $file;

BEGIN {
$file = File::Temp::mktemp("002_index_route_XXXX");
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
}
# the order is important
use Hummus;
use Dancer::Test;

route_exists [GET => '/'], 'a route handler is defined for /';
response_status_is ['GET' => '/'], 302, 'response status is 200 for /';

unlink $file;
