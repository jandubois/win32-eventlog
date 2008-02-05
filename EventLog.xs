/*
 * XS interface to the Windows NT EventLog
 * Written by Jesse Dougherty for hip communications
 */

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#define BUFFER_SIZE 1024
#define CROAK croak

#define TMPBUFSZ 1024

#define SUCCESSRETURNED(x)    (x == ERROR_SUCCESS)
#define REGRETURN(x) XSRETURN_IV(SUCCESSRETURNED(x))


#define SETIV(index,value) sv_setiv(ST(index), value)
#define SETPV(index,string) sv_setpv(ST(index), string)
#define SETPVN(index, buffer, length) sv_setpvn(ST(index), (char*)buffer, length)
#define SETHKEY(index, hkey)    SETIV(index,(long)hkey)

#define NEW(x,v,n,t)  (v = (t*)safemalloc((MEM_SIZE)((n) * sizeof(t))))
#define PERLSvIV(sv) (SvIOK(sv) ? SvIVX(sv) : sv_2iv(sv))
#define PERLSvPV(sv, lp) (SvPOK(sv) ? ((lp = SvCUR(sv)), SvPVX(sv)) : sv_2pv(sv, &lp))

#define SvHKEY(index) (HKEY)((unsigned long) PERLSvIV(index))

#define PERLPUSHMARK(p) if (++markstack_ptr == markstack_max)    \
            markstack_grow();            \
            *markstack_ptr = (p) - stack_base

#define PERLXPUSHs(s)    do {\
         if (stack_max - sp < 1) {\
                sp = stack_grow(sp, sp, 1);\
            }\
  (*++sp = (s)); } while (0)

#define PERLADVAPI WINAPI

/* Modified calls go here. */

/* Revamped ReportEvent that doesn't use SIDs. */
typedef struct _EvtLogCtlBuf
{
    DWORD  dwID;                    /* id for mem block */
    HANDLE hLog;                    /* event log handle */
    LPBYTE BufPtr;                    /* pointer to data buffer */
    DWORD  BufLen;                    /* size of buffer */
    DWORD  NumEntries;                /* number of entries in buffer */
    DWORD  CurEntryNum;                /* next entry to return */
    EVENTLOGRECORD *CurEntry;        /* point to next entry to return */
    DWORD  Flags;                    /* read flags for ReadEventLog */
} EvtLogCtlBuf, *lpEvtLogCtlBuf;

#define EVTLOGBUFSIZE 1024
#define EVTLOGID        ((DWORD)0x674c7645L)
#define SVE(x)    (lpEvtLogCtlBuf) (x)


/* constant function for exporting NT definitions for Eventlogs. */

