/*
 *  Bindle Binaries Objective-C Kit
 *  Copyright (c) 2012 Bindle Binaries
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
 *  BKListController.h - Generic UItableView for displaying data
 */

#import <UIKit/UIKit.h>

@class BKListController;

@protocol BKListControllerDelegate <NSObject>
@optional
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void) listController:(BKListController *)listController
         tableView:(UITableView *)tableView
         didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface BKListController : UITableViewController
{
   // delegates
   id <BKListControllerDelegate> delegate;
   id <UITableViewDataSource>    tableDataSource;
   id <UITableViewDelegate>      tableDelegate;

   // identity
   NSInteger tag;

   // data source selectors
   NSArray  * data;
   SEL        cellTextLabelSelector;
   SEL        cellDetailTextLabelSelector;
   SEL        cellAccessoryViewSelector;
   SEL        cellImageSelector;

   // cell appearance
   UITableViewCellStyle          cellStyle;
   UITableViewCellAccessoryType  cellAccessoryType;
   UITableViewCellSelectionStyle cellSelectionStyle;
}

// delegates
@property (nonatomic, assign) id <BKListControllerDelegate> delegate;
@property (nonatomic, assign) id <UITableViewDataSource>    tableDataSource;
@property (nonatomic, assign) id <UITableViewDelegate>      tableDelegate;

// identity
@property (nonatomic, assign) NSInteger tag;

// data source selectors
@property (nonatomic, retain) NSArray * data;
@property (nonatomic, assign) SEL       cellTextLabelSelector;
@property (nonatomic, assign) SEL       cellDetailTextLabelSelector;
@property (nonatomic, assign) SEL       cellAccessoryViewSelector;
@property (nonatomic, assign) SEL       cellImageSelector;

// cell appearance
@property (nonatomic, assign) UITableViewCellStyle          cellStyle;
@property (nonatomic, assign) UITableViewCellAccessoryType  cellAccessoryType;
@property (nonatomic, assign) UITableViewCellSelectionStyle cellSelectionStyle;

@end
