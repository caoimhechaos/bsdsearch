package Bsdprojects::Search::Filter::TextPlain;

=head1 NAME

Bsdprojects::Search::Filter::TextPlain - BSDprojects search engine content
	type filter for text/plain

=head1 SYNOPSIS

	use Bsdprojects::Search::Filter::TextPlain;

	$text = Bsdprojects::Search::Filter::::TextPlain->parse($content);

=head1 DESCRIPTION

C<Bsdprojects::Search::Filter::TextPlain> provides a content type filter
for text/plain.

=cut

use strict;
use utf8;
our $VERSION = 0.1;

use base qw(Bsdprojects::Search::Filter);
use Bsdprojects::Search::UTF8;
use HTML::Parser;

=head1 FUNCTIONS

=over 4

=item $hashref = Bsdprojects::Search::Filter::TextPlain->parse($content);

=cut

sub parse
{
	my ($self, $input) = @_;
	$input = u8ify($input);
	$input =~ s/\s+/ /g;
	return $input;
}

=item $str = Bsdprojects::Search::Filter::TextPlain->title($input);

=cut

sub title
{
	my ($self, $input) = @_;
	$input = u8ify($input);
	my @lines = split(/[\r\n]+/, $input);
	return shift(@lines);
}

=item $aryref = Bsdprojects::Search::Filter::TextPlain->refs($input, $baseurl);

=cut

sub refs
{
	my ($self, $input, $basehref) = @_;
	my @refs;
	$input = u8ify($input);
	$input =~ s/(?:^|\s|\<|\<URL:)((?:https?|ftp):\/\/[\w\.\+\-\/]+)(?:\s|\>|$)/push(@refs,$1)/eg;
	return \@refs;
}

=back

=head1 See also

C<Bsdprojects::Search::Filter>

=head1 Author

Caoimhe Chaos <F<caoimhechaos@protonmail.com>>

=cut

1;
