package Hummus::Schema;

=head1 NAME

Hummus::Schema - Schema

=head1 SYNOPSIS

Creates schema that can be used with objects.

=cut

use Modern::Perl;
use Dancer qw/:syntax/;
use Fey::DBIManager::Source;
use Fey::Loader;
use Fey::ORM::Schema;

my $db     = setting 'db';
my $source = Fey::DBIManager::Source->new( dsn => "dbi:SQLite:dbname=$db" );
my $schema = Fey::Loader->new( dbh => $source->dbh() )->make_schema();

has_schema $schema;

__PACKAGE__->DBIManager()->add_source($source);

no Fey::ORM::Schema;

1;

=head1 AUTHOR

Erik J. Sturcke

=cut
