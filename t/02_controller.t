use strict;
use warnings;
use utf8;
use Test::More;
use Plack::Test;
use Plack::Builder;
use HTTP::Request::Common;

{
    package MyApp;
    use Nephia plugins => [qw/ Otogiri Dispatch JSON /];
    
    database_do <<'SQL';
CREATE TABLE IF NOT EXISTS `person` (
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    age  INTEGER
);
SQL
    
    database_do <<'SQL';
INSERT INTO "person"
    ("id", "name", "age")
    VALUES (1, "bob", "20");
SQL

    app {
        get '/person/:id' => sub {
            my $id = path_param('id');
            return [ 422 ] unless $id =~ /^\d+$/;

            my $row = db->single('person', { id => $id });
            return [ 404 ] unless $row;

            json_res {
                id   => $id,
                name => $row->{name},
                age  => $row->{age},
            };
        };

        post '/register' => sub {
            my $name = param->{name};
            return [ 422 ] unless $name;
            my $age = param->{age};
            return [ 422 ] unless $age =~ /^\d+$/;

            my $row = db->insert('person', { name => $name, age => $age });

            json_res {
                id   => $row->{id},
                name => $name,
                age  => $age,
            };
        };
    };
}

my $app = builder {
    MyApp->run(
        DBI => {
            connect_info => [ 'dbi:SQLite:dbname=:memory:' ],
        }
    );
};

test_psgi
    app => $app,
    client => sub {
        my $cb = shift;

        subtest 'DB get' => sub {
            my $res = $cb->(GET '/person/1');
            is $res->code, 200;
            is $res->content_type, 'application/json';
            my $json = JSON->new->utf8->decode( $res->content );
            is_deeply $json, {
                id   => 1,
                name => 'bob',
                age  => 20,
            };
        };

        subtest 'DB post' => sub {
            my %opts = @_;
            my $res = $cb->(POST '/register', [
                name => 'alice',
                age  => 18,
            ]);
            is $res->code, 200;
            is $res->content_type, 'application/json';
            my $json = JSON->new->utf8->decode( $res->content );
            is_deeply $json, {
                id   => 2,
                name => 'alice',
                age  => 18,
            };
        };
    };

done_testing;
