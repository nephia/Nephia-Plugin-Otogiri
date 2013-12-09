[![Build Status](https://travis-ci.org/nephia/Nephia-Plugin-Otogiri.png?branch=master)](https://travis-ci.org/nephia/Nephia-Plugin-Otogiri) [![Coverage Status](https://coveralls.io/repos/nephia/Nephia-Plugin-Otogiri/badge.png?branch=master)](https://coveralls.io/r/nephia/Nephia-Plugin-Otogiri?branch=master)
# NAME

Nephia::Plugin::Otogiri - Quick hack database plugin for Nephia

# SYNOPSIS

    package MyApp;
    use Nephia plugins => ['Otogiri'];
    app {
        database_do <<'EOF';
    CREATE TABLE member (
        ...
    );
    EOF
        db->insert(member => {...});
    };

# DESCRIPTION

Nephia::Plugin::Otogiri is a plugin for [Nephia](http://search.cpan.org/perldoc?Nephia). It provides DSL for accessing to database.

# DSL

## database\_do

    database_do $sql;

Execute specified SQL.

## db

    my $db = db;

Returns an [Otogiri](http://search.cpan.org/perldoc?Otogiri) object.

# LICENSE

Copyright (C) papix.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[Otogiri](http://search.cpan.org/perldoc?Otogiri)

# AUTHOR

papix <mail@papix.net>
