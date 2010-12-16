use strict;
use warnings;

package Library::Controller::Admin::Article;
use Moose;

extends 'WebNano::Controller::CRUD';

has '+form_class' => ( default => 'Library::Form::Article' );


1;
