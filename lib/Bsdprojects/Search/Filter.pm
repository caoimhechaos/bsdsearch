package Bsdprojects::Search::Filter;

=head1 NAME

Bsdprojects::Search::Filter - Interface for BSDprojects search engine
	content type filters

=head1 SYNOPSIS

	use Bsdprojects::Search::Filter::MimeType;

	$text = Bsdprojects::Search::Filter::::MimeType->parse($content);

=head1 DESCRIPTION

C<Bsdprojects::Search::Filter> provides an interface to the different
content types of the BSD projects search engine.

=cut

use strict;
our $VERSION = 0.1;

=head1 FUNCTIONS

=over 4

=item $hashref = Bsdprojects::Search::Filter::::MimeType->parse($content);

Returns the plain text contained in the content C<$content>.

=cut

sub parse
{
	return '';
}

=item $aryref = Bsdprojects::Search::Filter::::MimeType->refs($content, $baseurl);

Returns a reference to an array of URLs referenced by the document

=cut

sub refs
{
	return [];
}

=item $str = Bsdprojects::Search::Filter::::MimeType->title($content);

Returns the title of the document

=cut

sub title
{
	return '';
}

=back

=head1 See also

Whereever

=head1 Author

Caoimhe Chaos <F<caoimhechaos@protonmail.com>>

=cut

1;
