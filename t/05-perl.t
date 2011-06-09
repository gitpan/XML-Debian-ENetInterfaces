#!perl -T

# Test the capabilities of the running perl.
use Test::More tests => 63;
use feature 'switch';

# Apparently ~~ is a moving target, so testing your perl for support.
ok(undef ~~ undef, 'undef ~~ undef');
ok(undef ~~ [1,undef], 'undef ~~ [1,undef]');
ok(!(undef ~~ /2/), '!(undef ~~ /2/)');
ok(2 ~~ /2/, '2 ~~ /2/');
ok({grep 2 ~~ $_, [/2/]}, 'grep 2 ~~ $_, [/2/]');
ok({grep 2 ~~ $_, [1,/2/]}, 'grep 2 ~~ $_, [1,/2/]');
ok({grep 2 ~~ $_, [/2/,1]}, 'grep 2 ~~ $_, [/2/,1]');
ok({grep 2 ~~ $_, [1,/2/,undef]}, 'grep 2 ~~ $_, [1,/2/,undef]');
ok({grep 2 ~~ $_, [undef,/2/,1]}, 'grep 2 ~~ $_, [undef,/2/,1]');
TODO: {
local $TODO = 'Should work like previous 5.';
  ok(2 ~~ [/2/], '2 ~~ [/2/]');
  ok(2 ~~ [1,/2/], '2 ~~ [1,/2/]');
  ok(2 ~~ [/2/,1], '2 ~~ [/2/,1]');
  ok(2 ~~ [1,/2/,undef], '2 ~~ [1,/2/,undef]');
  ok(2 ~~ [undef,/2/,1], '2 ~~ [undef,/2/,1]');
}
ok(undef ~~ [1,/2/,undef], 'undef ~~ [1,/2/,undef]');
ok(1 ~~ [1,/2/,undef], '1 ~~ [1,/2/,undef]');
ok(undef ~~ [undef,/2/,1], 'undef ~~ [undef,/2/,1]');
ok(1 ~~ [undef,/2/,1], '1 ~~ [undef,/2/,1]');

ok(sub {return 1;}, 'sub {return 1;}');
ok(sub {return !0;}, 'sub {return !0;}');
ok(sub {given(1){when(1){return 1;} default{return 0;}}}, 'given 1 when 1');
ok(sub {given(2){when(/2/){return 1;} default{return 0;}}},
  'given 2 when /2/');
ok(sub {given(undef){when(undef){return 1;} default{return 0;}}},
  'given undef when undef');
ok(sub {given(undef){when([1,undef]){return 1;} default{return 0;}}},
  'given undef when [undef,1]');
ok(sub {given(undef){when([undef,1]){return 1;} default{return 0;}}},
  'given undef when [undef,1]');
ok(sub {given(1){when([1,undef]){return 1;} default{return 0;}}},
  'given 1 when [undef,1]');
ok(sub {given(1){when([undef,1]){return 1;} default{return 0;}}},
  'given 1 when [undef,1]');

ok(sub {given(1){when([1,/2/]){return 1;} default{return 0;}}},
  'given 1 when [1,/2/]');
ok(sub {given(1){when([/2/,1]){return 1;} default{return 0;}}},
  'given 1 when [/2/,1]');

ok(sub {given(1){when([1,/2/,undef]){return 1;} default{return 0;}}},
  'given 1 when [1,/2/,undef]');
ok(sub {given(1){when([undef,1,/2/]){return 1;} default{return 0;}}},
  'given 1 when [undef,1,/2/]');
ok(sub {given(undef){when([1,/2/,undef]){return 1;}default{return
0;}}}, 'given undef when [1,/2/,undef]');
ok(sub {given(undef){when([undef,1,/2/]){return 1;}default{return
0;}}}, 'given undef when [undef,1,/2/]');

ok(sub {given(2){when([1,/2/]){return 1;} default{return 0;}}},
  'given 2 when [1,/2/]');
ok(sub {given(2){when([/2/,1]){return 1;} default{return 0;}}},
  'given 2 when [/2/,1]');
ok(sub {given(2){when([1,/2/,undef]){return 1;} default{return 0;}}},
  'given 2 when [1,/2/,undef]');
ok(sub {given(2){when([undef,1,/2/]){return 1;} default{return 0;}}},
  'given 2 when [undef,1,/2/]');

sub _mycode($) {
  my ($given) = @_;
#  warn Dumper(\@_);
  my $tmp='__NEVERMATCH';
  given ($given){
    when([undef,'etc_network_interfaces','iface','mapping']) {return 'Null';}
    when('COMMENT') { return 'COMMENT'; }
    when(/allow-[^ ]*/) { $tmp=$given; continue; }
    when(['up','down','post-up','pre-down','auto',$tmp]) {
      return 'repeat';
    }
    default { return 'default'; }
  }
}

is(_mycode(undef), 'Null', '_mycode(undef)');
is(_mycode("etc_network_interfaces"), 'Null', '_mycode("etc_network_interfaces")');
is(_mycode("mapping"), 'Null', '_mycode("mapping")');
is(_mycode("COMMENT"), 'COMMENT', '_mycode("COMMENT")');
is(_mycode("up"), 'repeat', '_mycode("up")');
is(_mycode("pre-down"), 'repeat', '_mycode("pre-down")');
is(_mycode("auto"), 'repeat', '_mycode("auto")');
is(_mycode("allow-auto"), 'repeat', '_mycode("allow-auto")');
is(_mycode("allow-pizza"), 'repeat', '_mycode("allow-pizza")');
is(_mycode("allow-"), 'repeat', '_mycode("allow-")');
is(_mycode("default"), 'default', '_mycode("default")');
is(_mycode("pizza"), 'default', '_mycode("pizza")');
is(_mycode(""), 'default', '_mycode("")');

sub _thecode($) {
  my ($given) = @_;
#  warn Dumper(\@_);
  given ($given){
    when([undef,'etc_network_interfaces','iface','mapping']) {return 'Null';}
    when('COMMENT') { return 'COMMENT'; }
    when(['up','down','post-up','pre-down','auto',/allow-[^ ]*/]) {
      return 'repeat';
    }
    default { return 'default'; }
  }
}

is(_thecode(undef), 'Null', '_thecode(undef)');
is(_thecode("etc_network_interfaces"), 'Null', '_thecode("etc_network_interfaces")');
is(_thecode("mapping"), 'Null', '_thecode("mapping")');
is(_thecode("COMMENT"), 'COMMENT', '_thecode("COMMENT")');
is(_thecode("up"), 'repeat', '_thecode("up")');
is(_thecode("pre-down"), 'repeat', '_thecode("pre-down")');
is(_thecode("auto"), 'repeat', '_thecode("auto")');
TODO: {
local $TODO = 'Should work, but known fail.';
  is(_thecode("allow-auto"), 'repeat', '_thecode("allow-auto")');
  is(_thecode("allow-pizza"), 'repeat', '_thecode("allow-pizza")');
  is(_thecode("allow-"), 'repeat', '_thecode("allow-")');
}
is(_thecode("default"), 'default', '_thecode("default")');
is(_thecode("pizza"), 'default', '_thecode("pizza")');
is(_thecode(""), 'default', '_thecode("")');

