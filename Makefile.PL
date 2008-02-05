use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'Win32::EventLog',
    'VERSION_FROM' => 'EventLog.pm',
    'dist'	=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'}, 
);
