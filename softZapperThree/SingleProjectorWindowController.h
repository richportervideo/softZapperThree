//
//  SingleProjectorWindowController.h
//  softZapperThree
//
//  Created by Richard Porter on 07/01/2014.
//  Copyright (c) 2014 QED Productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SColourComboDS.h"

@interface SingleProjectorWindowController : NSWindowController <NSStreamDelegate>{
    SColourComboDS *SCCDataSource;
}

@property (weak) IBOutlet NSTextField *ipAddressTextBox;
@property (weak) IBOutlet NSComboBox *gridComboBox;
@property (weak) IBOutlet NSComboBox *colourComboBox;

- (IBAction)closeAction:(id)sender;


@end
