//
//  SingleProjectorWindowController.m
//  softZapperThree
//
//  Created by Richard Porter on 07/01/2014.
//  Copyright (c) 2014 QED Productions. All rights reserved.
//

#import "SingleProjectorWindowController.h"
#import "SColourComboDS.h"
#import "SimplePingHelper.h"

@class SColourComboDS;
@class SGridComboDS;

@interface SingleProjectorWindowController ()

@end

@implementation SingleProjectorWindowController{
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    NSString * _ipAddress;
    NSArray *_sxga_sxga, *_hd_sxga, *_hd_hd, *_wuxga_sxga, *_wuxga_hd, *_wuxga_wuxga, *_wuxgaAvailable, *_hdAvailable, *_sxgaAvailable, *_nothingAvailable;
    NSString *R, *G, *B, *C, *Y, *M, *W, *_shadedRGB, *_chosenProjector, *_userRGB, *_pingReadout, *_drawCallFinished, *_panelSize;
    int _gridBoxesWide, _gridBoxesHigh, _centerLeft, _centerRight, _middleTop, _middleBottom, _gridsize, _delayBtwLines, _thePort, eveythingsOk, _hasProjectorBeenChecked;
    double _delayInSeconds, _tinyDelay;
    NSArray *_projGrid;
    NSArray *_colours;
    NSMutableArray *_availableProjectors;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    //Set IP Manually for testing and laziness.
    _ipAddress = @"192.168.15.4";
    [_ipAddressTextBox setStringValue: _ipAddress];
    _thePort = 3002;
    _hasProjectorBeenChecked = 0;
    
    //Colour Choices
    R = @" 255 0 0)";
    G = @" 0 255 0)";
    B = @" 0 0 255)";
    C = @" 0 255 255)";
    Y = @" 255 255 0)";
    M = @" 255 0 255)";
    W = @" 255 255 255)";
    _shadedRGB = @" 64 64 64)";
    
    _nothingAvailable = [NSArray arrayWithObjects:@"Please Check projector", nil];
    _wuxgaAvailable = [NSArray arrayWithObjects:@"SXGA", @"HD", @"WUXGA", nil];
    _hdAvailable = [NSArray arrayWithObjects:@"SXGA", @"HD", nil];
    _sxgaAvailable = [NSArray arrayWithObjects:@"SXGA", nil];

    //_serRGB - Set to red for testing purposes
    _userRGB = R;

    // the following 6 arrays are the values required to draw the blending grids in the varous scenarios
    // proj_grid = {xLineStart, yLineStart, xLineStop, yLineStop, hShadeStart, vShadeStart, hShadeWidth, vShadeHeight, xGrid, yGrid, xPanel, yPanel}
    _sxga_sxga = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0],[NSNumber numberWithInt:1139],[NSNumber numberWithInt:1049], [NSNumber numberWithInt:512], [NSNumber numberWithInt:640], [NSNumber numberWithInt:24], [NSNumber numberWithInt:118], [NSNumber numberWithInt:1399], [NSNumber numberWithInt:1049], [NSNumber numberWithInt:1400], [NSNumber numberWithInt:1050], nil];
    _hd_sxga = [NSArray arrayWithObjects:[NSNumber numberWithInt:260], [NSNumber numberWithInt:15],[NSNumber numberWithInt:1659],[NSNumber numberWithInt:1064], [NSNumber numberWithInt:528], [NSNumber numberWithInt:901], [NSNumber numberWithInt:24], [NSNumber numberWithInt:118], [NSNumber numberWithInt:1399], [NSNumber numberWithInt:1049], [NSNumber numberWithInt:1920], [NSNumber numberWithInt:1080], nil]; //VERIFIED
    _hd_hd = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0],[NSNumber numberWithInt:1919],[NSNumber numberWithInt:1079], [NSNumber numberWithInt:512], [NSNumber numberWithInt:897], [NSNumber numberWithInt:55], [NSNumber numberWithInt:126], [NSNumber numberWithInt:1919], [NSNumber numberWithInt:1079], [NSNumber numberWithInt:1920], [NSNumber numberWithInt:1080], nil]; //VERIFIED
    _wuxga_sxga = [NSArray arrayWithObjects:[NSNumber numberWithInt:260], [NSNumber numberWithInt:75],[NSNumber numberWithInt:1659],[NSNumber numberWithInt:1124], [NSNumber numberWithInt:588], [NSNumber numberWithInt:901], [NSNumber numberWithInt:24], [NSNumber numberWithInt:118], [NSNumber numberWithInt:1399], [NSNumber numberWithInt:1049], [NSNumber numberWithInt:1920], [NSNumber numberWithInt:1200], nil];
    _wuxga_hd = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:60],[NSNumber numberWithInt:1919],[NSNumber numberWithInt:1139], [NSNumber numberWithInt:573], [NSNumber numberWithInt:897], [NSNumber numberWithInt:54], [NSNumber numberWithInt:126], [NSNumber numberWithInt:1919], [NSNumber numberWithInt:1179], [NSNumber numberWithInt:1920], [NSNumber numberWithInt:1200], nil];
    _wuxga_wuxga = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0],[NSNumber numberWithInt:1919],[NSNumber numberWithInt:1199], [NSNumber numberWithInt:577], [NSNumber numberWithInt:897], [NSNumber numberWithInt:46], [NSNumber numberWithInt:126], [NSNumber numberWithInt:1919], [NSNumber numberWithInt:1199], [NSNumber numberWithInt:1920], [NSNumber numberWithInt:1200], nil];

    
    _gridsize = 64;
    _delayBtwLines = 50;
    _delayInSeconds = 0.05f;
    _tinyDelay = 0.01f;
    
    
    SCCDataSource = [[SColourComboDS alloc]init];
    SGCDataSource = [[SGridComboDS alloc]init];
    
    //Set up colours array
    _colours = [NSArray arrayWithObjects:@"Red", @"Green", @"Blue", @"Cyan", @"Magenta", @"Yellow",@"White", nil];
    //Dummy Data to test _gridcombobox
    _availableProjectors = [NSMutableArray arrayWithArray:_nothingAvailable];
    [_zapOutlet setEnabled:NO];
    
    
    [SCCDataSource setColourItems:_colours];
    [SGCDataSource setGridItems:_availableProjectors];
    
    [_colourComboBox setDataSource:SCCDataSource];
    [_colourComboBox setUsesDataSource:YES];
    [_colourComboBox selectItemAtIndex:0];
    [_gridComboBox setDataSource:SGCDataSource];
    [_gridComboBox setUsesDataSource:YES];
    [_gridComboBox selectItemAtIndex:0];
    
    
    
    }

