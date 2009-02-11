package Bsdprojects::Search::Filter::ApplicationPdf;

=head1 NAME

Bsdprojects::Search::Filter::ApplicationPdf - BSDprojects search engine content
	type filter for application/pdf

=head1 SYNOPSIS

	use Bsdprojects::Search::Filter::ApplicationPdf;

	$text = Bsdprojects::Search::Filter::::ApplicationPdf->parse($content);

=head1 DESCRIPTION

C<Bsdprojects::Search::Filter::ApplicationPdf> provides a content type filter
for application/pdf.

=cut

use strict;
use utf8;
use File::Temp;
our $VERSION = 0.1;

use base qw(Bsdprojects::Search::Filter::TextPlain);
use HTML::Parser;

=head1 FUNCTIONS

=over 4

=item $hashref = Bsdprojects::Search::Filter::ApplicationPdf->parse($content);

=cut

sub parse
{
	my ($self, $input) = @_;
	my $output = '';
	my $pdfp = File::Temp->new(SUFFIX => '.pdf');
	my $_txtp = File::Temp->new(SUFFIX => '.txt');
	my $txtp;
	my $progp;

	$_txtp->close();
	$pdfp->write($input, length($input));
	$pdfp->close();

	open($progp, '-|', 'pdftotext', $pdfp->filename, $_txtp->filename) or
		die('Unable to open pdftotext: ' . $!);
	until ($progp->eof())
	{
		my $buf = '';

		die('Unable to read pdftotext output: ' . $!)
			unless ($progp->read($buf, 16384));

		$output .= $buf;
	}
	close($progp);

	die($output) if ($?);	# Parent should catch exceptions.

	$output = '';

	$txtp = IO::File->new($_txtp->filename, 'r') or
		die('Unable to open temporary file ' . $_txtp->filename . $!);
	until ($txtp->eof())
	{
		my $buf = '';

		die('Unable to read from ' . $txtp->filename . ': ' . $!)
			unless ($txtp->read($buf, 16384));

		$output .= $buf;
	}
	$txtp->close();

	return $self->SUPER::parse($output);
}

=item $str = Bsdprojects::Search::Filter::ApplicationPdf->title($input);

=cut

sub title
{
	my ($self, $input) = @_;
	my $output = '';
	# FIXME
	return $output;
}

=item $aryref = Bsdprojects::Search::Filter::ApplicationPdf->refs($input, $baseurl);

=cut

sub refs
{
	my ($self, $input, $basehref) = @_;
	# FIXME
	return [];
}

=back

=head1 See also

C<Bsdprojects::Search::Filter>

=head1 Author

Tonnerre Lombard <F<tonnerre@bsdprojects.net>>

=cut

1;
