//
//  TableViewController.h
//  softZapperThree
//
//  Created by Richard Porter on 14/01/2014.
//  Copyright (c) 2014 QED Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewController : NSObject <NSTableViewDataSource> {
    
@private NSArray *wuAvailable;
@private NSArray *hdAvailable;
@private NSArray *sxgaAvailable;
    
}

@property IBOutlet NSTableView *tableView;
@property NSMutableArray *list;
@property (weak) IBOutlet NSTextField *ipAddressTextField;

- (IBAction)addProjector:(id)sender;
@end
