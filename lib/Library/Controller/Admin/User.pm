use strict;
use warnings;

package Nblog::Controller::Admin::User;
use Moose;

extends 'WebNano::Controller::CRUD';

has '+form_class' => ( default => 'Nblog::Form::User' );

sub after_POST { shift->self_url }

1;
