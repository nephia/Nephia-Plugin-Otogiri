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

    my $otogiri = Otogiri->new(
        connect_info => $self->{config}->{DBI}->{connect_info},
    );
    for my $sql (@{$self->{RUN_SQL}}) {
        $otogiri->do($sql);
    }
    return $otogiri;
}

1;

__END__

=encoding utf-8

=head1 NAME

Nephia::Plugin::Otogiri - It's new $module

=head1 SYNOPSIS

    use Nephia::Plugin::Otogiri;

=head1 DESCRIPTION

Nephia::Plugin::Otogiri is ...

=head1 LICENSE

Copyright (C) papix.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

papix E<lt>mail@papix.netE<gt>

=cut

