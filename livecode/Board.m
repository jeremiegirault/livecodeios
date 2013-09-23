//
//  Board.m
//  livecode
//
//  Created by Jérémie Girault on 22/09/13.
//  Copyright (c) 2013 Jérémie Girault. All rights reserved.
//


#define SIZE 32

#import "Board.h"

NSString* const BoardGameStarted = @"BoardGameStarted";
NSString* const BoardItemMoved = @"BoardItemMoved";
NSString* const BoardItemTouched = @"BoardItemTouched";

@interface Board ()

@property (nonatomic, retain) UIView* touchDisplay;

@end

@implementation Board

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.touchDisplay = nil;
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    [self updateTouch:touch];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.touchDisplay) { // only move if we touched down
        UITouch* touch = [touches anyObject];
        [self updateTouch:touch];
    }
}

-(void)updateTouch:(UITouch*)touch {
    CGPoint pt = [touch locationInView:self];
    if(!self.touchDisplay) {
        [self startTouch:pt];
    }
    
    [self.touchDisplay setCenter:pt];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BoardItemMoved
                                                        object:self
                                                      userInfo:@{
                                                                 @"position" : [NSValue valueWithCGPoint:pt]
                                                                 }];
}

-(void)startTouch:(CGPoint)pt {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touched:) name:BoardItemTouched object:nil];
    
    self.touchDisplay = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SIZE, SIZE)] autorelease];
    [self.touchDisplay setBackgroundColor:[UIColor redColor]];
    [[self.touchDisplay layer] setCornerRadius:SIZE*0.5];
    
    [self addSubview:self.touchDisplay];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BoardGameStarted object:self userInfo:nil];
}

-(void)touched:(NSNotification*)notif {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BoardItemTouched object:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4
                         animations:^{
                             [self.touchDisplay setAlpha:0];
                         }
                         completion:^(BOOL finished) {
                             [self.touchDisplay removeFromSuperview];
                             self.touchDisplay = nil;
                         }];
    });
}

@end
