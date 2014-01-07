//
//  AppDelegate.m
//  softZapperThree
//
//  Created by Richard Porter on 07/01/2014.
//  Copyright (c) 2014 QED Productions. All rights reserved.
//

#import "AppDelegate.h"
#import "SingleProjectorWindowController.h"
#import "MultiProjectorWindowController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)SingleProjectorAction:(id)sender {
    
    if (!spWindowController){
        spWindowController = [[SingleProjectorWindowController alloc]initWithWindowNibName:@"singleProjector"];
    }
    [spWindowController showWindow:self];
}

- (IBAction)multiProjectorAction:(id)sender {
    if (! mpWindowController) {
        mpWindowController = [[MultiProjectorWindowController alloc]initWithWindowNibName:@"multiProjector"];
    }
    [mpWindowController showWindow:self];
    
}
@end
