use MuEvent;

my @urls = <
    duckduckgo.com
    cpan.org
    kosciol-spaghetti.pl
    perlcabal.org
    perl6.org
>;
my $count = @urls.elems;
my $starttime;

sub http_get_eager(:$url!) is export {
    my $sock = IO::Socket::INET.new(host => $url, port => 80);
    my $req = "GET / HTTP/1.1\r\n"
            ~ "Connection: Close\r\n"
            ~ "Host: $url\r\n"
            ~ "User-Agent: MuEvent/0.0 Perl6/$*PERL<compiler><ver>\r\n"
            ~ "\r\n";
    $sock.send($req);
    $sock.recv;
    $sock.close;
}

say "=== BLOCKING FETCHING ===";
my $last;
$starttime = $last = now;
for @urls -> $url {
    http_get_eager(url => $url);
    say sprintf "%-25s has loaded in %s", $url, now - $last;
    $last = now;
}
say "Finished in {now - $starttime} seconds";


sub handler ($what, $content) {
    say sprintf "%-25s has loaded in %s", $what, now - $starttime;
    unless --$count {
        say "Finished in {now - $starttime} seconds";
        exit 0;
    }
}

say "=== NON-BLOCKING FETCHING ===";
$starttime = now;

for @urls -> $url {
    http_get(url => $url, cb => sub { handler($url, $^content) })
}

MuEvent::run;










use MuEvent;

MuEvent::timer(
    after => 2,
    cb => sub { say "2 seconds have passed" },
);

MuEvent::timer(
    after => 0,
    interval => 5,
    cb => sub { say "I run every 5 seconds" },
);

MuEvent::idle(
    cb => sub { say "Nothing better to do"; sleep 1 },
);

my $l = IO::Socket::INET.new(
    :localhost('localhost'),
    :localport(6666),
    :listen
);

MuEvent::socket(
    socket => $l,
    poll => 'r',
    cb => &socket-cb,
    params => { sock => $l },
);

sub socket-cb(:$sock) {
    say "Oh gosh a client!";
    my $s = $sock.accept;

    MuEvent::socket(
        socket => $s,
        poll => 'r',
        params => { sock => $s },
        cb => sub (:$sock) {
            my $a = $sock.recv;
            if $a {
                print "Incoming transmission: $a";
                return True;
            } else {
                say "Client disconnected";
                $sock.close;
                return False;
            }
        }
    );
    return True;
}

MuEvent::run;



{
    my $cv = MuEvent::condvar;

    MuEvent::timer(after => 2, cb => sub {
        ok $plan++ == 2 && $start+1 <= time <= $start+3, "timer occured";
        $cv.send;
    });

    ok $plan++ == 1 && time - $start < 1, "not block timer";
    $cv.recv;
    ok $plan++ == 3 && $start+1 <= time <= $start+3, "received blocked";
}

