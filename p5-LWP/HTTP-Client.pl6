use HTTP::Client;
use Test;

plan 5;

my $http = HTTP::Client.new;
#my $res = $htto.get('http://huri.net/test.txt');
my $res = $http.get('http://127.0.0.1:8080/test.txt');
#$*ERR.say: "~Status: "~$res.status;
#$*ERR.say: "~Message: "~$res.message;
#$*ERR.say: "~Proto: "~$res.protocol;
ok $res, "Constructed result object from direct get() call.";
ok $res.success, "Result was successful.";
my $content = $res.content;
#$*ERR.say: "~Content: $content";
#$*ERR.say: "~Headers: "~$res.headers.perl;
ok $content, "Content was returned.";
is $content, 'Hello World', "Content was correct.";
is $res.header('Content-Type'), 'text/plain', "Correct content type.";


my $req = $http.post(:multipart);
$req.url('http://127.0.0.1:8080/test.txt');
$req.add-field(:id<1984>);
$req.add-file(
  :name("upload"), :filename("test.txt"),
  :type("text/plain"), :content("Hello world.\nThis is a test.\n")
);
my $res = $req.run;


