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

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox{
    return [_colours count];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index{
    return [_colours objectAtIndex:index];
}

- (IBAction)closeAction:(id)sender {
    [self close];
}


@end
