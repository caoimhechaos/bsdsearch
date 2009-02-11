package Bsdprojects::Search::Filter::TextHtml;

=head1 NAME

Bsdprojects::Search::Filter::TextHtml - BSDprojects search engine content
	type filter for text/html

=head1 SYNOPSIS

	use Bsdprojects::Search::Filter::TextHtml;

	$text = Bsdprojects::Search::Filter::::TextHtml->parse($content);

=head1 DESCRIPTION

C<Bsdprojects::Search::Filter::TextHtml> provides a content type filter
for text/html.

=cut

use strict;
use utf8;
our $VERSION = 0.1;

use base qw(Bsdprojects::Search::Filter);
use Bsdprojects::Search::UTF8;
use HTML::Parser;

=head1 FUNCTIONS

=over 4

=item $hashref = Bsdprojects::Search::Filter::TextHtml->parse($content);

=cut

sub parse
{
	my ($self, $input) = @_;
	my $output = '';
	my %inside;
	my $p = new HTML::Parser(api_version => 3,
		handlers => [
			start => [ sub {
				my ($tag) = @_;
				$inside{$tag} += 1;
			}, "tagname" ],
			end => [ sub {
				my ($tag) = @_;
				$inside{$tag} -= 1;
			}, "tagname" ],
			text => [ sub {
				my $text = shift;
				return if ($inside{script} || $inside{style});
				$output .= $text;
			}, "dtext" ]
		],
		marked_sections => 1);
	$p->parse(u8ify($input));
	$output =~ s/\s+/ /g;
	return $output;
}

=item $str = Bsdprojects::Search::Filter::TextHtml->title($input);

=cut

sub title
{
	my ($self, $input) = @_;
	my $output = '';
	my $p = new HTML::Parser(api_version => 3,
		start_h => [ sub {
			my $self = shift;
			$self->handler(text => sub { $output = $_[0]; }, "dtext");
			$self->handler(end => "eof", "self");
		}, "self"],
		report_tags =>	['title']);
	$p->parse(u8ify($input));
	return $output;
}

=item $aryref = Bsdprojects::Search::Filter::TextHtml->refs($input, $baseurl);

=cut

sub refs
{
	my ($self, $input, $basehref) = @_;
	my @refs;
	my $baseurl = new URI($basehref);
	my $p = new HTML::Parser(api_version => 3,
		start_h => [ sub {
			my ($tagname, $attr) = @_;
			my $href;
			$href = $attr->{href}
				if ($tagname eq 'a' &&
				    defined($attr->{href}));
			$href = $attr->{src}
				if (($tagname eq 'frame' ||
				     $tagname eq 'iframe') &&
				    defined($attr->{src}));
			if (defined($href))
			{
				my $uri = new URI($href);
				my $abs = $uri->abs($baseurl);
				push(@refs, $abs->as_string);
			}
		}, "tagname,attr"],
		report_tags =>	['a', 'frame', 'iframe']);
	$p->parse(u8ify($input));
	return \@refs;
}

=back

=head1 See also

C<Bsdprojects::Search::Filter>

=head1 Author

Caoimhe Chaos <F<caoimhechaos@protonmail.com>>

=cut

1;
