/*
 *  Bindle Binaries Objective-C Kit
 *  Copyright (c) 2013, Bindle Binaries
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
/**
 *  BKLog provides is a replacement for NSLog which is faster and allows
 *  log history to be accessed from within an app.
 *
 *  The following undocumented C functions are available for logging messages
 *  (C functions are not supported by the current documentation generator):
 *
 *      * `BKDebug(format, ...)`              logs debuging information and formatted message to default instance.
 *      * `BKDebug(format, ...)`              logs debuging information and formatted message to default instance.
 *      * `BKDebugWithLog(log, format, ...)`  logs debuging information and formatted message to the specified logger instance.
 *      * `BKLog(format, ...)`                logs the formatted message to the default instance.
 *      * `BKLogWithLog(log, format, ...)`    logs the formatted message to the specified instance.
 *      * `BKLogBytes(bytes, length, offset)` logs binary data as a hex dump to the default instance.
 *      * `BKLogBytesWithLog(log, bytes, length, offset)`  logs binary data as a hex dump to the specified instance.
 */


#import <Foundation/Foundation.h>


enum bindlekit_log_mechanism
{
   BKLogMechanismNone         = 0x0000UL,
   BKLogMechanismConsole      = 0x0001UL,
   BKLogMechanismHistory      = 0x0002UL,
   BKLogMechanismForward      = 0x0004UL,
   BKLogMechanismAll          = 0x0007UL
};
typedef enum bindlekit_log_mechanism BKLogMechanism;


#pragma mark -
@interface BKLogger : NSObject
{
   // log state
   int32_t            _enabled;
   int32_t            _debugEnabled;
   NSRecursiveLock  * _lock;

   // log parameters
   NSString         * _ident;
   NSUInteger         _mechanismMask;
   NSUInteger         _logItemMask;

   // date & time
   NSDateFormatter  * _dateFormatter;

   // log history
   NSMutableData    * _history;
   NSUInteger         _historyMaxSize;

   // Forwarding log
   BKLogger         * _forwardingLog;
}

#pragma mark - Object Management Methods
/// @name Object Management Methods

/// Creates and returns a BKLogger instance.
/// @return A new BKLogger instance.
- (id) init;


/// Returns the shared logging instance.
/// @return The shared BKLog singleton.
+ (BKLogger *) sharedLog;


#pragma mark - Log State
/// @name Log State

/// If set to NO, this logger instance is disabled and will not log data
/// to any mechanism.
@property (nonatomic, assign) BOOL enabled;


/// If set to NO, this logger instance will not log debug messages from
/// BKDebug() or BKDebugWithLog().
@property (nonatomic, assign) BOOL debugEnabled;


#pragma mark - Log Parameters
/// @name Log Parameters

/// The string used to identify the source of each log entry.
@property (nonatomic, retain) NSString   * ident;


/// The mechanisms used to record log entries.
///
/// BKLogMechanism          | Description
/// ------------------------|-------------------------
/// `BKLogMechanismNone`    | No mechanism (0)
/// `BKLogMechanismConsole` | Mechanism for logging to STDERR.
/// `BKLogMechanismHistory` | Mechanism for logging to memory.
/// `BKLogMechanismForward` | Mechanism for logging to another logger instance.
/// `BKLogMechanismAll`     | All Mechanism (~0)
/// @see -setMechanism:toState:, -stateForMechanism:
@property (nonatomic, assign) NSUInteger   mechanismMask;


/// Custom bit mask intended to be used be developers to enable/disable logging
/// of individual items within an application.  The bit values are determined
/// by the developer.
/// @see -setLogItem:toState:, -stateForLogItem:
@property (nonatomic, assign) NSUInteger   logItemMask;


/// Updates the state (enable or disable) of an individual logging mechanism.
/// The type of request the message was initialized to process.
/// @param mechanism  The mechanism whose state is being updated. See -mechanismMask for values.
/// @param state      The new state of the logging mechanism.
/// @see mechanismMask, -stateForMechanism:
- (void) setMechanism:(BKLogMechanism)mechanism toState:(BOOL)state;


/// Updates the state (enable or disable) of an individual log items.
/// @param logItem    The log item whose state is being updated.
/// @param state      The new state of the log item.
/// @see logItemMask, -stateForLogItem:
- (void) setLogItem:(NSUInteger)logItem toState:(BOOL)state;


