package Blog::Controller::Comment;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::Comment - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut
sub base :Chained('/') :PathPart('comments') :CaptureArgs(0) {
			my ($self, $c) = @_;
			# Store the ResultSet in stash so it's
			#available for other methods
			$c->stash(resultset => $c->model('DB::Comment'));
			# Print a message to the debug log
			$c->log->debug('*** INSIDE BASE METHOD ***');
}
# sub index :Path :Args(0) {
#     my ( $self, $c ) = @_;

#     $c->response->body('Matched Blog::Controller::Comment in Comment.');
# }

sub save :Chained('base') :PathPart('save') :Args(0) 
{
	my ($self, $c) = @_;
	# Retrieve the values from the form
	my $text =$c->request->params->{text} || 'N/A';
	$c->log->debug($c->request->params->{text});
	# Create the post
	my $postId=$c->request->params->{postId};
	$c->log->debug($postId);

	my $userId=$c->request->params->{userId};
	$c->log->debug($userId);

	my $comment = $c->stash->{resultset}->create({
												text => $text,
												postId=> $postId,
												userId=> $userId,
												});
	# Store new model object in stash and set template
 	$c->response->redirect($c->uri_for( $c->controller('Posts')->action_for('list')));
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
