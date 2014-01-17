//
//  IPChecker.h
//  softZapperThree
//
//  Created by Richard Porter on 15/01/2014.
//  Copyright (c) 2014 QED Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPChecker : NSObject<NSStreamDelegate>{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}

@property NSString *theAddress;
@property NSString *pingReadout;

-(NSInteger)checkIPAddress:(NSString*)theAddress;
-(void)initNetworkCommunication;
-(void)sendThisMessage:(NSString*)message;


@end
