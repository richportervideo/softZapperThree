//
//  ProjectorTypeCheck.h
//  softZapperThree
//
//  Created by Richard Porter on 16/01/2014.
//  Copyright (c) 2014 QED Productions. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProjectorTypeCheck : NSObject <NSStreamDelegate>{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
}

@property NSString *theAddress;
@property NSString *thePanelRes;

-(NSString*)doTheCheck:(NSString*)incomingAdress;


@end