//Runs when the user presses ZAP!
- (IBAction)zapAction:(id)sender {
    
    
    //Get IP Address
    
    int ipselfcheck = [self checkIPAdress];
    NSLog(@"ipselftest returned:%i", ipselfcheck);
    
    
    NSLog(@"Port number is set to %d", _thePort);
    
    //Start the Network stream to the projector
    
    [self initNetworkCommunication];
    if ([_drawOnSegment selectedSegment] == 0) {
            [self sendThisMessage:@"(ITP5)"];
            NSLog(@"Sent (ITP5) for draw on black");
        }
        [self sendThisMessage:@"(UTP0)"];
        [self setupZap];
        [self drawCall];
        
        
        NSLog(@"ZAPCALL: drawCallFinished: %@", _drawCallFinished);
}





- (IBAction)checkProjectorAction:(id)sender {
    
    [_checkOutlet setEnabled:NO];
    
    [self setTheIPAdress];
    
    [self initNetworkCommunication];
    
    _panelSize = nil;
    
    [_checkedLabel setStringValue:@"Checking"];
    [_checkedLabel setTextColor:[NSColor orangeColor]];
    
    [self performSelectorOnMainThread:@selector(checkIPAdress) withObject:nil waitUntilDone:YES];
    
    
    [self sendThisMessage:@"(SST+CONF?5 0)"];
    
    
}

-(void)setTheIPAdress {
    
    if ((![_ipAddress isEqual: @""])){
        NSLog(@"IP Address is set to %@", _ipAddress);
    } else if(![[_ipAddressTextBox stringValue] isEqual: @""]){
        _ipAddress = [_ipAddressTextBox stringValue];
        NSLog(@"IP Address is set to %@", _ipAddress);
    }
    
}


// Choose Color Combo Box switch
-(void)chooseColour{
    NSInteger theIndex = [_colourComboBox indexOfSelectedItem];
    switch (theIndex) {
        case 0:
            _userRGB = R;
            break;
        case 1:
            _userRGB = G;
            break;
        case 2:
            _userRGB = B;
            break;
        case 3:
            _userRGB = C;
            break;
        case 4:
            _userRGB = M;
            break;
        case 5:
            _userRGB = Y;
            break;
        case 6:
            _userRGB = W;
            break;
        default:
            _userRGB = R;
            break;
    }
    
}

