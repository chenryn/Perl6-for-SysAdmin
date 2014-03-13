use IO::Capture::Simple;

my $r = capture_stdout { print "OH"; print " HAI", "!"; };

say "RESULT: $r";
my ($out, $err, $in) = capture { print "OUT"; note "ERR"; prompt "IN> " }

