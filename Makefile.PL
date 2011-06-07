use strict;
use warnings;
require 5.10.0;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'XML::Debian::ENetInterfaces',
    AUTHOR              => q{Michael Mestnik <cheako+cpan@mikemestnik.net>},
    VERSION_FROM        => 'lib/XML/Debian/ENetInterfaces.pm',
    ABSTRACT_FROM       => 'lib/XML/Debian/ENetInterfaces.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'XML::LibXML' => 0,		# For generating XML.
        'XML::Parser::PerlSAX' => 0,	# For parsing XML.
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'XML-Debian-ENetInterfaces-*' },
);