// Chose Grid Combo Box switch
-(void)whatGrid{
    NSInteger comboBoxIndex = [_gridComboBox indexOfSelectedItem];
    NSLog(@"Combobox Index is %li", (long)comboBoxIndex);
    
    if ([_panelSize isEqualToString:@"WUXGA"]){
        switch (comboBoxIndex) {
            case 0:
                _projGrid = _wuxga_sxga;
                _chosenProjector = @"_wuxga_sxga";
                break;
            case 1:
                _projGrid = _wuxga_hd;
                _chosenProjector = @"_wuxga_hd";
                break;
            case 2:
                _projGrid = _wuxga_wuxga;
                _chosenProjector = @"_wuxga_wuxga";
                break;
            default:
                break;
        }
        }else if ([_panelSize isEqualToString:@"HD"]){
            switch (comboBoxIndex) {
                case 0:
                    _projGrid = _hd_sxga;
                    _chosenProjector = @"_hd_sxga";
                    break;
                case 1:
                    _projGrid = _hd_hd;
                    _chosenProjector = @"_hd_hd";
                default:
                    break;
            }
            } else if ( [_panelSize isEqualToString:@"SXGA"]){
                switch (comboBoxIndex) {
                    case 0:
                        _projGrid = _sxga_sxga;
                         _chosenProjector = @"_sxga_sxga";
                        break;
                    default:
                        break;
                }
                } else {
                    NSLog(@"WhatGridFault");
                }
            }
//Close window
- (IBAction)closeAction:(id)sender {
    [self close];
}

//Broke the setup calls off into their own method. Makes the zapAction method easier to read.
-(void)setupZap{
    
    NSLog(@"");
    NSLog(@"STARTING SETUP");
    NSLog(@"=============================");
    //Get the desired grid...
    [self whatGrid];
    NSLog(@"Chosen Projector is %@", _chosenProjector);
    
    //Set _gridBoxesWide
    _gridBoxesWide = ([[_projGrid objectAtIndex:8]integerValue]/_gridsize + 1);
    NSLog(@"_gridBoxesWide == %d", _gridBoxesWide);
    
    //Set _gridBoxesHigh
    _gridBoxesHigh = ([[_projGrid objectAtIndex:9]integerValue]/(_gridsize + 1));
    NSLog(@"_gridBoxesWide == %d", _gridBoxesHigh);
    
    //Set _centerLeft
    _centerLeft = ([[_projGrid objectAtIndex:10]integerValue]/2);
    NSLog(@"_centerLeft == %d", _centerLeft);
    
    //set _centerRight
    _centerRight = _centerLeft +1;
    NSLog(@"_centerRight == %d", _centerRight);
    
    //set _middleTop
    _middleTop = ([[_projGrid objectAtIndex:11]integerValue]/2);
    NSLog(@"_middleTop == %d", _middleTop);
    
    //Set grid colour
    [self chooseColour];
    
    //set _middleBottom
    _middleBottom = _middleTop +1;
    NSLog(@"_middleBottom == %d", _middleBottom);
    
    NSLog(@"=============================");
    
}


