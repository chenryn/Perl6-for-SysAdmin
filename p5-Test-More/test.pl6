use Test;
plan 3;

ok $content, "Content was returned.";
is $content, 'Hello World', "Content was correct.";
ok ! 't/dir2/file.foo'.IO.f, 'rm_f';

