package Bsdprojects::Search::Schema::Siteword;

use base qw/DBIx::Class/;
use strict;
use warnings;

our $VERSION = '0.01';

=head1 NAME

Bsdprojects::Search::Schema::Siteword - BSD projects search engine keyword/site map

=head1 SYNOPSIS

	my $website = $c->model('Bsdprojects::Search::Schema::Siteword')->find(1);
	...

=head1 DESCRIPTION

BSD projects search engine keyword/site map

=cut

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('sitewords');
__PACKAGE__->add_columns(qw/id_site id_keyword count ratio/);
__PACKAGE__->set_primary_key(qw/id_site id_keyword/);
__PACKAGE__->belongs_to(keyword => 'Bsdprojects::Search::Schema::Keyword', 'id_keyword');
__PACKAGE__->belongs_to(website => 'Bsdprojects::Search::Schema::Website', 'id_site');

=head1 SEE ALSO

L<DBIx::Class>

=head1 AUTHOR

Caoimhe Chaos <C<caoimhechaos@protonmail.com>>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
