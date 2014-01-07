//
//  SGridComboDS.m
//  softZapperThree
//
//  Created by Richard Porter on 07/01/2014.
//  Copyright (c) 2014 QED Productions. All rights reserved.
//

#import "SGridComboDS.h"

@implementation SGridComboDS


- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
    return [_gridItems count];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index{
    return [_gridItems objectAtIndex:index];
}

@end
