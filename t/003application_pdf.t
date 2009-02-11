#!/usr/pkg/bin/perl -w

use strict;
use warnings;

use Bsdprojects::Search::Filter;
use Bsdprojects::Search::Filter::ApplicationPdf;
use Test::More tests => 1;
use IO::File;

eval { no warnings; require Test::LongString; Test::LongString->import(max => 100); $Test::LongString::Context = 50; };
*{'main::is_string'} = \&main::is if $@;

my $f = {};
my $p = __FILE__;
my $fp;
my $cnt;

bless($f, 'Bsdprojects::Search::Filter::ApplicationPdf');

$p =~ s/\.t$/.in/;
$fp = IO::File->new($p, 'r');
$fp->read($cnt, -s $p);
$fp->close();

#is($f->title($cnt), 'How I met whatever it was I met', 'application/pdf title');
is(substr($f->parse($cnt), 0, 40), 'VMware Virtual Machine Importer User\'s M', 'application/pdf abstract');
#is(join('|', @{$f->refs($cnt)}), 'http://www.sygroup.ch/|http://www.bsdprojects.net/', 'application/pdf refs');

exit(0);