//Draws the grid yo!
-(void) drawCall {
    NSLog(@"Inititated Draw Call...");
    NSLog(@"drawCallFinished:%@", _drawCallFinished);
    NSDate *drawCallStart = [NSDate date];
    
    int i = 0;
    while (i < [[_projGrid objectAtIndex:7] integerValue]){
        [self sendThisMessage:@"(UTP5 "];
        [self sendThisMessage:([NSString stringWithFormat:@"%ld",([[_projGrid objectAtIndex:5] integerValue]+i)])];
        [self sendThisMessage:@" "];
        [self sendThisMessage:([NSString stringWithFormat:@"%ld",(long)[[_projGrid objectAtIndex:1] integerValue]])];
        [self sendThisMessage:@" "];
        [self sendThisMessage:([NSString stringWithFormat:@"%d",([[_projGrid objectAtIndex:5] integerValue]+i)])];
        [self sendThisMessage:@" "];
        [self sendThisMessage:([NSString stringWithFormat:@"%ld",(long)[[_projGrid objectAtIndex:3] integerValue]])];
        [self sendThisMessage:_shadedRGB];
        //NSLog(@"Vertical Shading has executed %i times", i);
        [NSThread sleepForTimeInterval:_tinyDelay];
        i++;
    }
    i = 0;
    while (i < [[_projGrid objectAtIndex:6]integerValue]){
        [self sendThisMessage:@"(UTP5 "];
        [self sendThisMessage:[NSString stringWithFormat:@"%ld",
                               (long)
                               ([[_projGrid objectAtIndex:0] integerValue])]];
        [self sendThisMessage:@" "];
        [self sendThisMessage:([NSString stringWithFormat:@"%d",([[_projGrid objectAtIndex:4] integerValue]+i)])];
        [self sendThisMessage:@" "];
        [self sendThisMessage:([NSString stringWithFormat:@"%ld",(long)[[_projGrid objectAtIndex:2] integerValue]])];
        [self sendThisMessage:@" "];
        [self sendThisMessage:([NSString stringWithFormat:@"%d",([[_projGrid objectAtIndex:4] integerValue]+i)])];
        [self sendThisMessage:_shadedRGB];
        // NSLog(@"Horizontal Shading has executed %i times", i);
        [NSThread sleepForTimeInterval:_tinyDelay];
        i++;
    }
    i = 0;
    
    while (i < (_gridBoxesWide/2) ){
        //vert lines from left edge to center
        [self sendThisMessage:@"(UTP5 "];
        [self sendThisMessage:[NSString stringWithFormat:@"%d",([[_projGrid objectAtIndex:0] integerValue]+(i * _gridsize))]];
        [self sendThisMessage:@" "];
        [self sendThisMessage
         
         :([NSString stringWithFormat:@"%ld",(long)[[_projGrid objectAtIndex:1] integerValue]])];
        [self sendThisMessage:@" "];
        [self sendThisMessage:[NSString stringWithFormat:@"%d",([[_projGrid objectAtIndex:0] integerValue]+(i * _gridsize))]];
        [self sendThisMessage:@" "];
        [self sendThisMessage:([NSString stringWithFormat:@"%ld",(long)[[_projGrid objectAtIndex:3] integerValue]])];
        [self sendThisMessage:_userRGB];
        //NSLog(@"VertLeft to Center Shading has executed %i times", i);
        [NSThread sleepForTimeInterval:_delayInSeconds];
        //vert lins from right edge to center
        [self sendThisMessage:@"(UTP5 "];
        [self sendThisMessage:[NSString stringWithFormat:@"%d",([[_projGrid objectAtIndex:2] integerValue]-(i * _gridsize))]];
        [self sendThisMessage:@" "];
        [self sendThisMessage:([NSString stringWithFormat:@"%ld",(long)[[_projGrid objectAtIndex:1] integerValue]])];
        [self sendThisMessage:@" "];
        [self sendThisMessage:[NSString stringWithFormat:@"%d",([[_projGrid objectAtIndex:2] integerValue]-(i * _gridsize))]];
        [self sendThisMessage:@" "];
        [self sendThisMessage:([NSString stringWithFormat:@"%ld",(long)[[_projGrid objectAtIndex:3] integerValue]])];
        [self sendThisMessage:_userRGB];
        
        // NSLog(@"VertRight to Center Shading has executed %i times", i);
        [NSThread sleepForTimeInterval:_delayInSeconds];
        i++;
    }
    //Center 2 px VT
    [self sendThisMessage:@"(UTP5 "];
    [self sendThisMessage:[NSString stringWithFormat:@"%d", _centerLeft]];
    [self sendThisMessage:@" "];
    [self sendThisMessage:([NSString stringWithFormat:@"%ld",(long)[[_projGrid objectAtIndex:1] integerValue]])];
    [self sendThisMessage:@" "];
    [self sendThisMessage:[NSString stringWithFormat:@"%d", _centerLeft]];
    [self sendThisMessage:@" "];
    [self sendThisMessage:([NSString stringWithFormat:@"%ld",(long)[[_projGrid objectAtIndex:3] integerValue]])];
    [self sendThisMessage:_userRGB];
    [NSThread sleepForTimeInterval:0.02f];
    [self sendThisMessage:@"(UTP5 "];
    [self sendThisMessage:[NSString stringWithFormat:@"%d", _centerRight]];
    [self sendThisMessage:@" "];
    [self sendThisMessage:([NSString stringWithFormat:@"%ld",(long)[[_projGrid objectAtIndex:1] integerValue]])];
    [self sendThisMessage:@" "];
    [self sendThisMessage:[NSString stringWithFormat:@"%d", _centerRight]];
    [self sendThisMessage:@" "];
    [self sendThisMessage:([NSString stringWithFormat:@"%ld",(long)[[_projGrid objectAtIndex:3] integerValue]])];
    [self sendThisMessage:_userRGB];
    [NSThread sleepForTimeInterval:_delayInSeconds];
    i = 0;
    
    while (i < ((_gridBoxesHigh/2)+1)) {
        //Horizontal lines from top to middle
        [self sendThisMessage:@"(UTP5 "];
        [self sendThisMessage:[NSString stringWithFormat:@"%ld",(long)([[_projGrid objectAtIndex:0] integerValue])]];
        [self sendThisMessage:@" "];
        [self sendThisMessage:([NSString stringWithFormat:@"%d",[[_projGrid objectAtIndex:1] integerValue]+(i * _gridsize)])];
        [self sendThisMessage:@" "];
        [self sendThisMessage:[NSString stringWithFormat:@"%ld",(long)([[_projGrid objectAtIndex:2] integerValue])]];
        [self sendThisMessage:@" "];
        [self sendThisMessage:([NSString stringWithFormat:@"%d",[[_projGrid objectAtIndex:1] integerValue]+(i * _gridsize)])];
        [self sendThisMessage:_userRGB];
        [NSThread sleepForTimeInterval:_delayInSeconds];
        //Horizontal lins from bottom to middle
        [self sendThisMessage:@"(UTP5 "];
        [self sendThisMessage:[NSString stringWithFormat:@"%ld",(long)([[_projGrid objectAtIndex:0] integerValue])]];
        [self sendThisMessage:@" "];
        [self sendThisMessage:([NSString stringWithFormat:@"%d",[[_projGrid objectAtIndex:3] integerValue]-(i * _gridsize)])];
        [self sendThisMessage:@" "];
        [self sendThisMessage:[NSString stringWithFormat:@"%ld",(long)([[_projGrid objectAtIndex:2] integerValue])]];
        [self sendThisMessage:@" "];
        [self sendThisMessage:([NSString stringWithFormat:@"%d",[[_projGrid objectAtIndex:3] integerValue]-(i * _gridsize)])];
        [self sendThisMessage:_userRGB];
        [NSThread sleepForTimeInterval:0.02f];
        i++;
    }
    //Center 2 px HZ
    [self sendThisMessage:@"(UTP5 "];
    [self sendThisMessage:[NSString stringWithFormat:@"%ld", (long)([[_projGrid objectAtIndex:0] integerValue])]];
    [self sendThisMessage:@" "];
    [self sendThisMessage:([NSString stringWithFormat:@"%d", _middleTop ])];
    [self sendThisMessage:@" "];
    [self sendThisMessage:([NSString stringWithFormat:@"%ld", (long)[[_projGrid objectAtIndex:2] integerValue]])];
    [self sendThisMessage:@" "];
    [self sendThisMessage:([NSString stringWithFormat:@"%d", _middleTop ])];
    [self sendThisMessage:_userRGB];
    [NSThread sleepForTimeInterval:_delayInSeconds];
    [self sendThisMessage:@"(UTP5 "];
    [self sendThisMessage:[NSString stringWithFormat:@"%ld", (long)([[_projGrid objectAtIndex:0] integerValue])]];
    [self sendThisMessage:@" "];
    [self sendThisMessage:([NSString stringWithFormat:@"%d", _middleBottom ])];
    [self sendThisMessage:@" "];
    [self sendThisMessage:([NSString stringWithFormat:@"%ld", (long)[[_projGrid objectAtIndex:2] integerValue]])];
    [self sendThisMessage:@" "];
    [self sendThisMessage:([NSString stringWithFormat:@"%d", _middleBottom ])];
    [self sendThisMessage:_userRGB];
    [NSThread sleepForTimeInterval:_delayInSeconds];
    
    NSDate *drawCallFinish = [NSDate date];
    NSTimeInterval drawLength = [drawCallFinish timeIntervalSinceDate:drawCallStart];
    NSLog(@"...drawcalls take %f seconds", drawLength);
    
    NSLog(@"Reached the end of the draw calls");
    NSString* str = @"Done!";
    _drawCallFinished = str;
    
    
    [inputStream close];
    [outputStream close];
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
}

