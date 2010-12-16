use strict;
use warnings;

package Library::Controller;

use base 'WebNano::DirController';

sub index_action {
    my $self = shift;
    my $books = $self->app->schema->resultset('Library::Schema::Result::Book')->recent();

    return $self->render( template => 'book_index.tt', books => $books );
}

sub logout_action {
    my $self = shift;
    my $req = $self->req;
    if( $req->param( 'logout' ) ){
        delete $self->env->{'psgix.session'}{user_id};
    }
    my $res = $req->new_response();
    $res->redirect( '/' );
    return $res;
}



sub search_action {
   my ( $self, $name ) = @_;

   if ( !defined $name )
   {
      $name = $self->req->param( 'name' );
   }

   my $books = $self->app->schema->resultset('Book')->search(
      [
         subject => { like => "%$name%" },
         body    => { like => "%$name%" },
      ]
   );

   return $self->render( 
       template => 'book_index.tt',
       books => $books,
   )
}

sub book_action {  
   my ( $self, $what ) = @_;

   my $book =
       $self->app->schema->resultset('Book')->find($what);

   return $self->render( 
       template => 'book.tt',
       book => $book,
   )
}


1;

