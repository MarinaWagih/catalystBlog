package Blog::Controller::Users;
use Moose;
use namespace::autoclean;
use Digest::MD5;
BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::Users - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Blog::Controller::Users in Users.');
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
=head2 list
Fetch all users and pass to the view in
stash to be displayed
=cut
sub base :Chained('/') :PathPart('users') :CaptureArgs(0) {
			my ($self, $c) = @_;
			# Store the ResultSet in stash so it's
			#available for other methods
			$c->stash(resultset => $c->model('DB::User'));
			# Print a message to the debug log
			$c->log->debug('*** INSIDE BASE METHOD ***');
}
sub list :Chained('base') :PathPart('list') :Args(0) 
{
	my ($self, $c) = @_;
	$c->stash(users => [$c->stash->{resultset}->all]);
	$c->stash(template => 'users/list.tt');
}
=head2 form_create
Display form to collect information for user to
create
=cut
sub form_create :Chained('base') :PathPart('create') :Args(0)
{
	my ($self, $c) = @_;
	# Set the TT template to use
	$c->stash(template => 'users/create.tt');
}

=head2 form_create_do
Take information from form and add to database
=cut
sub form_create_do :Chained('base') :PathPart('save') :Args(0) 
{
	my ($self, $c) = @_;
	# Retrieve the values from the form
	my $username = $c->request->params->{username} || 'N/A';
	$c->log->debug($c->request->params->{username});
	my $email = $c->request->params->{email} || 'N/A';
	$c->log->debug($c->request->params->{email});
	my $password= $c->request->params->{password} || 'N/A';
	$c->log->debug($c->request->params->{password});
	my $fname =$c->request->params->{first_name} || 'N/A';
	$c->log->debug($c->request->params->{first_name});
	my $lname =$c->request->params->{last_name} || 'N/A';
	$c->log->debug($c->request->params->{last_name});
	# Create the user
	my $user = $c->stash->{resultset}->create({
	username => $username,
	email => $email,
	password => Digest::MD5::md5_hex($password),
	first_name => $fname,
	last_name => $lname});
	# Store new model object in stash and set template
	$c->stash(user => $user,
	template => 'users/show.tt');
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
    $c->stash->{status_msg} = "User deleted.";
 
    # Forward to the list action/method in this controller
    $c->forward('list');
}
sub edit :Chained('object') :PathPart('edit') :Args(0)
{
	my ($self, $c) = @_;
	# Set the TT template to use

	$c->stash(user=> $c->stash->{object},template => 'users/edit.tt');
}
sub update :Chained('object') :PathPart('update') :Args(0) 
{
	my ($self, $c) = @_;
	# Retrieve the values from the form
	my $username = $c->request->params->{username} || 'N/A';
	$c->log->debug($c->request->params->{username});
	my $email = $c->request->params->{email} || 'N/A';
	$c->log->debug($c->request->params->{email});
	my $fname =$c->request->params->{first_name} || 'N/A';
	$c->log->debug($c->request->params->{first_name});
	my $lname =$c->request->params->{last_name} || 'N/A';
	$c->log->debug($c->request->params->{last_name});
	# Create the user
	my $user = $c->stash->{object}->update({
											username => $username,
											email => $email,
											first_name => $fname,
											last_name => $lname
										   });
	# Store new model object in stash and set template
	$c->forward('list');
}