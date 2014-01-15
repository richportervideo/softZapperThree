//
//  Projector.m
//  softZapperThree
//
//  Created by Richard Porter on 14/01/2014.
//  Copyright (c) 2014 QED Productions. All rights reserved.
//

#import "Projector.h"

@implementation Projector

-(id)init{
    self = [super init];
    if (self){
        _ipAddress = @"192.168.18.10";
        _pType = @"WUXGA";
        _gType = [[NSComboBoxCell alloc]init];
        _zap = [[NSButtonCell alloc]init];
    }
    return self;
}

@end
