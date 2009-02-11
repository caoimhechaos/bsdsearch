package Bsdprojects::Search::Schema::Credential;

use base qw/DBIx::Class/;
use strict;
use warnings;

our $VERSION = '0.01';

=head1 NAME

Bsdprojects::Search::Schema::Credential - BSD projects search engine remote credentials

=head1 SYNOPSIS

	my $website = $c->model('Bsdprojects::Search::Schema::Credential')->find(1);
	...

=head1 DESCRIPTION

BSD projects search engine remote credentials

=cut

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('authinfo');
__PACKAGE__->add_columns(qw/id url userid password realm userparm passparm/);
__PACKAGE__->set_primary_key(qw/id/);

=head1 SEE ALSO

L<DBIx::Class>

=head1 AUTHOR

Caoimhe Chaos <C<caoimhechaos@protonmail.com>>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
