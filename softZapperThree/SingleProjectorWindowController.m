//
//  SingleProjectorWindowController.m
//  softZapperThree
//
//  Created by Richard Porter on 07/01/2014.
//  Copyright (c) 2014 QED Productions. All rights reserved.
//

#import "SingleProjectorWindowController.h"
#import "SColourComboDS.h"

@class SColourComboDS;

@interface SingleProjectorWindowController ()

@end

@implementation SingleProjectorWindowController{
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    NSString * _ipAddress;
    NSArray *_sxga_sxga, *_hd_sxga, *_hd_hd, *_wuxga_sxga, *_wuxga_hd, *_wuxga_wuxga;
    NSString *R, *G, *B, *C, *Y, *M, *W, *_shadedRGB, *_chosenProjector, *_userRGB;
    int _gridBoxesWide, _gridBoxesHigh, _centerLeft, _centerRight, _middleTop, _middleBottom, _gridsize, _delayBtwLines;
    double _delayInSeconds;
    NSArray *_projGrid;
    NSArray *_colours;
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
    _ipAddress = @"192.168.20.2";
    [_ipAddressTextBox setStringValue: _ipAddress];
    
    //Colour Choices
    R = @" 255 0 0)";
    G = @" 0 255 0)";
    B = @" 0 0 255)";
    C = @" 0 255 255)";
    Y = @" 255 255 0)";
    M = @" 255 0 255)";
    W = @" 255 255 255)";
    _shadedRGB = @" 64 64 64)";

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

    
    SCCDataSource = [[SColourComboDS alloc]init];
    
    //Set up col
    _colours = [NSArray arrayWithObjects:@"Red", @"Green", @"Blue", @"Cyan", @"Magenta", @"Yellow",@"White", nil];
    
    [SCCDataSource setColourItems:_colours];
    
    [_colourComboBox setDataSource:SCCDataSource];
    [_colourComboBox setUsesDataSource:YES];
    [_colourComboBox selectItemAtIndex:0];
    
    
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
    switch (comboBoxIndex) {
        case 0:
            _projGrid = _sxga_sxga;
            _chosenProjector = @"_sxga_sxga";
            break;
        case 1:
            _projGrid = _hd_sxga;
            _chosenProjector = @"_hd_sxga";
            break;
        case 2:
            _projGrid = _hd_hd;
            _chosenProjector = @"_hd_hd";
            break;
        case 3:
            _projGrid = _wuxga_sxga;
            _chosenProjector = @"_wuxga_sxga";
            break;
        case 4:
            _projGrid = _wuxga_hd;
            _chosenProjector = @"_wuxga_hd";
            break;
        case 5:
            _projGrid = _wuxga_wuxga;
            _chosenProjector = @"_wuxga_wuxga";
            break;
        default:
            _projGrid = _sxga_sxga;
            _chosenProjector = @"_sxga_sxga";
            break;
    }
}

//Close window
- (IBAction)closeAction:(id)sender {
    [self close];
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
    NSLog(@"The vertical height is %@", panelRes);
}
@end
