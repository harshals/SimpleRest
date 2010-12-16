use strict;
use warnings;

package Library::Controller::Admin;
use Moose;
use MooseX::NonMoose;
use Plack::Response;

extends 'WebNano::DirController';

around 'local_dispatch' => sub {
    my $orig = shift;
    my $self = shift;
    if( !$self->env->{user} ){
        return $self->render( template => 'login_required.tt' );
    }
    $self->$orig( @_ );
};

sub index_action {
    my $res = Plack::Response->new;
    $res->redirect( '/Admin/Book/' );
    return $res;
}


1;
