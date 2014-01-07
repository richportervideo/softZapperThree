//
//  AppDelegate.h
//  softZapperThree
//
//  Created by Richard Porter on 07/01/2014.
//  Copyright (c) 2014 QED Productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SingleProjectorWindowController;
@class MultiProjectorWindowController;


@interface AppDelegate : NSObject <NSApplicationDelegate> {
    SingleProjectorWindowController *spWindowController;
    MultiProjectorWindowController *mpWindowController;
    

}


@property (assign) IBOutlet NSWindow *window;

- (IBAction)SingleProjectorAction:(id)sender;

- (IBAction)multiProjectorAction:(id)sender;


@end
