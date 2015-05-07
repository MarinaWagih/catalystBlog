package Blog::Controller::Posts;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::Posts - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Blog::Controller::Posts in Posts.');
}



=encoding utf8

=head1 AUTHOR

Marina,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
sub base :Chained('/') :PathPart('posts') :CaptureArgs(0) {
			my ($self, $c) = @_;
			# Store the ResultSet in stash so it's
			#available for other methods
			$c->stash(resultset => $c->model('DB::Post'));
			# Print a message to the debug log
			$c->log->debug('*** INSIDE BASE METHOD ***');
}
sub list :Chained('base') :PathPart('list') :Args(0) 
{
	my ($self, $c) = @_;
	$c->stash(posts => [$c->stash->{resultset}->all]);
	$c->stash(template => 'posts/list.tt');
}
=head2 form_create
Display form to collect information for posts to
create
=cut
sub form_create :Chained('base') :PathPart('create') :Args(0)
{
	my ($self, $c) = @_;
	# Set the TT template to use
	$c->stash(template => 'posts/create.tt');
}
sub form_create_do :Chained('base') :PathPart('save') :Args(0) 
{
	my ($self, $c) = @_;
	# Retrieve the values from the form
	my $title = $c->request->params->{title} || 'N/A';
	$c->log->debug($c->request->params->{title});
	my $text =$c->request->params->{text} || 'N/A';
	$c->log->debug($c->request->params->{text});
	my $userId =$c->request->params->{userId} || 'N/A';
	$c->log->debug($c->request->params->{userId});
	# Create the post
	my $Post = $c->stash->{resultset}->create({
	title => $title,
	text => $text,
	userId =>$userId
	});
	# Store new model object in stash and set template
	$c->stash(post => $Post,
	template => 'posts/show.tt');
}
sub object :Chained('base') :PathPart('id') :CaptureArgs(1) 
{
	 my ($self, $c, $id) = @_;
	 $c->stash(object => $c->stash->{resultset}->find($id));
	 if (!$c->stash->{object})
	 {
	 	die "User $id not found!" ;
	 };
	 $c->log->debug("*** INSIDE OBJECT METHOD for obj id=$id ***");
}
sub delete :Chained('object') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;
 
    # Use the book object saved by 'object' and delete it along
    # with related 'book_author' entries
    $c->stash->{object}->delete;
 
    # Set a status message to be displayed at the top of the view
    $c->stash->{status_msg} = "Post deleted.";
 
    # Forward to the list action/method in this controller
    $c->forward('list');
}
sub edit :Chained('object') :PathPart('edit') :Args(0)
{
	my ($self, $c) = @_;
	# Set the TT template to use

	$c->stash(post=> $c->stash->{object},template => 'posts/edit.tt');
}
sub update :Chained('object') :PathPart('update') :Args(0) 
{
	my ($self, $c) = @_;
	# Retrieve the values from the form
	my $title = $c->request->params->{title} || 'N/A';
	$c->log->debug($c->request->params->{title});
	my $text =$c->request->params->{text} || 'N/A';
	$c->log->debug($c->request->params->{text});
	# Create the post
	my $Post = $c->stash->{object}->update({
	title => $title,
	text => $text,
	});
	# Store new model object in stash and set template
	$c->forward('list');
}
sub show :Chained('object') :PathPart('show') :Args(0)
{
	my ($self, $c) = @_;
	# Set the TT template to use
	my $postId=$c->stash->{object}->id;
	$c->log->debug($postId);
	# my @comments=$c->model('DB::Comment')->search( { postId => $postId } );
	$c->stash(post=> $c->stash->{object},
		  comments=> [$c->model('DB::Comment')->search( { postId => $postId } )],
	     template => 'posts/show.tt');
}