- (void)sendThisMessage:(NSString*)message{
    
    NSString *response  = [NSString stringWithFormat:@"%@", message ];
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write:[data bytes] maxLength:[data length]];
    
    // NSLog(@"%@ just written to ipAddress:%@", response, _ipAddress);
    
}

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, CFBridgingRetain(_ipAddress), 3002, &readStream, &writeStream);
    inputStream = (NSInputStream *)CFBridgingRelease(readStream);
    outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
}
#pragma mark NSStream delegate

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
	switch (streamEvent) {
            
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
			break;
            
		case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                
                uint8_t buffer[4096];
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                            [self messageRecieved:output];
                        }
                    }
                }
            }
			break;
            
		case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host!");
			break;
            
		case NSStreamEventEndEncountered:
			
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            
            break;
            
		default:
			NSLog(@"Unknown event");
	}
    
}
-(void) messageRecieved:(NSString *)message{
    
    long incomingLength = [message length];
    
    NSLog(@"Incoming length = %ld", incomingLength);
    
    if(message.length == 68){
        NSLog(@"Thinking this is a HD18, Better have another check...");
        [self sendThisMessage:@"(SST?0 3)"];
    } else if(message.length == 57){
        NSLog(@"Yeah, We've found a TIPM!");
        [self looksLikeATIPM:message];
    }else if(message.length == 71){
        NSLog(@"Thinking this is a WU");
        [self looksLikeAnM:message];
    } else {
        NSLog(@"Yeah We've got problems");
    }
    
    
}

