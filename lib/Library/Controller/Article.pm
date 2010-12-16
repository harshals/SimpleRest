use strict;
use warnings;

package Nblog::Controller::Article;
use Moose;
use MooseX::NonMoose;

extends 'WebNano::Controller';

use URI::Escape 'uri_unescape';
use Nblog::Form::Comment;

has article => ( is => 'rw' );

around local_dispatch => sub {
    my ( $orig, $self, $title, @args ) = @_;
    my $title = uri_unescape( $title );
    my $app = $self->app;
    $self->article( 
        $app->schema->resultset('Article')
            ->search( { 'subject' => { like => $app->ravlog_url_to_query($title) } } )->first
    );
    $self->$orig( @args );
};


sub index_action {
    return shift->view_action( @_ );
}

sub view_action {
    my $self = shift;
	unless ($self->article) {
		return ;
	}
    my $form = Nblog::Form::Comment->new( 
        user => $self->env->{user},
        article_id => $self->article->id, 
        remote_ip => $self->env->{remote_ip},
        schema => $self->app->schema,
    );
    $form->process( params => $self->req->parameters->as_hashref );
    return $self->render( 
        template => 'blog_view.tt',
            article => $self->article,
            title   => $self->article->subject,
            comments => [ $self->article->comments->all ],
            comment_form => $form,
    );
}


1;
