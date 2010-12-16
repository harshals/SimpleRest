package DancerApp;
use Dancer ':syntax';
use Schema;
use Data::Dumper;

our $VERSION = '0.1';

set serializer => 'JSON';


set 'db' => Schema->new()->init_schema("very_large.db");
set apphandler => 'PSGI';
#set logger => 'console';

get '/' => sub {
    template 'index';
};

## index method, simply list 

before sub {
	my $schema = setting('db');
	$schema->user(1);
	debug "current path is " . request->path;
};

get '/api/:model' => sub {

	my $schema = setting('db');
    my $params = request->params;
	
	debug $schema->sources;

	if (grep(/$params->{'model'}/, $schema->sources  )   ) {
		
		debug "coming here";
		#my $rs = $schema->resultset( $params->{'model'} );
		#my $list = $rs->recent->serialize;
		#return { data => $list };
	}else {
		
		debug "coming here too";
		send_error("Model cannot be found");
	}
	
};

post '/api/:model' => sub {

	my $schema = setting('db');
    my $params = request->params;
	
	if (grep(/$params->{'model'}/, $schema->sources  )   ) {

		my $rs = $schema->resultset( $params->{'model'} );
		my $list = $rs->recent->serialize;
		return { data => $list };
	}else {
		
		send_error("Model cannot be found");
	}
	
};

true;
