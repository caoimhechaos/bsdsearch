package Bsdprojects::Search::Schema::Keyword;

use base qw/DBIx::Class/;
use strict;
use warnings;

our $VERSION = '0.01';

=head1 NAME

Bsdprojects::Search::Schema::Keyword - BSD projects search engine keywords

=head1 SYNOPSIS

	my $website = $c->model('Bsdprojects::Search::Schema::Keyword')->find(1);
	...

=head1 DESCRIPTION

BSD projects search engine keywords

=cut

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('keywords');
__PACKAGE__->add_columns(qw/id word/);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many(sitewords => 'Bsdprojects::Search::Schema::Siteword',
	'id_keyword');

=head1 SEE ALSO

L<DBIx::Class>

=head1 AUTHOR

Tonnerre Lombard <C<tonnerre@bsdprojects.net>>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
