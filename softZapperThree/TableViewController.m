//
//  TableViewController.m
//  softZapperThree
//
//  Created by Richard Porter on 14/01/2014.
//  Copyright (c) 2014 QED Productions. All rights reserved.
//

#import "TableViewController.h"
#import "Projector.h"


@implementation TableViewController

- (id) init {
    self = [super init];
    if (self){
        _list = [[NSMutableArray alloc]init];
        wuAvailable = [[NSArray alloc] initWithObjects:@"WUXGA", @"HD", @"SXGA", nil];
        hdAvailable = [[NSArray alloc] initWithObjects: @"HD", @"SXGA", nil];
        sxgaAvailable = [[NSArray alloc] initWithObjects: @"SXGA", nil];
        [_tableView setRowSizeStyle:(NSTableViewRowSizeStyleDefault)];
        NSLog(@"NSTableViewRowSizeStyle = %ld", [_tableView rowHeight]);
        
    
    }
    
    return self;
}



-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [_list count];
}

-(id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    Projector *p  = [_list objectAtIndex:row];
    NSString *identifier = [tableColumn identifier];
    return [p valueForKey:identifier];
    
}

/*- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
    
    if ([aTableColumn.identifier isEqualToString:@"gType"]){
        
    }
    
    Projector *p = [_list objectAtIndex:rowIndex];
    NSLog(@"Selected Projector IP is %@", [p ipAddress]);
    
} */


- (IBAction)addProjector:(id)sender {
    
    Projector *p = [[Projector alloc]init];
    [p setIpAddress:[_ipAddressTextField stringValue]];
    NSComboBoxCell *n = [[NSComboBoxCell alloc]init];
    [n addItemsWithObjectValues:wuAvailable];
    [n setItemHeight:30.0];
    [n selectItemAtIndex:0];
    
    [p setGType:n];
    
    NSTableColumn *theColumn = [_tableView tableColumnWithIdentifier:@"gType"];
    theColumn.dataCell = n;
    
    
    
    [_list addObject:p];

    [_tableView reloadData];

}
@end
