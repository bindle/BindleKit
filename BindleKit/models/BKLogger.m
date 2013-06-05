/*
 *  Bindle Binaries Objective-C Kit
 *  Copyright (c) 2012, Bindle Binaries
 *
 *  @BINDLE_BINARIES_BSD_LICENSE_START@
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are
 *  met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Bindle Binaries nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 *  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 *  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 *  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL BINDLE BINARIES BE LIABLE FOR
 *  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 *  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 *  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 *  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 *  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 *  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 *  SUCH DAMAGE.
 *
 *  @BINDLE_BINARIES_BSD_LICENSE_END@
 */
/*
 *  BKHash.m - Provides easy way to produce hashes from strings.
 */
#import "BKLogger.h"


#import <libkern/OSAtomic.h>
#import <pthread.h>


#pragma mark - global variables
static BKLogger * _sharedLogInstance;


#pragma mark -
@interface BKLogger ()

// log state
@property (nonatomic, readonly) NSRecursiveLock * lock;

// log history
- (void) rotateHistory;

// internal logging methods
void BKLogBytesv(BKLogger * log, NSString * ident, const uint8_t * d,
                  NSUInteger len, NSUInteger off);
void BKLogv(BKLogger * log, NSString * ident, NSString * format,
            va_list arguments);

@end


#pragma mark -
@implementation BKLogger

// thread locks
@synthesize lock = _lock;


#pragma mark - Object Management Methods

- (id) init
{
   if ((self = [super init]) == nil)
      return(self);

   // log state
   _enabled      = 0;
   _debugEnabled = 0;
   _lock         = [[NSRecursiveLock alloc] init];

   // log parameters
   _ident         = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
   _mechanismMask = BKLogMechanismConsole;
   _logItemMask   = ~0UL;

   // date & time
   _dateFormatter = [[NSDateFormatter alloc] init];
   [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];

   // log history
   _historyMaxSize = 1024 * 1024; // 1 meg
   _history        = [[NSMutableData alloc] initWithCapacity:_historyMaxSize];
   
   return(self);
}


+ (id) sharedLog
{
   static int32_t isSharedLogInstanceInitialized = 0;
   if ((OSAtomicCompareAndSwap32Barrier(0, 1, &isSharedLogInstanceInitialized)))
   {
      _sharedLogInstance = [[BKLogger alloc] init];
   }
   return(_sharedLogInstance);
}


#pragma mark - Log State

- (BOOL) debugEnabled
{
   return(_debugEnabled == 1);
}


- (BOOL) enabled
{
   return(_enabled == 1);
}


- (void) setDebugEnabled:(BOOL)debugEnabled
{
   int32_t n;
   int32_t o;
   n = (debugEnabled == YES) ? 1 : 0;
   o = (debugEnabled == NO)  ? 1 : 0;
   [_lock lock];
   OSAtomicCompareAndSwap32Barrier(o, n, &_debugEnabled);
   [_lock unlock];
   return;
}


- (void) setEnabled:(BOOL)enabled
{
   int32_t n;
   int32_t o;
   n = (enabled == YES) ? 1 : 0;
   o = (enabled == NO)  ? 1 : 0;
   [_lock lock];
   OSAtomicCompareAndSwap32Barrier(o, n, &_enabled);
   [_lock unlock];
   return;
}


#pragma mark - Log Parameters

- (NSUInteger) logItemMask
{
   return(_logItemMask);
}


- (NSString *) ident
{
   NSString * ident;
   [_lock lock];
   ident = _ident;
   [_lock unlock];
   return(ident);
}


- (NSUInteger) mechanismMask
{
   return(_mechanismMask);
}


- (void) setlogItemMask:(NSUInteger)logItem
{
   [_lock lock];
   _logItemMask = logItem;
   [_lock unlock];
   return;
}