static double
constant(char *name,int arg )
{
    errno = 0;
    switch (*name) {
    case 'A':
    break;
    case 'B':
    break;
    case 'C':
    break;
    case 'D':
    break;
    case 'E':
    if (strEQ(name, "EVENTLOG_AUDIT_FAILURE"))
#ifdef EVENTLOG_AUDIT_FAILURE
        return EVENTLOG_AUDIT_FAILURE;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_AUDIT_SUCCESS"))
#ifdef EVENTLOG_AUDIT_SUCCESS
        return EVENTLOG_AUDIT_SUCCESS;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_BACKWARDS_READ"))
#ifdef EVENTLOG_BACKWARDS_READ
        return EVENTLOG_BACKWARDS_READ;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_END_ALL_PAIRED_EVENTS"))
#ifdef EVENTLOG_END_ALL_PAIRED_EVENTS
        return EVENTLOG_END_ALL_PAIRED_EVENTS;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_END_PAIRED_EVENT"))
#ifdef EVENTLOG_END_PAIRED_EVENT
        return EVENTLOG_END_PAIRED_EVENT;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_ERROR_TYPE"))
#ifdef EVENTLOG_ERROR_TYPE
        return EVENTLOG_ERROR_TYPE;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_FORWARDS_READ"))
#ifdef EVENTLOG_FORWARDS_READ
        return EVENTLOG_FORWARDS_READ;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_INFORMATION_TYPE"))
#ifdef EVENTLOG_INFORMATION_TYPE
        return EVENTLOG_INFORMATION_TYPE;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_PAIRED_EVENT_ACTIVE"))
#ifdef EVENTLOG_PAIRED_EVENT_ACTIVE
        return EVENTLOG_PAIRED_EVENT_ACTIVE;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_PAIRED_EVENT_INACTIVE"))
#ifdef EVENTLOG_PAIRED_EVENT_INACTIVE
        return EVENTLOG_PAIRED_EVENT_INACTIVE;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_SEEK_READ"))
#ifdef EVENTLOG_SEEK_READ
        return EVENTLOG_SEEK_READ;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_SEQUENTIAL_READ"))
#ifdef EVENTLOG_SEQUENTIAL_READ
        return EVENTLOG_SEQUENTIAL_READ;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_START_PAIRED_EVENT"))
#ifdef EVENTLOG_START_PAIRED_EVENT
        return EVENTLOG_START_PAIRED_EVENT;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_SUCCESS"))
#ifdef EVENTLOG_SUCCESS
        return EVENTLOG_SUCCESS;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_WARNING_TYPE"))
#ifdef EVENTLOG_WARNING_TYPE
        return EVENTLOG_WARNING_TYPE;
#else
        goto not_there;
#endif
    break;
    case 'F':
    break;
    case 'G':
    break;
    case 'H':
    break;
    case 'I':
    break;
    case 'J':
    break;
    case 'K':
    break;
    case 'L':
    break;
    case 'M':
    break;
    case 'N':
    break;
    case 'O':
    break;
    case 'P':
    break;
    case 'Q':
    break;
    case 'R':
    break;
    case 'S':
    break;
    case 'T':
    break;
    case 'U':
    break;
    case 'V':
    break;
    case 'W':
    break;
    case 'X':
    break;
    case 'Y':
    break;
    case 'Z':
    break;
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

MODULE = Win32::EventLog	PACKAGE = Win32::EventLog

PROTOTYPES: DISABLE

bool
WriteEventLog(server, source, eventType, category, eventID, reserved, data, ...)
    	char *server
	char *source
	DWORD eventType
	DWORD category
	DWORD eventID
	DWORD reserved = NO_INIT
	char *data = NO_INIT
    CODE:
	{
	    unsigned int bufLength, dataLength, index;
	    char *buffer, **array;
	    HANDLE hLog;

	    RETVAL = FALSE;

	    if (server && *server == '\0')
		server = NULL;

	    if ((hLog = RegisterEventSource(server, source)) != NULL) {
		data = PERLSvPV(ST(6), dataLength);
		NEW(3101, array, items - 7, char*);
		for(index = 0; index < items - 7; ++index) {
		    buffer = PERLSvPV(ST(index+7), bufLength);
		    array[index] = buffer;
		}
		if(ReportEvent(
		    hLog,        	/* handle returned by RegisterEventSource */
		    PERLSvIV(ST(2)),    /* event type to log */
		    PERLSvIV(ST(3)),    /* event category */
		    PERLSvIV(ST(4)),    /* event identifier */
		    NULL,               /* user security identifier (optional) */
		    items - 7,          /* number of strings to merge with message */
		    dataLength,         /* size of raw (binary) data (in bytes) */
		    (const char**)array,/* array of strings to merge with message */
		    data                /* address of binary data */
                ))
		{
		    RETVAL = TRUE;
		}
		Safefree(array);
		DeregisterEventSource(hLog);
	    }
	}
    OUTPUT:
    	RETVAL

bool
ReadEventLog(handle,Flags,Record,evtHeader,sourceName,computerName,sid,data,strings)
	U32 handle
	DWORD Flags
	DWORD Record
	char *evtHeader = NO_INIT
	char *sourceName = NO_INIT
	char *computerName = NO_INIT
	char *sid = NO_INIT
	char *data = NO_INIT
	char *strings = NO_INIT
    CODE:
	{
	    int length;
	    lpEvtLogCtlBuf lpEvtLog;
	    RETVAL = FALSE;
	    
	    lpEvtLog = SVE(handle);
	    if((lpEvtLog != NULL) && (lpEvtLog->dwID == EVTLOGID)) {
		DWORD NumRead, Required;
		long retval;
		if(Flags != lpEvtLog->Flags) {
		    /* Reset to new read mode & force a re-read call */
		    lpEvtLog->Flags      = Flags;
		    lpEvtLog->NumEntries = 0;
		}
		if((lpEvtLog->NumEntries == 0) || (Record != 0)) {
		    if(ReadEventLog(lpEvtLog->hLog, Flags, Record, lpEvtLog->BufPtr,
				    lpEvtLog->BufLen, &NumRead, &Required)) {
			lpEvtLog->NumEntries = NumRead;
		    }
		    else {
			lpEvtLog->NumEntries = 0;
			GetLastError();
		    }
		    lpEvtLog->CurEntryNum = 0;
		    lpEvtLog->CurEntry    = (EVENTLOGRECORD*)lpEvtLog->BufPtr;
		}

		if(lpEvtLog->CurEntryNum < lpEvtLog->NumEntries) {
		    char *name;
		    EVENTLOGRECORD *LogBuf;
		    LogBuf = lpEvtLog->CurEntry;        
		    SETPVN(3, (char*)LogBuf, LogBuf->Length);
		    name = ((LPSTR)LogBuf)+sizeof(EVENTLOGRECORD);
		    SETPV(4, name);
		    name += strlen(name)+1; /* step over NULL */
		    SETPV(5, name);
		    SETPVN(6, ((LPBYTE)LogBuf)+LogBuf->UserSidOffset, LogBuf->UserSidLength);
		    SETPVN(7, ((LPBYTE)LogBuf)+LogBuf->DataOffset, LogBuf->DataLength);
		    SETPVN(8, ((LPBYTE)LogBuf)+LogBuf->StringOffset, LogBuf->DataOffset-LogBuf->StringOffset);

		    /* to next entry in buffer */
		    lpEvtLog->CurEntryNum += LogBuf->Length;
		    lpEvtLog->CurEntry = (EVENTLOGRECORD*)(((LPBYTE)LogBuf) + LogBuf->Length);
		    if(lpEvtLog->CurEntryNum == lpEvtLog->NumEntries) {
			lpEvtLog->NumEntries  = 0;
			lpEvtLog->CurEntryNum = 0;
			lpEvtLog->CurEntry    = NULL;
		    }
		    RETVAL = TRUE;
		}
	    }
	}
    OUTPUT:
    	RETVAL

double
constant(name,arg)
    char *          name
    int             arg

bool
BackupEventLog(hEventLog,lpszBackupFileName)
    void *    hEventLog
    char *    lpszBackupFileName
    CODE:
	{
	    lpEvtLogCtlBuf lpEvtLog = SVE(hEventLog);
	    RETVAL = FALSE;
	    if ((lpEvtLog != NULL) && (lpEvtLog->dwID == EVTLOGID))
		RETVAL = BackupEventLog(lpEvtLog->hLog, lpszBackupFileName);
	}
    OUTPUT:
    RETVAL

bool
ClearEventLog(hEventLog,lpszBackupFileName)
    void *    hEventLog
    char *    lpszBackupFileName
    CODE:
	{
	    lpEvtLogCtlBuf lpEvtLog = SVE(hEventLog);
	    RETVAL = FALSE;
	    if ((lpEvtLog != NULL) && (lpEvtLog->dwID == EVTLOGID) &&
		ClearEventLog(lpEvtLog->hLog, lpszBackupFileName) &&
		CloseEventLog(lpEvtLog->hLog))
	    {
		if(lpEvtLog->BufPtr)
		    Safefree(lpEvtLog->BufPtr);
		Safefree(lpEvtLog);
		RETVAL = TRUE;
	    }
	}
    OUTPUT:
    RETVAL

bool
CloseEventLog(hEventLog)
    void *    hEventLog
    CODE:
	{
	    lpEvtLogCtlBuf lpEvtLog = SVE(hEventLog);
	    RETVAL = FALSE;
	    if ((lpEvtLog != NULL) && (lpEvtLog->dwID == EVTLOGID) &&
		CloseEventLog(lpEvtLog->hLog))
	    {
		if(lpEvtLog->BufPtr)
		    Safefree(lpEvtLog->BufPtr);
		Safefree(lpEvtLog);
		RETVAL = TRUE;
	    }
	}
    OUTPUT:
    RETVAL

bool
DeregisterEventSource(hEventLog)
    void *    hEventLog

bool
GetNumberOfEventLogRecords(hEventLog,dwRecords)
    void *     hEventLog
    DWORD dwRecords = NO_INIT
    CODE:
	{
	    lpEvtLogCtlBuf lpEvtLog = SVE(hEventLog);
	    RETVAL = FALSE;
	    if ((lpEvtLog != NULL) && (lpEvtLog->dwID == EVTLOGID) &&
		GetNumberOfEventLogRecords(lpEvtLog->hLog, &dwRecords))
	    {
		RETVAL = TRUE;
	    }
	}
    OUTPUT:
	RETVAL
	dwRecords	if (RETVAL) SETIV(1, dwRecords);

bool
GetOldestEventLogRecord(hEventLog,dwOldestRecord)
    void *    hEventLog
    DWORD     dwOldestRecord = NO_INIT
    CODE:
	{
	    lpEvtLogCtlBuf lpEvtLog = SVE(hEventLog);
	    RETVAL = FALSE;
	    if ((lpEvtLog != NULL) && (lpEvtLog->dwID == EVTLOGID) &&
		GetOldestEventLogRecord(lpEvtLog->hLog, &dwOldestRecord))
	    {
		RETVAL = TRUE;
	    }
	}
    OUTPUT:
	RETVAL
	dwOldestRecord	if (RETVAL) SETIV(1, dwOldestRecord);

bool
OpenBackupEventLog(hEventLog,lpszUNCServerName,lpszFileName)
    U32       hEventLog = 0;
    char *    lpszUNCServerName
    char *    lpszFileName
    CODE:
	{
	    lpEvtLogCtlBuf lpEvtLog;
	    NEW(1908, lpEvtLog, 1, EvtLogCtlBuf);
	    lpEvtLog->BufLen = EVTLOGBUFSIZE;
	    NEW(1908, lpEvtLog->BufPtr, lpEvtLog->BufLen, BYTE);
	    RETVAL = FALSE;
	    if ((lpEvtLog->hLog = OpenBackupEventLog(lpszUNCServerName,lpszFileName))) {
		/* return info... */
		lpEvtLog->dwID                  = EVTLOGID;
		lpEvtLog->NumEntries    = 0;
		lpEvtLog->CurEntryNum   = 0;
		lpEvtLog->CurEntry              = NULL;
		lpEvtLog->Flags                 = 0;
		hEventLog = (U32)lpEvtLog;
		RETVAL = TRUE;
	    }
	    else {
		/* Open failed... */
		if(lpEvtLog->BufPtr)
		    Safefree(lpEvtLog->BufPtr);
		Safefree(lpEvtLog);
	    }
	}
    OUTPUT:
	RETVAL
	hEventLog

bool
OpenEventLog(hEventLog,lpszUNCServerName,lpszSourceName)
    U32       hEventLog = 0;
    char *    lpszUNCServerName
    char *    lpszSourceName
    CODE:
	{
	    lpEvtLogCtlBuf lpEvtLog;
	    NEW(1908, lpEvtLog, 1, EvtLogCtlBuf);
	    lpEvtLog->BufLen = EVTLOGBUFSIZE;
	    NEW(1908, lpEvtLog->BufPtr, lpEvtLog->BufLen, BYTE);
	    RETVAL = FALSE;
	    if ((lpEvtLog->hLog = OpenEventLog(lpszUNCServerName,lpszSourceName))) {
		/* return info... */
		lpEvtLog->dwID                  = EVTLOGID;
		lpEvtLog->NumEntries    = 0;
		lpEvtLog->CurEntryNum   = 0;
		lpEvtLog->CurEntry              = NULL;
		lpEvtLog->Flags                 = 0;
		hEventLog = (U32)lpEvtLog;
		RETVAL = TRUE;
	    }
	    else {
		/* Open failed... */
		if(lpEvtLog->BufPtr)
		    Safefree(lpEvtLog->BufPtr);
		Safefree(lpEvtLog);
	    }
	}
    OUTPUT:
	RETVAL
	hEventLog

void*
RegisterEventSource(lpszUNCServerName,lpszSource)
    char *    lpszUNCServerName
    char *    lpszSource

