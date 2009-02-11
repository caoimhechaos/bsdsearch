package Bsdprojects::Search::UTF8;

=head1 NAME

Bsdprojects::Search::UTF8 - Handle encoding of strings to UTF-8

=head1 SYNOPSIS

	use Bsdprojects::Search::UTF8;
	print u8ify("blafasel");

=head1 DESCRIPTION

C<Bsdprojects::Search::UTF8> provides methods to handle encoding of strings to UTF-8.

=cut

use Encode;
use Encode::Guess;
use strict;
use vars qw(@EXPORT @EXPORT_OK $VERSION);
use base qw(Exporter);
our $VERSION = 0.1;
our @EXPORT = qw(u8ify);

=head1 FUNCTIONS

=over 4

=item $string = u8ify($octets);

Converts the designated chain of octets to Perl's internal UTF-8
representation. Accepts UTF-8 and ISO-8859-1 input.

=cut

sub u8ify
{
	my $octets = shift;
	my $enc;
	my $ret;

	return undef unless (defined($octets));
	return $octets if (utf8::is_utf8($octets));

	$enc = guess_encoding($octets, qw(iso8859-1 utf8));

	# No exact match found, try UTF-8
	$enc = find_encoding('utf8') unless (ref($enc));

	eval {
		$ret = $enc->decode($octets, 1);
	};
	if ($@)
	{
		# Unable to decode; what now?
		utf8::decode($octets);
		return $octets;
	}

	return $ret;
}

=back

=head1 See also

For more information consult L<perlmod> and L<Encode> as well as
L<Encode::Guess>.

=head1 Author

Caoimhe Chaos <F<caoimhechaos@protonmail.com>>

=head1 Last Changed

$Date: 2007-03-27 06:59:38 $

=cut

1;
