/*
 *  Bindle Binaries Objective-C Kit
 *  Copyright (c) 2011, Bindle Binaries
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
 *  BKNode.h - Contains array of arguments
 */

#import <Foundation/Foundation.h>

@interface BKNode : NSObject
{
   NSString       * nodeName;
   id <NSObject>    nodeData;
   NSInteger        nodeType;
   NSMutableArray * nodeSubNodes;
}

@property (nonatomic, strong) NSString      * nodeName;
@property (nonatomic, strong) id <NSObject>   nodeData;
@property (assign, readwrite) NSInteger       nodeType;

#pragma mark - Node management methods

- (id)   initWithName:(NSString *)aName;
- (id)   initWithName:(NSString *)aName andSubName:(NSString *)aSubName;
- (void) initializeSubNodes;
+ (id)   nodeWithName:(NSString *)aName;
+ (id)   nodeWithName:(NSString *)aName andSubName:(NSString *)aSubName;

#pragma mark - Value management methods
- (void)         addSubNode:(BKNode *)anNode;
- (BKNode *)     addSubNodeWithName:(NSString *)aName;
- (BKNode *)     addSubNodeWithName:(NSString *)aName andSubName:(NSString *)aSubName;
- (NSUInteger)   count;
- (void)         removeSubNode:(BKNode *)anNode;
- (void)         removeSubNodeAtIndex:(NSUInteger)index;
- (void)         removeSubNodeWithName:(NSString *)aName;
- (void)         resetSubNodes;
- (BKNode *)     subNodeAtIndex:(NSUInteger)index;
- (NSString *)   subNodeNameAtIndex:(NSUInteger)index;

@end
