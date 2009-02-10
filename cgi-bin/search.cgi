#!/usr/pkg/bin/perl -w
#
# (c) 2007, Tonnerre Lombard <tonnerre@thebsh.sygroup.ch>,
#	    SyGroup GmbH Reinach. All rights reserved.
#
# Redistribution and use  in source and binary forms,  with or without
# modification, are  permitted provided that  the following conditions
# are met:
#
# * Redistributions  of source  code must  retain the  above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form  must reproduce the above copyright
#   notice, this  list of conditions  and the following  disclaimer in
#   the  documentation  and/or   other  materials  provided  with  the
#   distribution.
# * Neither  the  name  of  the  SyGroup  GmbH nor  the  name  of  its
#   contributors may  be used to  endorse or promote  products derived
#   from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED  BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A  PARTICULAR PURPOSE ARE DISCLAIMED. IN  NO EVENT SHALL
# THE  COPYRIGHT  OWNER OR  CONTRIBUTORS  BE  LIABLE  FOR ANY  DIRECT,
# INDIRECT, INCIDENTAL,  SPECIAL, EXEMPLARY, OR  CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT  NOT LIMITED TO, PROCUREMENT OF  SUBSTITUTE GOODS OR
# SERVICES; LOSS  OF USE, DATA, OR PROFITS;  OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY  THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT  LIABILITY,  OR  TORT  (INCLUDING  NEGLIGENCE  OR  OTHERWISE)
# ARISING IN ANY WAY OUT OF  THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
#

use lib qw(/usr/home/tonnerre/src/search/lib);
use CGI qw/:standard/;
use CGI::Carp 'fatalsToBrowser';
use DBI;
use HTML::Entities qw(encode_entities_numeric);
use Bsdprojects::Search::Schema;
use Template;
use Time::HiRes qw(time);

my @results = ();

$CGI::POST_MAX = 1024;
$CGI::DISABLE_UPLOADS = 1;

my $tt = new Template({
	INTERPOLATE =>	1,
	POST_CHOMP =>	1,
	EVAL_PERL =>	1
});
my $query = param('q');
my $encquery = $query;
my $q = escapeHTML($query);
my $schema = Bsdprojects::Search::Schema->connect(
	"dbi:Pg:dbname=searchengine", "", "", {}
) or die('Unable to connect to database');
my @iwords = split(/\s+/, lc($query));
my @words;
my @sites;
my $offset = int(param('p'));
my $npages = 0;
my $nresults = 0;
my @pages;
my $time;
my $showtime = 0;
my $nsites;

$encquery =~ s/([^a-zA-Z0-9])/sprintf("%%%02X",ord($1))/eg;

foreach my $iword (@iwords)
{
	if ($iword =~ /^site:(.*)$/)
	{
		push(@sites, '[[:alnum:]]+://' . $1 . '/%');
		push(@sites, '[[:alnum:]]+://[^/]+.' . $1 . '/%');
		push(@sites, '[[:alnum:]]+://' . $1);
		push(@sites, '[[:alnum:]]+://[^/]+.' . $1);
	}
	else
	{
		$iword =~ s/\W//g;
		push(@words, $iword) if (length($iword));
	}
}

