//
//  GameWS.m
//  livecode
//
//  Created by Jérémie Girault on 22/09/13.
//  Copyright (c) 2013 Jérémie Girault. All rights reserved.
//

#import "GameWS.h"
#import "Board.h"
#import "SBJson.h"

@implementation GameWS

-(void)dealloc {
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)didOpen {
    [super didOpen];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemMoved:) name:BoardItemMoved object:nil];
    NSLog(@"didOpen");
}

- (void)didReceiveMessage:(NSString *)msg {
    [super didReceiveMessage:msg];
    
    NSLog(@"received %@", msg);
    
    NSDictionary* value = [msg JSONValue];
    if(![value isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString* action = [value objectForKey:@"action"];
    if([action isKindOfClass:[NSString class]] && [action isEqualToString:@"touched"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BoardItemTouched object:self];
    }
}

- (void)didClose {
    [super didClose];
    NSLog(@"didClose");
}

-(void)itemMoved:(NSNotification*)notif {
    CGPoint pos = [[notif.userInfo objectForKey:@"position"] CGPointValue];
    NSDictionary* data = @{
                           @"action" : @"move",
                           @"x" : [NSNumber numberWithFloat:pos.x],
                           @"y" : [NSNumber numberWithFloat:pos.y]
                           };
    
    [self sendMessage:[data JSONRepresentation]];
}

@end
