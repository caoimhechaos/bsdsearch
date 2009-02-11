#!/usr/pkg/bin/perl -w

use strict;
use warnings;

use Bsdprojects::Search::Filter;
use Bsdprojects::Search::Filter::TextPlain;
use Test::More tests => 3;
use IO::File;

eval { no warnings; require Test::LongString; Test::LongString->import(max => 100); $Test::LongString::Context = 50; };
*{'main::is_string'} = \&main::is if $@;

my $f = {};
my $p = __FILE__;
my $fp;
my $cnt;

bless($f, 'Bsdprojects::Search::Filter::TextPlain');

$p =~ s/\.t$/.in/;
$fp = IO::File->new($p, 'r');
$fp->read($cnt, -s $p);
$fp->close();

is($f->title($cnt), 'How I met whatever it was I met', 'text/plain title');
is(substr($f->parse($cnt), 0, 40), 'How I met whatever it was I met ========', 'text/plain abstract');
is(join('|', @{$f->refs($cnt)}), 'http://www.sygroup.ch/|http://www.bsdprojects.net/', 'text/plain refs');

exit(0);
