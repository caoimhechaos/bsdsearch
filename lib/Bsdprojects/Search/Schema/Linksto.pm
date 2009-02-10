package Bsdprojects::Search::Schema::Linksto;

use base qw/DBIx::Class/;
use strict;
use warnings;

our $VERSION = '0.01';

=head1 NAME

Bsdprojects::Search::Schema::Linksto - BSD projects search engine inter-site link mappings

=head1 SYNOPSIS

	my $website = $c->model('Bsdprojects::Search::Schema::Linksto')->find(1);
	...

=head1 DESCRIPTION

BSD projects search engine inter-site link mappings

=cut

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('linksto');
__PACKAGE__->add_columns(qw/id_from id_to/);
__PACKAGE__->set_primary_key(qw/id_from id_to/);
__PACKAGE__->belongs_to(from => 'Bsdprojects::Search::Schema::Website', 'id_from');
__PACKAGE__->belongs_to(to => 'Bsdprojects::Search::Schema::Website', 'id_to');

=head1 SEE ALSO

L<DBIx::Class>

=head1 AUTHOR

Caoimhe Chaos <C<caoimhechaos@protonmail.com>>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
