//
//  TableViewController.m
//  softZapperThree
//
//  Created by Richard Porter on 14/01/2014.
//  Copyright (c) 2014 QED Productions. All rights reserved.
//

#import "TableViewController.h"
#import "Projector.h"
#import "IPChecker.h"


@implementation TableViewController

- (id) init {
    self = [super init];
    if (self){
        _list = [[NSMutableArray alloc]init];
        wuAvailable = [[NSArray alloc] initWithObjects:@"WUXGA", @"HD", @"SXGA", nil];
        hdAvailable = [[NSArray alloc] initWithObjects: @"HD", @"SXGA", nil];
        sxgaAvailable = [[NSArray alloc] initWithObjects: @"SXGA", nil];
        colours = [[NSArray alloc]initWithObjects:@"Red", @"Green", @"Blue", @"Cyan", @"Magenta", @"Yellow",@"White", nil];
        
           
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

-(void) tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    Projector *p  = [_list objectAtIndex:row];
    NSString *identifier = [tableColumn identifier];
    [p setValue:object forKey:identifier];
    NSLog(@"Projector IP %@ Selected Grid %@",[p ipAddress],[p gType]);

}

/*- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
    
    if ([aTableColumn.identifier isEqualToString:@"gType"]){
        
    }
    
    Projector *p = [_list objectAtIndex:rowIndex];
    NSLog(@"Selected Projector IP is %@", [p ipAddress]);
    
} */


- (IBAction)addProjector:(id)sender {
    
    //Setup an IP Checker for Use
    IPChecker *IPC = [[IPChecker alloc]init];
    NSInteger isIPOk = [IPC checkIPAddress:[_ipAddressTextField stringValue]];
    
    
    if (isIPOk == 1){
    //Create projector object for the row
    Projector *p = [[Projector alloc]init];
    //Set the ipAddress to the ip in the texfield.
    [p setIpAddress:[_ipAddressTextField stringValue]];
    NSComboBoxCell *n = [[NSComboBoxCell alloc]init];
    NSComboBoxCell *col = [[NSComboBoxCell alloc]init];
    [n addItemsWithObjectValues:wuAvailable];
    [n selectItemAtIndex:0];
    [col addItemsWithObjectValues:colours];
    [col selectItemAtIndex:0];
    [p setGType:n];
        [p setColour:col];
    
    NSTableColumn *theColumn = [_tableView tableColumnWithIdentifier:@"gType"];
    theColumn.dataCell = n;
    NSTableColumn *colourColumn = [_tableView tableColumnWithIdentifier:@"colour"];
    colourColumn.dataCell = col;
    
    
    [_list addObject:p];

    [_tableView reloadData];
    }
}

- (IBAction)removeProjector:(id)sender {
    NSInteger row = [_tableView selectedRow];
    if (row !=-1) {
        [_list removeObjectAtIndex:row];
        [_tableView reloadData];
    }

}
@end
