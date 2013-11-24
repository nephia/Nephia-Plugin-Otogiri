package Nephia::Plugin::Otogiri;
use 5.008005;
use strict;
use warnings;
use parent 'Nephia::Plugin';
use Otogiri;

our $VERSION = "0.01";

sub new {
    my ($class, %opts) = @_;
    my $self = $class->SUPER::new(%opts);

    delete $opts{app};
    $self->{otogiri_opts} = \%opts;
    $self->{RUN_SQL} = [];
    return $self;
}

sub exports { qw/ database_do db / }

sub database_do {
    my ($self, $context) = @_;
    $self->{config} = $context->get('config'); 
   
    return sub {
        my $sql = shift;
        push @{$self->{RUN_SQL}}, $sql;
    }
}

sub db {
    my ($self, $context) = @_;
    $self->{config} = $context->get('config'); 

    return sub {
        $self->{otogiri} ||= $self->_create_otogiri();
    }
}

sub _create_otogiri {
    my ($self) = @_;

    $self->{otogiri_opts}->{connect_info} ||= $self->{config}->{DBI}->{connect_info};
    my $otogiri = Otogiri->new( %{$self->{otogiri_opts}} );

    for my $sql (@{$self->{RUN_SQL}}) {
        $otogiri->do($sql);
    }
    return $otogiri;
}

1;

__END__

=encoding utf-8

=head1 NAME

Nephia::Plugin::Otogiri - Quick hack database plugin for Nephia

=head1 SYNOPSIS

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

=head1 DESCRIPTION

Nephia::Plugin::Otogiri is a plugin for L<Nephia>. It provides DSL for accessing to database.

=head1 DSL

=head2 database_do

    database_do $sql;

Execute specified SQL.

=head2 db

    my $db = db;

Returns an L<Otogiri> object.

=head1 LICENSE

Copyright (C) papix.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Otogiri>

=head1 AUTHOR

papix E<lt>mail@papix.netE<gt>

=cut