-(void)looksLikeATIPM:(NSString *)message {
    
    NSString *firstCharacter = [NSString stringWithFormat:@"%c",[message characterAtIndex:32]];
    NSString *secondCharacter = [NSString stringWithFormat:@"%c",[message characterAtIndex:33]];
    NSString *thirdCharacter = [NSString stringWithFormat:@"%c",[message characterAtIndex:34]];
    NSString *fourthCharacter = [NSString stringWithFormat:@"%c",[message characterAtIndex:35]];
    
    NSMutableString *panelRes = [NSMutableString stringWithCapacity:4];
    [panelRes appendString: firstCharacter];
    [panelRes appendString: secondCharacter];
    [panelRes appendString: thirdCharacter];
    [panelRes appendString: fourthCharacter];
    
    //NSLog(@"Vertical Panel Resolutions %@", panelRes);
    [self verticalHeight:panelRes];
    
    
}


-(void)looksLikeAnM:(NSString *)message{
    
    //NSLog(@"Looks like its an M Series.");
    NSString *firstCharacter = [NSString stringWithFormat:@"%c",[message characterAtIndex:32]];
    NSString *secondCharacter = [NSString stringWithFormat:@"%c",[message characterAtIndex:33]];
    NSString *thirdCharacter = [NSString stringWithFormat:@"%c",[message characterAtIndex:34]];
    NSString *fourthCharacter = [NSString stringWithFormat:@"%c",[message characterAtIndex:35]];
    
    NSMutableString *panelRes = [NSMutableString stringWithCapacity:4];
    [panelRes appendString: firstCharacter];
    [panelRes appendString: secondCharacter];
    [panelRes appendString: thirdCharacter];
    [panelRes appendString: fourthCharacter];
    
    //NSLog(@"Vertical Panel Resolutions %@", panelRes);
    [self verticalHeight:panelRes];
    
}
-(void)verticalHeight:(NSString *)panelRes{
    
    _hasProjectorBeenChecked = 1;
    [_zapOutlet setEnabled:YES];
    
    if ([panelRes isEqualToString:@"1200"]) {
        [_checkedLabel setTextColor:[NSColor greenColor]];
        [_checkedLabel setStringValue:@"WUXGA"];
        _availableProjectors = [NSMutableArray arrayWithObjects:_wuxga_sxga,_wuxga_hd,_wuxga_wuxga, nil];
        [SGCDataSource setGridItems: _wuxgaAvailable];
        [_gridComboBox reloadData];
        [_gridComboBox selectItemAtIndex:0];
        [_checkOutlet setEnabled:YES];
        _panelSize = @"WUXGA";
    } else if ([panelRes isEqualToString:@"1080"]){
        [_checkedLabel setTextColor:[NSColor greenColor]];
        [_checkedLabel setStringValue:@"HD"];
        _availableProjectors = [NSMutableArray arrayWithObjects:_hd_sxga,_hd_sxga, nil];
        [SGCDataSource setGridItems:_hdAvailable];
        [_gridComboBox reloadData];
        [_checkOutlet setEnabled:YES];
        _panelSize = @"HD";
    } else if ([panelRes isEqualToString:@"1050"]){
        [_checkedLabel setTextColor:[NSColor greenColor]];
        [_checkedLabel setStringValue:@"SXGA"];
        _availableProjectors = [NSMutableArray arrayWithObjects:_hd_sxga,_hd_sxga, nil];
        [SGCDataSource setGridItems:_hdAvailable];
        [_gridComboBox reloadData];
        [_checkOutlet setEnabled:YES];
        _panelSize = @"SXGA";
    } else {
        NSLog(@"Swing and a miss...");
    }
    
}