if (@words)
{
	# Gather keywords
	my @keywords = $schema->resultset('Keyword')->search({
		word => { -in => [@words]}
	})->get_column('id')->all;

	if (@keywords)
	{
		my $conds = {
			id_keyword =>	{ -in =>	[@keywords] }
		};
		$time = time();
		$conds->{'website.url'} = { -similar_to => [@sites] }
			if (@sites);

		# Look at the amount of results to be gathered
		$nresults = $schema->resultset('Siteword')->search($conds, {
			select => { count => { distinct => 'id_site' } },
			join => [qw/website/],
			as => 'count'
		})->next->get_column('count');
		$npages = int($nresults / 10);

		# Now, gather the results
		foreach my $res ($schema->resultset('Siteword')->search($conds,
		{
			select => [\'COUNT(*) * SUM(ratio) AS relevance',
				'id_site'],
			join =>		[qw/website/],
			order_by =>	'relevance desc',
			group_by =>	'id_site',
			offset =>	$offset * 10,
			rows =>		10
		}))
		{
			my $site = $schema->resultset('Website')->
				find($res->id_site);
			my $url = $site->url;
			my $title = $site->title;
			my $stext = $site->abstract;
			my $hres = {
				url =>	$url,
				text => ''
			};
			my @swords;
			my @mwords;
			my $last_word_shown = 3;
			my $nexamples = 0;
			my $starttime = time();

			utf8::decode($title);
			utf8::decode($stext);

			$title = $url unless (length($title));

			if (length($title) > 76)
			{
				my $idx = rindex($title, ' ', 76);
				$idx = 76 if ($idx == -1);
				$title = substr($title, 0, $idx);
				$title .= ' ...';
			}

			@swords = split(/\s+/, $stext);

			for (my $i = 0; $i < scalar(@swords) &&
				($nexamples < 5 || $last_word_shown < 5); $i++)
			{
				my $word = $swords[$i];
				$word =~ s/\W//g;

				push(@mwords, {
					conv =>	lc($word),
					show =>	scalar(grep { $word =~ /$_/i }
						@words) != 0
				});

				if ($mwords[$i]->{show})
				{
					my $word = encode_entities_numeric(
						$swords[$i]);

					foreach my $_w (@words)
					{
						my $w = encode_entities_numeric(
							$_w);
						$word =~ s/($w)/<b>$1<\/b>/ig;
					}
					$mwords[$i]->{orig} = $word;

					for (my $j = $i - 3; $j < $i; $j++)
					{
						if ($j >= 0)
						{
							$mwords[$j]->{show} = 1;
						}
					}
					$nexamples++;
					$last_word_shown = -1
						if ($nexamples < 5);
				}
				else
				{
					if ($i == 0)
					{
						$hres->{text} = '... ';
					}

					$mwords[$i]->{orig} =
						encode_entities_numeric(
						$swords[$i]);
					$mwords[$i]->{show} =
						$last_word_shown < 3;
				}

				$last_word_shown++;
			}

			$last_word_shown = 0;

			for (my $i = 0; $i < scalar(@mwords); $i++)
			{
				if ($mwords[$i]->{show})
				{
					$hres->{text} .= $mwords[$i]->{orig} .
						' ';
				}
				elsif ($last_word_shown)
				{
					$hres->{text} .= '...';
				}

				$last_word_shown = $mwords[$i]->{show};
			}

			encode_entities_numeric($title);
			encode_entities_numeric($url);

			foreach my $_word (@words)
			{
				my $word = encode_entities_numeric($_word);
				$title =~ s/($word)/<b>$1<\/b>/ig;
				$url =~ s/($word)/<b>$1<\/b>/ig;
			}

			$hres->{title} = $title;
			$hres->{showurl} = $url;
			push(@results, $hres);

			$showtime += time() - $starttime;
		}

		$time -= time();
	}
}
else
{
	$nsites = $schema->resultset('Website')->search({}, {
		select => { count => '*' },
		as => 'count'
	})->next->get_column('count');
}

for ($i = ($offset - 10 <= 0 ? 0 : $offset - 10);
	$i <= ($offset + 10 > $npages ? $npages : $offset + 10); $i++)
{
	push(@pages, $i);
}

print(header);
$tt->process('search.html', {str => $q, results => \@results, page => $offset,
	pages => \@pages, nresults => $nresults, encquery => $encquery,
	hasmore => ($npages > $offset + 5), time => sprintf("%.02f", -$time),
	showtime => sprintf("%.02f", $showtime), nsites => $nsites})
	or die($tt->error());
exit(0);
