use strict;
use warnings;
use utf8;

use Test::More;
use Nephia::Core;

subtest 'use and new' => sub {
    eval 'use Nephia::Plugin::Otogiri';
    pass;

    my $otogiri = Nephia::Plugin::Otogiri->new;
    isa_ok $otogiri, 'Nephia::Plugin::Otogiri';
};

done_testing;
