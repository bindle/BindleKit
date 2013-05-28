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

/// Returns the shared logging instance.
/// @return The shared BKLog singleton.
+ (BKLogger *) sharedLog;


#pragma mark - Log State
/// @name Log State

@property (nonatomic, assign) BOOL enabled;


#pragma mark - Log Parameters
/// @name Log Parameters

@property (nonatomic, retain) NSString   * ident;
@property (nonatomic, assign) NSUInteger   mechanismMask;
@property (nonatomic, assign) NSUInteger   logItemMask;

- (void) setMechanism:(BKLogMechanism)mechanism toState:(BOOL)state;
- (void) setLogItem:(NSUInteger)logItem toState:(BOOL)state;
- (BOOL) stateForMechanism:(BKLogMechanism)mechanism;
- (BOOL) stateForLogItem:(NSUInteger)logItem;

#pragma mark - Date & Time
/// @name Date & Time

@property (nonatomic, readonly) NSString * dateString;
@property (nonatomic, retain)   NSString * dateFormat;
@property (nonatomic, assign)   NSDateFormatterStyle  dateStyle;
@property (nonatomic, assign)   NSDateFormatterStyle  timeStyle;


#pragma mark - Log History
/// @name Log History

@property (nonatomic, readonly) NSData     * history;
@property (nonatomic, assign)   NSUInteger   historyMaxLength;
@property (nonatomic, readonly) NSString   * historyString;

- (void) resetHistory;


#pragma mark - Forwarding Log
/// @name Forwarding Log

@property (nonatomic, retain) BKLogger * forwardingLog;


#pragma mark - Logging Methods
/// @name Logging Methods

- (void) logBytes:(const uint8_t *)bytes length:(NSUInteger)length
         offset:(NSUInteger)offset;
- (void) logData:(NSData *)data offset:(NSUInteger)offset;
- (void) logItem:(NSUInteger)logItem withBytes:(const uint8_t *)bytes
         length:(NSUInteger)length offset:(NSUInteger)offset;
- (void) logItem:(NSUInteger)logItem withData:(NSData *)data
         offset:(NSUInteger)offset;
- (void) logItem:(NSUInteger)logItem withFormat:(NSString *)format, ...;
- (void) logFormat:(NSString *)format, ...;


#pragma mark - CF logging methods
/// @name CF logging methods

#define BKDebug(format, ...) BKDebugFunc(__PRETTY_FUNCTION__, format, __VA_ARGS__)
#define BKDebugWithLog(log, format, ...) BKDebugFunc(log, __PRETTY_FUNCTION__,format, __VA_ARGS__)
void BKDebugWithLogFunc(BKLogger * log, const char * pretty, NSString * format, ...);
void BKDebugFunc(const char * pretty, NSString * format, ...);
void BKLogBytes(const uint8_t * d, NSUInteger len, NSUInteger off);
void BKLog(NSString * format, ...);
void BKLogWithLog(BKLogger * log, NSString * format, ...);

@end