- (void) setIdent:(NSString *)ident
{
   NSAssert((ident != nil), @"\"ident\" must not be set to \"nil\"");
   ident = [[NSString alloc] initWithString:ident];
   [_lock lock];
   _ident = ident;
   [_lock unlock];
   return;
}


- (void) setMechanism:(BKLogMechanism)mechanism toState:(BOOL)state
{
   [_lock lock];
   _mechanismMask = ((state)) ? (_mechanismMask | mechanism) : (_mechanismMask & (~mechanism));
   [_lock unlock];
   return;
}


- (void) setLogItem:(NSUInteger)logItem toState:(BOOL)state
{
   [_lock lock];
   _logItemMask = ((state)) ? (_logItemMask | logItem) : (_logItemMask & (~logItem));
   [_lock unlock];
   return;
}


- (void) setMechanismMask:(NSUInteger)mechanismMask
{
   NSAssert((mechanismMask <= BKLogMechanismAll), @"\"mechanismMask\" must be an ORed value of \"BKLogMechanism\" types.");
   [_lock lock];
   _mechanismMask = mechanismMask;
   [_lock unlock];
   return;
}


- (BOOL) stateForMechanism:(BKLogMechanism)mechanism
{
   BOOL state;
   [_lock lock];
   state = (_mechanismMask & mechanism) == mechanism;
   [_lock unlock];
   return(state);
}


- (BOOL) stateForLogItem:(NSUInteger)logItem
{
   BOOL state;
   [_lock lock];
   state = (_logItemMask & logItem) == logItem;
   [_lock unlock];
   return(state);
}


#pragma mark - Date & Time

- (NSString *) dateString
{
   NSString * dateString;
   [_lock lock];
   dateString = [_dateFormatter stringFromDate:[NSDate date]];
   [_lock unlock];
   return(dateString);
}


- (NSString *) dateFormat
{
   NSString * dateFormat;
   [_lock lock];
   dateFormat = _dateFormatter.dateFormat;
   [_lock unlock];
   return(dateFormat);
}


- (NSDateFormatterStyle) dateStyle
{
   NSDateFormatterStyle  dateStyle;
   [_lock lock];
   dateStyle = _dateFormatter.dateStyle;
   [_lock unlock];
   return(dateStyle);
}


- (NSDateFormatterStyle) timeStyle
{
   NSDateFormatterStyle timeStyle;
   [_lock lock];
   timeStyle = _dateFormatter.timeStyle;
   [_lock unlock];
   return(timeStyle);
}


- (void) setDateFormat:(NSString *)dateFormat
{
   NSString * string;
   NSAssert((dateFormat != nil), @"\"dateFormat\" must not be set to \"nil\"");
   string = [[NSString alloc] initWithString:dateFormat];
   [_lock lock];
   _dateFormatter.dateFormat = string;
   [_lock unlock];
   return;
}


- (void) setDateStyle:(NSDateFormatterStyle)dateStyle
{
   [_lock lock];
   _dateFormatter.dateStyle = dateStyle;
   [_lock unlock];
   return;
}


- (void) setTimeStyle:(NSDateFormatterStyle)timeStyle
{
   [_lock lock];
   _dateFormatter.timeStyle = timeStyle;
   [_lock unlock];
   return;
}


#pragma mark - Log History
/// @name Log History

- (NSData *) history
{
   NSData * data;
   [_lock lock];
   data = [[NSData alloc] initWithData:_history];
   [_lock unlock];
   return(data);
}


- (NSUInteger) historyMaxLength
{
   NSUInteger length;
   [_lock lock];
   length = _history.length;
   [_lock unlock];
   return(length);
}


- (NSString *) historyString
{
   NSString * string;
   [_lock lock];
   string = [[NSString alloc] initWithData:_history encoding:NSUTF8StringEncoding];
   [_lock unlock];
   return(string);
}


