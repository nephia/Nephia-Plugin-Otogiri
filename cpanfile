requires 'perl', '5.008001';
requires 'Nephia', '0.80';
requires 'Otogiri';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Plack::Test';
    requires 'Plack::Builder';
    requires 'HTTP::Request::Common';
};

