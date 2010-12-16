use strict;
use lib "lib";
use Nblog;

my $app = Nblog->new_with_config();

$app->psgi_callback;