- (void) resetHistory
{
   [self willChangeValueForKey:@"history"];
   [self willChangeValueForKey:@"historyString"];
   [_lock lock];
   _history.length = 0;
   [_lock unlock];
   [self didChangeValueForKey:@"history"];
   [self didChangeValueForKey:@"historyString"];
   return;
}


- (void) rotateHistory
{
   NSMutableData * data;
   const uint8_t * ptr;
   [_lock lock];
   if (_history.length > _historyMaxSize)
   {
      ptr      = [_history bytes];
      ptr      = &ptr[_history.length - _historyMaxSize - 1];
      data     = [[NSMutableData alloc] initWithBytes:ptr length:_historyMaxSize];
      _history = data;
   };
   [_lock unlock];
   return;
}


- (void) setHistoryMaxLength:(NSUInteger)length
{
   NSAssert((length > 0), @"\"length\" must be greater than zero.");
   [self willChangeValueForKey:@"history"];
   [self willChangeValueForKey:@"historyString"];
   [_lock lock];
   _historyMaxSize = length;
   if (_history.length >= length)
      [self rotateHistory];
   [_lock unlock];
   [self didChangeValueForKey:@"history"];
   [self didChangeValueForKey:@"historyString"];
   return;
}


#pragma mark - Forwarding Log

- (BKLogger *) forwardingLog
{
   BKLogger * forwardingLog;
   [_lock lock];
   forwardingLog = _forwardingLog;
   [_lock unlock];
   return(forwardingLog);
}


- (void) setForwardingLog:(BKLogger *)forwardingLog
{
   [_lock lock];
   _forwardingLog = forwardingLog;
   [_lock unlock];
   return;
}


#pragma mark - Logging Methods

- (void) logBytes:(const uint8_t *)bytes length:(NSUInteger)length
         offset:(NSUInteger)offset
{
   NSAssert((bytes != NULL), @"\"bytes\" must not be NULL");
   NSAssert((length  > 0), @"\"length\" must not greater than zero");
   BKLogBytesv(self, self.ident, bytes, length, offset);
   return;
}


- (void) logData:(NSData *)data offset:(NSUInteger)offset
{
   NSAssert((data != nil), @"\"data\" must not be nil");
   NSAssert((data.length  > 0), @"\"data.length\" must not greater than zero");
   BKLogBytesv(self, self.ident, data.bytes, data.length, offset);
   return;
}


- (void) logItem:(NSUInteger)logItem withBytes:(const uint8_t *)bytes
   length:(NSUInteger)length offset:(NSUInteger)offset
{
   NSAssert((bytes != NULL), @"\"bytes\" must not be NULL");
   NSAssert((length  > 0), @"\"length\" must not greater than zero");
   if (!(logItem & _logItemMask))
      return;
   BKLogBytesv(self, self.ident, bytes, length, offset);
   return;
}


- (void) logItem:(NSUInteger)logItem withData:(NSData *)data
   offset:(NSUInteger)offset
{
   NSAssert((data != nil), @"\"data\" must not be nil");
   NSAssert((data.length  > 0), @"\"data.length\" must not greater than zero");
   if (!(logItem & _logItemMask))
      return;
   BKLogBytesv(self, self.ident, data.bytes, data.length, offset);
   return;
}


- (void) logItem:(NSUInteger)logItem withFormat:(NSString *)format, ...
{
   va_list arguments;
   NSAssert((format != nil), @"\"format\" must not be nil");
   if (!(logItem & _logItemMask))
      return;
   va_start(arguments, format);
   BKLogv(self, self.ident, format, arguments);
   va_end(arguments);
   return;
}


- (void) logFormat:(NSString *)format, ...
{
   va_list arguments;
   NSAssert((format != nil), @"\"format\" must not be nil");
   va_start(arguments, format);
   BKLogv(self, self.ident, format, arguments);
   va_end(arguments);
   return;
}

#pragma mark - CF logging methods

