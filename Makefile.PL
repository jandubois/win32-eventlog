use ExtUtils::MakeMaker;

unless ($^O eq "MSWin32" || $^O eq "cygwin") {
    die "OS unsupported\n";
}

WriteMakefile(
    'NAME'		=> 'Win32::EventLog',
    'VERSION_FROM'	=> 'EventLog.pm',
    'dist'		=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'}, 
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Bret Giddings <bret@essex.ac.uk>',
	'ABSTRACT'	=> 'Creates an object oriented interface to the '
			 . 'Windows NT Eventlog.',
      )),
);
