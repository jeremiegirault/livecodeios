//
//  Game.m
//  livecode
//
//  Created by Jérémie Girault on 22/09/13.
//  Copyright (c) 2013 Jérémie Girault. All rights reserved.
//

#import "Game.h"
#import "Board.h"
#import "HTTPServer.h"
#import "ConnectionHandler.h"
@interface Game ()

@property (nonatomic, retain) IBOutlet UILabel* lblInstructions;
@property (nonatomic, retain) IBOutlet UILabel* lblGameOver;
@property (nonatomic, retain) HTTPServer* server;

@end

@implementation Game

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc {
    self.lblInstructions = nil;
    
    [self.server stop:YES];
    self.server = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameStarted:)
                                                 name:BoardGameStarted
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameEnded:)
                                                 name:BoardItemTouched
                                               object:nil];
    
    NSString *wwwPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"www"];
    
    self.server = [[HTTPServer alloc] init];
    [self.server setPort:8501];
    [self.server setConnectionClass:[ConnectionHandler class]];
    [self.server setType:@"_http._tcp"];
    [self.server setDocumentRoot:wwwPath];
    [self.server start:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gameStarted:(NSNotification*)notif {
    [UIView animateWithDuration:0.4f animations:^{
        [self.lblGameOver setAlpha:0.0f];
        [self.lblInstructions setAlpha:0.0f];
    }];
}

-(void)gameEnded:(NSNotification*)notif {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.lblInstructions setAlpha:1.0f];
        [self.lblGameOver setAlpha:1.0f];
    });
}

@end
