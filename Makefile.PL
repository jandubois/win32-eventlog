use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'Win32::EventLog',
    'VERSION_FROM' => 'EventLog.pm', # finds $VERSION
    'dist'	=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'}, 
    'dynamic_lib' => {OTHERLDFLAGS => 'advapi32.lib'}, 
);
