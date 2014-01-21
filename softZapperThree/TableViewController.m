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
#import "ProjectorTypeCheck.h"


@implementation TableViewController

- (id) init {
    self = [super init];
    if (self){
        _list = [[NSMutableArray alloc]init];
        wuAvailable = [[NSArray alloc] initWithObjects:@"WUXGA", @"HD", @"SXGA", nil];
        hdAvailable = [[NSArray alloc] initWithObjects: @"HD", @"SXGA", nil];
        sxgaAvailable = [[NSArray alloc] initWithObjects: @"SXGA", nil];
        colours = [[NSArray alloc]initWithObjects:@"Red", @"Green", @"Blue", @"Cyan", @"Magenta", @"Yellow",@"White", nil];
        
        PTC = [[ProjectorTypeCheck alloc]init];

           
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
    NSLog(@"Projector IP %@ Selected Grid %@ Selected Colour %@",[p ipAddress],[p gType], [p colour] );

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
    NSString *thePTC = [[NSString alloc]init];
    
    if (isIPOk == 1){
    
        thePTC = [PTC doTheCheck:[_ipAddressTextField stringValue]];
    } else{
        return;
    }
    
    //if projector passes IP test add it to the Table View
    NSLog(@"thePTC %@", thePTC);
    
    if ((isIPOk == 1)&&((![thePTC isEqualToString:@"CheckFailed"])))    {
    //Create projector object for the row
    Projector *p = [[Projector alloc]init];
    //Set the ipAddress to the ip in the texfield.
    [p setIpAddress:[_ipAddressTextField stringValue]];
        
    //Alloc the gType ComboboxCell
    NSComboBoxCell *n = [[NSComboBoxCell alloc]init];
    //Alloc the colour ComboboxCell
    NSComboBoxCell *col = [[NSComboBoxCell alloc]init];
        
    // Setup Column data that relies on the [PTC thePanelRes] outcome
        if ((![[PTC thePanelRes] isEqualToString:@"CheckFailed"])){
            if ([[PTC thePanelRes]isEqualToString:@"1200"]){
                [p setPType:@"WUXGA"];
                [n addItemsWithObjectValues:wuAvailable];
                [n selectItemAtIndex:0];
            } else if ([[PTC thePanelRes]isEqualToString:@"1080"]){
                [p setPType:@"HD"];
                [n addItemsWithObjectValues:hdAvailable];
                [n selectItemAtIndex:0];
            } else if ([[PTC thePanelRes]isEqualToString:@"1050"]){
                [p setPType:@"SXGA"];
                [n addItemsWithObjectValues:sxgaAvailable];
                [n selectItemAtIndex:0];
            } else {
                [p setPType:@"CheckFailed"];
            }
        }
    
    
    // Finish initalising column data for the projector
    [col addItemsWithObjectValues:colours];
    [col selectItemAtIndex:0];
    [p setGType:n];
    [p setColour:col];
    
    // Insert all setup data into the right place
    NSTableColumn *theColumn = [_tableView tableColumnWithIdentifier:@"gType"];
    theColumn.dataCell = n;
    NSTableColumn *colourColumn = [_tableView tableColumnWithIdentifier:@"colour"];
    colourColumn.dataCell = col;
    
    // Add projector to the Table Array
    [_list addObject:p];

    //Reload the table
    [_tableView reloadData];
    }
}

- (IBAction)removeProjector:(id)sender {
    NSInteger row = [_tableView selectedRow];
    [_tableView abortEditing];
    if (row !=-1) {
        [_list removeObjectAtIndex:row];
        [_tableView reloadData];
    }

}

- (IBAction)testCheck:(id)sender {
    

    
}
@end
