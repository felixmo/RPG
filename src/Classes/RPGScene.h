//
//  RPGScene.h
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


#import "cocos2d.h"
#import "EasyArrows.h"


@interface RPGScene : CCLayer {
    
    // Scene layers - isolates HUD from game
    CCLayer *hudLayer;
    CCLayer *gameLayer;
    
    // Map
    CCTMXTiledMap *tileMap;
    
    // Layers in the map
    CCTMXLayer *background; // (i.e. grass, stone tiles, doors, etc)
    CCTMXLayer *barriers;   // (i.e. mountains, walls, etc)
    
    // Player sprite
    CCSprite *player;
    
    // D-Pad
    EasyArrows *dpad;
}

@property (nonatomic, retain) CCLayer *hudLayer;
@property (nonatomic, retain) CCLayer *gameLayer;
@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, retain) CCTMXLayer *barriers;
@property (nonatomic, retain) CCSprite *player;
@property (nonatomic, retain) EasyArrows *dpad;

+ (id)scene;
- (void)checkDpad;
- (void)setViewpointCenter:(CGPoint)position;
- (CGPoint)tileCoordForPosition:(CGPoint)position;
- (void)setPlayerPosition:(CGPoint)position;

@end
