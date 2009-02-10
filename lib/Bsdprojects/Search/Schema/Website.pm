package Bsdprojects::Search::Schema::Website;

use base qw/DBIx::Class/;
use strict;
use warnings;

our $VERSION = '0.01';

=head1 NAME

Bsdprojects::Search::Schema::Website - BSD projects search engine web sites

=head1 SYNOPSIS

	my $website = $c->model('Bsdprojects::Search::Schema::Website')->find(1);
	...

=head1 DESCRIPTION

BSD projects search engine web sites

=cut

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('websites');
__PACKAGE__->add_columns(qw/id url title abstract lastindex failed authority spamminess/);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many(sitewords => 'Bsdprojects::Search::Schema::Siteword',
	'id_site');

=head1 SEE ALSO

L<DBIx::Class>

=head1 AUTHOR

Caoimhe Chaos <C<caoimhechaos@protonmail.com>>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
