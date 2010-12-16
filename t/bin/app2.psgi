# PSGI application bootstraper for Dancer
use lib 'lib';
use DancerApp;

use Dancer::Config 'setting';
setting apphandler  => 'PSGI';
Dancer::Config->load;


my $handler = sub {
    my $env = shift;
    my $request = Dancer::Request->new($env);
    Dancer->dance($request);
};