//Full IP Check method. Returns 1 if Happy 0 if Sad
-(int) checkIPAdress {
    
    if (![_ipAddress  isEqual: @""]){
        
    } else {
        eveythingsOk = 0;
        NSLog(@"IP VALUE IS EMPTY");
        /*UIAlertView *invalidIP = [[UIAlertView alloc]
                                  initWithTitle:@"Invaild IP Adderess"
                                  message:@"Please input a vaild IP Address"
                                  delegate:nil
                                  cancelButtonTitle:@"Continue"
                                  otherButtonTitles:nil];
        [invalidIP show]; */
    }
    
    if ( [self validateUrl:_ipAddress] ==1){
        
        NSLog(@"IP Format Check Passed. Looks like a valid IP: xx.xx.xx.xx");
    } else {
        eveythingsOk = 0;
        NSLog(@"WRONG FORMAT IP");
        /*UIAlertView *invalidFormatIP = [[UIAlertView alloc]
                                        initWithTitle:@"Invaild IP Adderess"
                                        message:@"Please input IP with format xx.xx.xx.xx"
                                        delegate:nil
                                        cancelButtonTitle:@"Continue"
                                        otherButtonTitles:nil];
        [invalidFormatIP show]; */
        
    }
    
    _pingReadout = nil;
    [self tapPing:_ipAddress];
    
    while (_pingReadout == nil){
        [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [NSThread sleepForTimeInterval:0.05f];
    [self checkPingReadout];
    
    
    return eveythingsOk;
}

// Checks to see if simple ping was a success. Opens UIAlerrt and Flags everythingsOK if ping fails
-(void)checkPingReadout{
    
    if ([_pingReadout  isEqual: @"SUCCESS"]){
        NSLog(@"Ping Success %@", _ipAddress);
    } else if ([_pingReadout  isEqual: @"FAIL"]){
        NSLog(@"Ping Fail %@", _ipAddress);
        NSAlert *ipAlert = [[NSAlert alloc]init];
        [ipAlert setMessageText:@"Can not reach IP"];
        [ipAlert addButtonWithTitle:@"Bad Times"];
        [ipAlert runModal];
        
        [inputStream close];
        [outputStream close];
        
        [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [_checkedLabel setStringValue:@"FAIL"];
        
        NSLog(@"RUN checkPingReadout");
    }
    
    
}


// This method checks to see if the input ip address consists of 4 quads separated by dots.
- (int) validateUrl: (NSString *) ipAddressStr{
    NSString *ipValidStr = ipAddressStr;
    NSString *ipRegEx =
    @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", ipRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:ipValidStr];
    
    //NSLog(@"myStringMatchesRegEx = %d ",myStringMatchesRegEx);
    if (myStringMatchesRegEx){
        return 1;
    } else {
        return 0;
    }
    
}

// Next 3 Methods part of PingHelper. Used to Ping the input IP before passing it to the initcommunications method.

- (void)tapPing: (NSString*)testIP {
    
    [SimplePingHelper ping:testIP target:self sel:@selector(pingResult:)];
}

- (void)pingResult:(NSNumber*)success {
    
    if (success.boolValue) {
        
        [self log:@"SUCCESS"];
    } else {
        
        [self log:@"FAIL"];
    }
}

- (void)log:(NSString*)str {
	//self.results.text = [NSString stringWithFormat:@"%@%@\n", self.results.text, str];
	// NSLog(@"log: %@", str);
    _pingReadout = str;
    
}


@end
