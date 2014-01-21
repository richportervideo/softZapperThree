//
//  ProjectorTypeCheck.m
//  softZapperThree
//
//  Created by Richard Porter on 16/01/2014.
//  Copyright (c) 2014 QED Productions. All rights reserved.
//

#import "ProjectorTypeCheck.h"

@implementation ProjectorTypeCheck

-(NSString*)doTheCheck:(NSString*)incomingAddress{
    
    _thePanelRes = nil;
    
    _theAddress = incomingAddress;
    
    [self initNetworkCommunication];
    
    [self sendThisMessage:@"(SST+CONF?5 0)"];
    
    while (_thePanelRes == nil){
        [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    if (_thePanelRes != nil) {
        return _thePanelRes;
    } else {
        return @"CheckFailed";
    }
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
    CFStreamCreatePairWithSocketToHost(NULL, CFBridgingRetain(_theAddress), 3002, &readStream, &writeStream);
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
                            //NSLog(@"server said: %@", output);
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
    
    NSLog(@"Looks like its an M Series.");
    NSString *firstCharacter = [NSString stringWithFormat:@"%c",[message characterAtIndex:32]];
    NSString *secondCharacter = [NSString stringWithFormat:@"%c",[message characterAtIndex:33]];
    NSString *thirdCharacter = [NSString stringWithFormat:@"%c",[message characterAtIndex:34]];
    NSString *fourthCharacter = [NSString stringWithFormat:@"%c",[message characterAtIndex:35]];
    
    NSMutableString *panelRes = [NSMutableString stringWithCapacity:4];
    [panelRes appendString: firstCharacter];
    [panelRes appendString: secondCharacter];
    [panelRes appendString: thirdCharacter];
    [panelRes appendString: fourthCharacter];
    
    NSLog(@"Vertical Panel Resolutions %@", panelRes);
    [self verticalHeight:panelRes];
    
}
-(void)verticalHeight:(NSString *)panelRes{

    if ([panelRes isEqualToString:@"1200"]) {
        _thePanelRes = panelRes;
    } else if ([panelRes isEqualToString:@"1080"]){
        _thePanelRes = panelRes;
    } else if ([_thePanelRes isEqualToString:@"1050"]){
        _thePanelRes = panelRes;
    } else {
        NSAlert *pResProblem = [[NSAlert alloc]init];
        [pResProblem setMessageText:@"Can not reach IP"];
        [pResProblem addButtonWithTitle:@"Bad Times"];
        [pResProblem runModal];
    }

}


@end
