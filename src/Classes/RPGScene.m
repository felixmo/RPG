//
//  RPGScene.m
//  RPG
//
//  Created by Felix Mo on 11-03-10.
//  Copyright 2011 Felix Mo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


#import "RPGScene.h"
#import "SimpleAudioEngine.h"


@implementation RPGScene


#pragma mark - Property synthesizations

@synthesize hudLayer;
@synthesize gameLayer;
@synthesize tileMap;
@synthesize background;
@synthesize barriers;
@synthesize player;
@synthesize dpad;


#pragma mark - 

+ (id)scene {

	CCScene *scene = [CCScene node];
	
	RPGScene *layer = [RPGScene node];
	
	[scene addChild:layer];
	
	return scene;
}

// Scene initalization method
- (id)init {

	if (self == [super init]) {
        
        // Allow touch (user interaction)
        self.isTouchEnabled = YES;
        
        // Create layers
        self.hudLayer = [CCLayer node];
        self.gameLayer = [CCLayer node];
        
        // Add layers to scene
        [self addChild:self.gameLayer z:-1];
        [self addChild:self.hudLayer z:10];
        
        // Add player sprite images to the shared texture cache
        [[CCTextureCache sharedTextureCache] addImage:@"Player_left.png"];
        [[CCTextureCache sharedTextureCache] addImage:@"Player_right.png"];
        
        // Play background music
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music.mp3"];
		
        // MAP
        
        // Load map from file
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"Level1.tmx"];
        
        // Load layers from map file
        self.background = [tileMap layerNamed:@"Background"];
        self.barriers = [tileMap layerNamed:@"Barriers"];
        
        [self.gameLayer addChild:tileMap];
        
        // Get spawn point from the object defined as 'SpawnPoint' in the 'Objects' layer of the map
        
        CCTMXObjectGroup *objects = [tileMap objectGroupNamed:@"Objects"];
        NSMutableDictionary *spawnPoint = [objects objectNamed:@"SpawnPoint"];        
        int x = [[spawnPoint valueForKey:@"x"] intValue];
        int y = [[spawnPoint valueForKey:@"y"] intValue];
        
        // PLAYER SPRITE
        
        // Create sprite from a texture in the shared texture cache and set its position to the map's spawn position
        self.player = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"Player_right.png"]];
        player.position = ccp(x, y);
        [self.gameLayer addChild:player]; 
        
        // Move the camera to the player's position
        [self setViewpointCenter:player.position];
        
        // D-PAD
        
        // Create the D-pad in the lower right-hand corner
        self.dpad = [[EasyArrows alloc] initWithBase:@"base.png"
                                         buttonImage:@"button.png"
                                  pressedButtonImage:@"button_pressed.png" 
                                            position:ccp(320, 0)];
        [self.dpad setCorner:4];
        [self.hudLayer addChild:self.dpad];
        [self.dpad release];
        
        // Schedule and set the frequency at which to check the D-pad to see if a button was pressed
        [self schedule:@selector(checkDpad) interval:0.09];
	}
    
	return self;
}


#pragma mark - Map

// Moves center of camera while checking that the camera stays within the bounds of the map
- (void)setViewpointCenter:(CGPoint)position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    
    x = MIN(x, (tileMap.mapSize.width * tileMap.tileSize.width) - winSize.width / 2);
    y = MIN(y, (tileMap.mapSize.height * tileMap.tileSize.height) - winSize.height/2);
    
    CGPoint actualPosition = ccp(x, y);
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    
    // Only move the position of the 'game layer' so that the HUD remains unaffected 
    self.gameLayer.position = viewPoint;
}

// Converts coordinates from the iOS coordinate system to the tile coordinates using by the map
- (CGPoint)tileCoordForPosition:(CGPoint)position {
    
    int x = position.x / tileMap.tileSize.width;
    int y = ((tileMap.mapSize.height * tileMap.tileSize.height) - position.y) / tileMap.tileSize.height;
    
    return ccp(x, y);
}


#pragma mark - Player

- (void)checkDpad {
    
    CGPoint playerPos = player.position;
    
    // UP
	if ([[self.dpad getButton:8] isSelected]) {
        
        playerPos.y += tileMap.tileSize.height;
    }
	
    // DOWN
	if ([[self.dpad getButton:2] isSelected]) {
		
        playerPos.y -= tileMap.tileSize.height;
    }
	
    // RIGHT
	if ([[self.dpad getButton:6] isSelected]) {
        
        playerPos.x += tileMap.tileSize.width;
        
        // Change the player's sprite image to the one representing 'right'
        [self.player setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"Player_right.png"]];
	}
    
    // LEFT
	if ([[self.dpad getButton:4] isSelected]) {
        
        playerPos.x -= tileMap.tileSize.width;
        
        // Change the player's sprite image to the one representing 'left'
        [self.player setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"Player_left.png"]];
	}
    
    // Set the player sprite's postion
    [self setPlayerPosition:playerPos];
    
    // Move the camera to the player sprite's position
    [self setViewpointCenter:player.position];
}

// Sets the player's position while checking that it does not pass through 'collidable' objects
- (void)setPlayerPosition:(CGPoint)position {
    
	CGPoint tileCoord = [self tileCoordForPosition:position];
    int tileGid = [barriers tileGIDAt:tileCoord];
    
    if (tileGid) {
        
        NSDictionary *properties = [tileMap propertiesForGID:tileGid];
        
        if (properties) {
            
            NSString *collision = [properties valueForKey:@"Collidable"];
            
            if (collision && [collision compare:@"True"] == NSOrderedSame) {
                
                return;
            }
        }
    }
    
    player.position = position;
}


#pragma mark - Memory management

- (void)dealloc {

    self.tileMap = nil;
    self.background = nil;
    self.barriers = nil;
    self.player = nil;
    [self.dpad release], self.dpad = nil;    
	[super dealloc];
}

@end
