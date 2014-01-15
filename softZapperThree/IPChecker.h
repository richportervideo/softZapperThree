//
//  IPChecker.h
//  softZapperThree
//
//  Created by Richard Porter on 15/01/2014.
//  Copyright (c) 2014 QED Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPChecker : NSObject

@property NSString *theAddress;

-(NSInteger)checkIPAddress:(NSString*)theAddress;

@end