void BKDebugWithLogFunc(BKLogger * log, const char * pretty, NSString * format, ...)
{
   va_list    arguments;
   NSString * newFormat;

   assert(log != nil);

   if (!(log.debugEnabled))
      return;

   newFormat = [NSString stringWithFormat:@"%s: %@", pretty, format];

   va_start(arguments, format);
   BKLogv(log, log.ident, newFormat, arguments);
   va_end(arguments);
   
   return;
}


void BKLogBytes(const uint8_t * d, NSUInteger len, NSUInteger off)
{
   BKLogger * log;

   assert(d   != nil);
   assert(len  > 0);

   log = [BKLogger sharedLog];
   BKLogBytesv(log, log.ident, d, len, off);

   return;
}


void BKLog(NSString * format, ...)
{
   BKLogger * log;
   va_list    arguments;

   assert(format != nil);

   log = [BKLogger sharedLog];

   va_start(arguments, format);
   BKLogv(log, log.ident, format, arguments);
   va_end(arguments);

   return;
}


void BKLogWithLog(BKLogger * log, NSString * format, ...)
{
   va_list    arguments;

   assert(format != nil);

   va_start(arguments, format);
   BKLogv(log, log.ident, format, arguments);
   va_end(arguments);

   return;
}


#pragma mark - internal logging methods

void BKLogBytesv(BKLogger * log, NSString * ident, const uint8_t * d,
   NSUInteger len, NSUInteger off)
{
   BOOL            sendKVO;
   NSUInteger      p;     // buffer position
   NSUInteger      o;     // line offset
   char            c;     // ASCII representation
   char            h1;    // first hex digit
   char            h2;    // second hex digit
   static char     l[80]; // one line of output
   const char    * hex = "0123456789abcdef";

   assert(d   != NULL);
   assert(len != 0);

   // verify logging is configured
   if (!(log.enabled))
      return;
   if (!(log.mechanismMask))
      return;

   // sets default values
   if (!(ident))
      ident = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];

   // sends notifications
   sendKVO = NO;
   if ((log.mechanismMask & BKLogMechanismHistory))
   {
      [log willChangeValueForKey:@"history"];
      [log willChangeValueForKey:@"historyString"];
      sendKVO = YES;
   };

   [log->_lock lock];

   // forwards message to remote logger
   if ((log->_mechanismMask & BKLogMechanismForward))
      if ((log->_forwardingLog))
         BKLogBytesv(log->_forwardingLog, ident, d, len, off);
   if (!(log->_mechanismMask & (~BKLogMechanismForward)))
   {
      [log->_lock unlock];
      return;
   };

   // records column names
   snprintf(l, 80, " offset    0  1  2  3   4  5  6  7   8  9  a  b   c  d  e  f  0123456789abcdef\n");
   if ((log->_mechanismMask & BKLogMechanismConsole))
      write(STDERR_FILENO, l, 79);
   if ((log->_mechanismMask & BKLogMechanismHistory))
      [log->_history appendBytes:l length:79];

   // clears line buffer
   for(p = 0; p < 80; p++)
      l[p] = ' ';
   l[78] = '\n';

   // creates initial buffer offset
   snprintf(l, 80, "%08x", (off & (~0x0f)));
   l[8] = ' ';

   // loops through buffer
   for(p = off; p < (len+off); p++)
   {
      // updates buffer offset
      if ((p & 0x0F) == 0x00)
      {
         snprintf(l, 80, "%08x", (p & (~0x0f)));
         l[8] = ' ';
      };

      // calculates line positions
      //    * each byte is represented by 2 hex digits and a space
      //    * after each word (4 bytes) of data, an extra space is appended
      o  = ((p >> 0) & 0x03) * 3;  // calculate offset of byte within 4 byte word
      o += ((p >> 2) & 0x03) * 13; // calculate offset of 4 byte word within line

      // calculates hex and ASCII respresentation
      h1 = hex[(p >> 0) & 0x0f];                          // first hex digit
      h2 = hex[(p >> 4) & 0x0f];                          // second hex digit
      c  = ((d[p] >= ' ') && (d[p] <= '~')) ? d[p] : '.'; // ASCII representation

      // saves data within line
      l[10 + o]          = h1;
      l[11 + o]          = h2;
      l[62 + (p & 0x0f)] = c;

      // records line, if at end of line
      if ((p & 0x0f) == 0x0f)
      {
         if ((log->_mechanismMask & BKLogMechanismConsole))
            write(STDERR_FILENO, l, 79);
         if ((log->_mechanismMask & BKLogMechanismHistory))
            [log->_history appendBytes:l length:79];
      };
   };

   // logs remaining data
   if ((p & 0x0f) != 0)
   {
      // clears remainder of line
      for(p = (p & 0x0f); p < 0x10; p++)
      {
         // calculates line positions
         o  = ((p >> 0) & 0x03) * 3;  // calculate offset of byte within 4 byte word
         o += ((p >> 2) & 0x03) * 13; // calculate offset of 4 byte word within line

         // clears data within line
         l[10 + o]          = ' ';
         l[11 + o]          = ' ';
         l[62 + (p & 0x0f)] = ' ';
      };

      // records line
      if ((log->_mechanismMask & BKLogMechanismConsole))
         write(STDERR_FILENO, l, 79);
      if ((log->_mechanismMask & BKLogMechanismHistory))
         [log->_history appendBytes:l length:79];
   };

   // trims excess data
   if ((log->_mechanismMask & BKLogMechanismHistory))
      if (log->_history.length > log->_historyMaxSize)
         [log rotateHistory];

   [log->_lock unlock];

   // sends notifications
   if ((sendKVO))
   {
      [log didChangeValueForKey:@"history"];
      [log didChangeValueForKey:@"historyString"];
   };

   return;
}


