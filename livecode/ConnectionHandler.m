//
//  ConnectionHandler.m
//  livecode
//
//  Created by Jérémie Girault on 22/09/13.
//  Copyright (c) 2013 Jérémie Girault. All rights reserved.
//

#import "ConnectionHandler.h"
#import "GameWS.h"
#import "HTTPDynamicFileResponse.h"
#import "GCDAsyncSocket.h"
#import "HTTPMessage.h"

@implementation ConnectionHandler

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path {
    if ([method isEqualToString:@"GET"] && [path isEqualToString:@"/"]) {
        return YES;
    }
    
    return [super supportsMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    NSString *wsLocation;
    NSString *wsHost = [request headerField:@"Host"];
    if(wsHost == nil) {
        NSString *port = [NSString stringWithFormat:@"%hu", [asyncSocket localPort]];
        wsLocation = [NSString stringWithFormat:@"ws://localhost:%@", port];
    }
    else {
        wsLocation = [NSString stringWithFormat:@"ws://%@", wsHost];
    }
    
    NSDictionary *replacementDict = @{ @"WEBSOCKET_URL" : wsLocation };
    
    return [[[HTTPDynamicFileResponse alloc] initWithFilePath:[self filePathForURI:path]
                                                forConnection:self
                                                    separator:@"%%"
                                        replacementDictionary:replacementDict] autorelease];
    
    return [super httpResponseForMethod:method URI:path];
}

- (WebSocket *)webSocketForURI:(NSString *)path {
    if([path isEqualToString:@"/game"]) {
		return [[[GameWS alloc] initWithRequest:request socket:asyncSocket] autorelease];
	}
    
	return [super webSocketForURI:path];
}

@end
