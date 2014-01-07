//
//  SColourComboDS.m
//  softZapperThree
//
//  Created by Richard Porter on 07/01/2014.
//  Copyright (c) 2014 QED Productions. All rights reserved.
//

#import "SColourComboDS.h"

@implementation SColourComboDS




- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
    return [_colourItems count];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index{
    return [_colourItems objectAtIndex:index];
}
@end
