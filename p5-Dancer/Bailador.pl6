use Bailador;
use JSON::Tiny;
use YAML;
use DBIish;
use Digest::MD5;
use Redis;
use Email::Simple;

get '/' => sub {
    "hello world"
}

get '/hello/:name' => sub ($name) {
    "Hello $name!"
};

# regexes, as usual
get /foo(.+)/ => sub ($x) {
    "regexes! I got $x"
}

# junctions work too
get any('/h', '/help', '/halp') => sub {
"junctions are cool"
}

# templates!
get / ^ '/template/' (.+) $ / => sub ($x) {
template 'tmpl.tt', { name => $x }
}

post '/new_paste' => sub {
    my $t = time;
    my $c = request.params<content>;
    unless $c {
        return "No empty pastes please";
    }
    my $fh = open "data/$t", :w;
    $fh.print: $c;
    $fh.close;
    return "New paste available at paste/$t";
}

baile;