/// Returns the state (enabled or disabled) of the specified logging memchanism.
/// @param  mechanism The mechanism being queried. See -mechanismMask for values.
/// @return Returns the state of the specified logging mechanism.
/// @see mechanismMask, setMechanism:toState:
- (BOOL) stateForMechanism:(BKLogMechanism)mechanism;


/// Returns the state (enabled or disabled) of the specified log item.
/// @param  logItem   The log item being queried.
/// @return Returns the state of the specified log item.
/// @see logItemMask, -setMechanism:toState:
- (BOOL) stateForLogItem:(NSUInteger)logItem;


#pragma mark - Date & Time
/// @name Date & Time

/// Returns the current date formatted using the logger's date and time format.
/// @return A string containing the formatted string of the current date.
@property (nonatomic, readonly) NSString * dateString;


/// Returns logger's date format.
/// @return A string containing the logger's date format.
@property (nonatomic, retain) NSString * dateFormat;


/// Returns logger's date style.
/// @return The value of the logger's date style.
@property (nonatomic, assign) NSDateFormatterStyle dateStyle;


/// Returns logger's time style.
/// @return The value of the logger's time style.
@property (nonatomic, assign) NSDateFormatterStyle timeStyle;


#pragma mark - Log History
/// @name Log History

/// Returns the unformatted log history.
/// @return The raw data containing the unformatted log history.
@property (nonatomic, readonly) NSData * history;


/// The maximum amount of memory the logger can use to store log history.
/// @return The maximum amount of memory the logger can use to store log history.
@property (nonatomic, assign)   NSUInteger historyMaxLength;


/// Returns the formatted log history.
/// @return The string containing the formatted log history.
@property (nonatomic, readonly) NSString * historyString;

- (void) resetHistory;


#pragma mark - Forwarding Log
/// @name Forwarding Log

/// The logger instance used to forward log messages.
@property (nonatomic, retain) BKLogger * forwardingLog;


#pragma mark - Logging Methods
/// @name Logging Methods

/// Logs binary data as a hex dump.
/// @param bytes    The binary buffer to record.
/// @param length   The length of the binary buffer in bytes.
/// @param offset   The offset value to display in the log entry.
- (void) logBytes:(const uint8_t *)bytes length:(NSUInteger)length
         offset:(NSUInteger)offset;


/// Logs binary data as a hex dump.
/// @param data     The object containing the binary buffer to record.
/// @param offset   The offset value to display in the log entry.
- (void) logData:(NSData *)data offset:(NSUInteger)offset;


/// Logs binary data as a hex dump.
/// @param logItem  The ID of the item to log.
/// @param bytes    The binary buffer to record.
/// @param length   The length of the binary buffer in bytes.
/// @param offset   The offset value to display in the log entry.
- (void) logItem:(NSUInteger)logItem withBytes:(const uint8_t *)bytes
         length:(NSUInteger)length offset:(NSUInteger)offset;


/// Logs binary data as a hex dump.
/// @param logItem  The ID of the item to log.
/// @param data     The object containing the binary buffer to record.
/// @param offset   The offset value to display in the log entry.
- (void) logItem:(NSUInteger)logItem withData:(NSData *)data
         offset:(NSUInteger)offset;


/// Logs a formatted message.
/// @param logItem  The ID of the item to log.
/// @param format   The message format.
/// @param ...      The format arguments.
- (void) logItem:(NSUInteger)logItem withFormat:(NSString *)format, ...;


/// Logs a formatted message.
/// @param format   The message format.
/// @param ...      The format arguments.
- (void) logFormat:(NSString *)format, ...;


#pragma mark - CF logging methods
/// @name CF logging methods

#define BKDebug(format, ...)             BKDebugWithLogFunc([BKLogger sharedLog], __PRETTY_FUNCTION__, format, __VA_ARGS__)
#define BKDebugWithLog(log, format, ...) BKDebugWithLogFunc(log,                  __PRETTY_FUNCTION__, format, __VA_ARGS__)
void BKDebugWithLogFunc(BKLogger * log, const char * pretty, NSString * format, ...);
void BKDebugFunc(const char * pretty, NSString * format, ...);
void BKLogBytes(const uint8_t * bytes, NSUInteger length, NSUInteger offset);
void BKLogBytesWithLog(BKLogger * log, const uint8_t * bytes, NSUInteger length, NSUInteger offset);
void BKLog(NSString * format, ...);
void BKLogWithLog(BKLogger * log, NSString * format, ...);

@end

