use lib "lib";
use Dancer;
load_app "DancerApp";
use Log::Log4perl;

use Dancer::Config 'setting';
setting apphandler => 'PSGI';
Dancer::Config->load;
use Plack::Builder;


my $app = sub {
    my $env = shift;
    my $request = Dancer::Request->new( $env );
    Dancer->dance( $request );
};

builder {
	enable 'Session', store => 'File';
	enable 'Debug';
    enable "ConsoleLogger";
	enable "Plack::Middleware::Static",
          path => qr{^/(images|js|css)/}, root => './public/';
 	enable "Plack::Middleware::ServerStatus::Lite",
          path => '/status',
          allow => [ '127.0.0.1', '192.168.0.0/16' ],
          scoreboard => '/tmp';
	
    $app;
};

