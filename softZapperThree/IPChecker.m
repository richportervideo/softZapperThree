//
//  IPChecker.m
//  softZapperThree
//
//  Created by Richard Porter on 15/01/2014.
//  Copyright (c) 2014 QED Productions. All rights reserved.
//

#import "IPChecker.h"
#import "SimplePingHelper.h"

@implementation IPChecker

-(NSInteger)checkIPAddress: (NSString*)theAdress{
    
     
    
    if (theAdress == NULL) {
        NSLog(@"IP VALUE IS EMPTY");
        return 0;
    } else {
        
        _theAddress = theAdress;
        NSLog(@"IPChecker testing for dotted Quads...");
        
        NSString *ipValidStr = theAdress;
        NSString *ipRegEx =
        @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
        
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", ipRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:ipValidStr];
        
        // NSLog(@"myStringMatchesRegEx = %d ",myStringMatchesRegEx);
        if (myStringMatchesRegEx){
            
            
            NSLog(@"IP Address matches RegEx Check");
            _pingReadout = nil;
            [self tapPing:_theAddress];
            
            while (_pingReadout == nil){
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            [NSThread sleepForTimeInterval:0.05f];
            NSInteger pingChecked = [self checkPingReadout];
            if (pingChecked ==0) {
                return 0;
            } else {
                return 1;
            }
    
        } else {
            return 0;
        }
        
        
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
                            NSLog(@"server said: %@", output);
                            //[self messageRecieved:output];
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

// Checks to see if simple ping was a success. Opens UIAlerrt and Flags everythingsOK if ping fails
-(NSInteger)checkPingReadout{
    
    if ([_pingReadout  isEqual: @"SUCCESS"]){
        NSLog(@"Ping Success %@", _theAddress);
        [inputStream close];
        [outputStream close];
        
        [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        return 1;
    } else if ([_pingReadout  isEqual: @"FAIL"]){
        NSLog(@"Ping Fail %@", _theAddress);
        NSAlert *ipAlert = [[NSAlert alloc]init];
        [ipAlert setMessageText:@"Can not reach IP"];
        [ipAlert addButtonWithTitle:@"Bad Times"];
        [ipAlert runModal];
        
        [inputStream close];
        [outputStream close];
        
        [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        NSLog(@"RAN checkPingReadout");
        return 0;
    } else {
        return 0;
    }
    
    
}



// Next 3 Methods part of PingHelper. Used to Ping the input IP before passing it to the initcommunications method.

- (void)tapPing: (NSString*)testIP {
    
    [SimplePingHelper ping:testIP target:self sel:@selector(pingResult:)];
}

- (void)pingResult:(NSNumber*)success {
    
    if (success.boolValue) {
        
        [self log:@"SUCCESS"];
    } else {
        
        [self log:@"FAIL"];
    }
}

- (void)log:(NSString*)str {
	//self.results.text = [NSString stringWithFormat:@"%@%@\n", self.results.text, str];
	// NSLog(@"log: %@", str);
    _pingReadout = str;
    
}


@end
