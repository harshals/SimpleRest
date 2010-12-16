use strict;
use warnings;
package Library;

use Moose;
use MooseX::NonMoose;
use Moose::Util::TypeConstraints;

use Plack::Request;
use DateTime;

use Plack::Middleware::Static;
use Plack::Middleware::Session;
use Plack::Session::Store::Cache;
use CHI;

extends 'WebNano';
use Library::Schema;
use WebNano::Renderer::TT;

with 'MooseX::SimpleConfig';

has '+configfile' => ( default => 'library.pl' );

has 'name' => ( is => 'ro', isa => 'Str' );

subtype 'Library::Schema::Connected' => as class_type( 'Library::Schema' );
coerce 'Library::Schema::Connected'
    => from 'HashRef' 
        => via { Library::Schema->connect( @{ $_->{connect_info} } ) };

has schema => ( is => 'ro', isa => 'Library::Schema::Connected', coerce => 1 );

subtype 'Library::WebNano::Renderer::TT' => as class_type ( 'WebNano::Renderer::TT' );
coerce 'Library::WebNano::Renderer::TT'
    => from 'HashRef'
        => via { WebNano::Renderer::TT->new( %$_ ) };

has renderer => ( is => 'ro', isa => 'Library::WebNano::Renderer::TT', coerce => 1 );

around handle => sub {
    my $orig = shift;
    my $self = shift;
    my $env  = shift;
    if( $env->{'psgix.session'}{user_id} ){
        $env->{user} = $self->schema->resultset( 'User' )->find( $env->{'psgix.session'}{user_id} );
    }
    else{
        my $req = Plack::Request->new( $env );
        if( $req->param( 'username' ) && $req->param( 'password' ) ){
            my $user = $self->schema->resultset( 'user' )->search( { username => $req->param( 'username' ) } )->first;
            if( $user && $user->check_password( $req->param( 'password' ) ) ){
                $env->{user} = $user;
                $env->{'psgix.session'}{user_id} = $user->id;
            }
        }
    }
    $self->$orig( $env, @_ );
};

sub tags { shift->schema->resultset( 'Book' )->all }




sub authors {
   my ( $self ) = @_;

   my @articles = $self->schema->resultset('Author')->all();

   unless (@articles)
   {
      return "<p>No Articles in Archive!</p>";
   }

	return @articles;
}



sub pages {
   return shift->schema->resultset('Page')->search( display_in_drawer => 1 )->all();
}


override psgi_callback => sub {
    my $app = super;

    $app = Plack::Middleware::Static->wrap( $app, path => qr{^/static/}, root => './templates/' );
    $app = Plack::Middleware::Static->wrap( $app, path => qr{^/favicon.ico$}, root => './templates/static/images/' );
    $app = Plack::Middleware::Session->wrap( $app, store => Plack::Session::Store::Cache->new(

            cache => CHI->new(driver => 'FastMmap')
        )
    );
    return $app;
};

1;