void BKLogv(BKLogger * log, NSString * ident, NSString * format, va_list arguments)
{
   NSString * message;
   NSString * string;
   NSData   * data;
   BOOL       sendKVO;

   assert(log    != nil);
   assert(format != nil);

   // verify logging is configured
   if (!(log.enabled))
      return;
   if (!(log.mechanismMask))
      return;

   // sets default values
   if (!(ident))
      ident = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];

   // sends notifications
   sendKVO = NO;
   if ((log.mechanismMask & BKLogMechanismHistory))
   {
      [log willChangeValueForKey:@"history"];
      [log willChangeValueForKey:@"historyString"];
      sendKVO = YES;
   };

   [log->_lock lock];

   // forwards message to remote logger
   if ((log->_mechanismMask & BKLogMechanismForward))
      if ((log->_forwardingLog))
         BKLogv(log->_forwardingLog, ident, format, arguments);
   if (!(log->_mechanismMask & (~BKLogMechanismForward)))
   {
      [log->_lock unlock];
      return;
   };

   // generates data
   message = [[NSString alloc] initWithFormat:format arguments:arguments];
   string  = [[NSString alloc] initWithFormat:@"%@ %@[%i:%x] %@\n",
      log.dateString,
      ident,
      [[NSProcessInfo processInfo] processIdentifier],
      pthread_mach_thread_np(pthread_self()),
      message];
   data = [string dataUsingEncoding:NSUTF8StringEncoding];

   // records data
   if ((log->_mechanismMask & BKLogMechanismConsole))
      write(STDERR_FILENO, [data bytes], [data length]);
   if ((log->_mechanismMask & BKLogMechanismHistory))
   {
      [log->_history appendData:data];
      if (log->_history.length > log->_historyMaxSize)
         [log rotateHistory];
   };

   [log->_lock unlock];

   // sends notifications
   if ((sendKVO))
   {
      [log didChangeValueForKey:@"history"];
      [log didChangeValueForKey:@"historyString"];
   };

   return;
}


@end
