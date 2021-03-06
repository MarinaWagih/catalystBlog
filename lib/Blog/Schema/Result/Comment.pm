use utf8;
package Blog::Schema::Result::Comment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Blog::Schema::Result::Comment

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<comments>

=cut

__PACKAGE__->table("comments");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 text

  data_type: 'text'
  is_nullable: 0

=head2 postid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 userid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "text",
  { data_type => "text", is_nullable => 0 },
  "postId",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "userId",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 postid

Type: belongs_to

Related object: L<Blog::Schema::Result::Post>

=cut

__PACKAGE__->belongs_to(
  "postid",
  "Blog::Schema::Result::Post",
  { id => "postid" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 userid

Type: belongs_to

Related object: L<Blog::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "userid",
  "Blog::Schema::Result::User",
  { id => "userid" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-05-07 14:40:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yLiUCGfKhHE16kJZ7bCo4w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
