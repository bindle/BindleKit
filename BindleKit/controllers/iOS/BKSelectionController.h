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
 *  BKSelectionOption.h - Selelection controller for iOS
 */

#import <UIKit/UIKit.h>
#import <BindleKit/BindleKit.h>

#define BKSelectionIndexNone -1

@class BKSelectionController;

#pragma mark -
@protocol BKSelectionDelegate <NSObject>

@optional
- (void) selectionController:(BKSelectionController *)controller clickedIndex:(NSInteger)index;
- (void) selectionController:(BKSelectionController *)controller clickedDescription:(NSString *)description;
- (void) selectionController:(BKSelectionController *)controller clickedValue:(id)value;

@end


#pragma mark -
@interface BKSelectionController : NSObject <UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
   // common state variables
   id <BKSelectionDelegate>   __weak delegate;     // notify object when a selection is made
   NSInteger                  tag;                 // used to identify selection controller
   NSString                 * title;               // title to display for prompts
   UIUserInterfaceIdiom       userInterfaceIdiom;  // should use UIPopoverController or UIPickerView
   NSInteger                  selectedIndex;       // the currently selected option (if any)
   NSMutableArray           * listOfOptions;       // internal list of values/descriptions
   UIViewController         * rootController;      // controller containing the superview
   BOOL                       dataHasChanged;
   BOOL                       isPresented;         // used to track wether the selection is showing or not

   // iPad state variables
   UITableViewController    * tableViewController; // used to provide list of items in popoverController
   UIPopoverController      * popoverController;   // used to display list of options on devices with iPad idiom
   UIView                   * lastSender;          // the last UIButton/UITableViewCell/etc to trigger the selection

   // iPhone state variables
   UIActionSheet            * actionSheet;         // used to animate the appearance of the UIPickerView
   UIPickerView             * pickerView;          // used to display list of options on devices with iPhone idiom
   UINavigationBar          * navigationBar;       // used to dismiss the pickerView
}

@property (nonatomic, weak)   id <BKSelectionDelegate>   delegate;
@property (assign, readwrite) NSInteger                  tag;
@property (nonatomic, strong) NSString                 * title;
@property (nonatomic, strong) NSArray                  * options;
@property (assign, readwrite) NSInteger                  selectedIndex;
@property (nonatomic, strong) id <NSObject>              selectedValue;
@property (nonatomic, strong) NSString                 * selectedDescription;
@property (assign, readonly)  BOOL                       isPresented;

- (id)   initWithRootController:(UIViewController *)aController;

#pragma mark - Options management methods
- (void) addDescription:(NSString *)aDescription;
- (void) addValue:(id)aValue;
- (void) addValue:(id)aValue withDescription:(NSString *)aDescription;
- (void) addValues:(NSArray *)values withDescriptions:(NSArray *)descriptions;
- (void) resetValues;
- (void) setDescriptions:(NSArray *)descriptions;
- (id)   valueAtIndex:(NSUInteger)index;
- (NSString *) descriptionAtIndex:(NSUInteger)index;


#pragma mark - BKSelectionController methods
- (void) dismissSelectionAnimated:(BOOL)animated;
- (void) presentSelectionAnimated:(BOOL)animated;
- (void) presentSelectionAnimated:(BOOL)animated withSender:(id)sender;
- (void) presentSelectionAnimated:(BOOL)animated withTableViewCell:(UITableViewCell *)sender;
- (void) representSelectionAnimated:(BOOL)animated;
- (void) representSelectionAnimated:(BOOL)animated withSender:(id)sender;
- (void) presentSelectionPhoneIdiomAnimated:(BOOL)animated;

@end
