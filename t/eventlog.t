# (c) 1995 Microsoft Corporation. All rights reserved.
#	Developed by ActiveWare Internet Corp., http://www.ActiveWare.com

# eventlog.ntt - Event Logging tests

#set the include path.
BEGIN {
    if (Win32::IsWin95()) {
        print"1..0\n";
        print STDERR "# EventLog is not supported on Windows 95 or Win32s\n";
    }
}


use Win32::EventLog;

$bug = 1;

#accounting for test.bat

open( ME, $0 ) || die $!;
$bugs = grep( /^\$bug\+\+;\n$/, <ME> );
close( ME );

print "1..$bugs\n";

# test for opening an eventlog object.
#
#

Win32::EventLog::Open($EventObj, 'WinApp', '') || print "not ";
print "ok $bug\n";
$bug++;

$number = 0;
$EventObj->GetNumber( $number ) || print "not ";
print "ok $bug\n";
$bug++;

$Event = {
	'Category' => 50,
	'EventType' => EVENTLOG_INFORMATION_TYPE,
	'EventID' => 100,
	'Strings' => "Windows is good",
	'Data' => 'unix',
	};

$EventObj->Report( $Event ) || print "not ";
print "ok $bug\n";
$bug++;

$EventObj->GetNumber( $number ) || print "not ";
print "ok $bug\n";
$bug++;

$EventObj->GetOldest( $oldNumber ) || print "not ";
print "ok $bug\n";
$bug++;

$number += $oldNumber - 1;

$EventObj->Read((EVENTLOG_SEEK_READ | EVENTLOG_FORWARDS_READ), $number, $EventInfo) || print "not ";
print "ok $bug\n";
$bug++;

$eventid = $EventInfo->{'EventID'};
$eventcategory = $EventInfo->{'Category'};
$eventtype = $EventInfo->{'EventType'};
$strings = $EventInfo->{'Strings'};
$data = $EventInfo->{'Data'};

$eventid == 100 || print "not ";
$eventcategory == 50 || print "not ";
$eventtype == EVENTLOG_INFORMATION_TYPE || print "not ";

$strings =~/Windows is good/ || print "not ";
$data eq 'unix' || print "not ";


print "ok $bug\n";
$bug++;


