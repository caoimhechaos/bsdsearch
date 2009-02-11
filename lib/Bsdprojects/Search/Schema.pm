package Bsdprojects::Search::Schema;

use base qw/DBIx::Class::Schema/;
use strict;
use warnings;

our $VERSION = '0.01';

=head1 NAME

Bsdprojects::Search::Schema - BSD projects search database adapter

=head1 SYNOPSIS

	package Bsdprojects::Search::Schema;
	use base qw(DBIx::Class);

	__PACKAGE__->load_components(qw/Core/);
	__PACKAGE__->table('websites');

	...

=head1 DESCRIPTION

Base class for access to the BSD search engine database

=cut

__PACKAGE__->load_classes(qw/Credential Website Keyword Siteword Linksto/);

=had1 SEE ALSO

L<DBIx::Class>

=head1 AUTHOR

Tonnerre Lombard <C<tonnerre@bsdprojects.net>>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
