//
//  IPChecker.m
//  softZapperThree
//
//  Created by Richard Porter on 15/01/2014.
//  Copyright (c) 2014 QED Productions. All rights reserved.
//

#import "IPChecker.h"

@implementation IPChecker

-(NSInteger)checkIPAddress: (NSString*)theAdress{
    
    if (theAdress == NULL) {
        return 0;
    } else {
        
        NSLog(@"IPChecker testing for 4 Quads...");
        
        NSString *ipValidStr = theAdress;
        NSString *ipRegEx =
        @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
        
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", ipRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:ipValidStr];
        
        NSLog(@"myStringMatchesRegEx = %d ",myStringMatchesRegEx);
        if (myStringMatchesRegEx){
            return 1;
            NSLog(@"IP Address matches RegEx Check");
        } else {
            return 0;
        }
        

        
        
    }
}

@end
