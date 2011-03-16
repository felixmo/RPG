// =====================================================================
// EasyArrows Test Version
// Quickly create a 4-arrows menu, saving some decent coding time.
// =====================================================================
// Required graphics: 
//     > A base, which will be like the table for placing the arrows.
//     > One arrow facing up.
//     > One arrow facing up, pressed.
// =====================================================================
// Usage:
//   Call
//      initWithBase for beginning the system. This function will require
//                   you to pass a graphic name for the base, another for
//					 the arrow, and another for the arrow being pressed.
//					 Then the position of the system (CGPoint).
//
//      getButton	 will let you ask for one of the four arrow buttons.
//                   You pass on a integer, which can be:
//                   8 -> up   2 -> down   6 -> right   4 -> left
//                   You will receive the CCMenuItemImage representing
//					 said button. You can work with this.
// =====================================================================
// Extra Features:
//   Call
//		setCorner    will automatically place the whole system in one
//                   of the iPhone's screen corners, pretty useful.
//					 You need to pass a integer representign which corner:
//                   1 -> Top Left		 2 -> Top Right
//                   3 -> Bottom Left    4 -> Bottom Right
//                   <TEST VERSION: ONLY WORKS FOR LANDSCAPE MODE!!!>
// =====================================================================
// Upcoming Features:
//		Shall this code be completed, the next features will come:
//				> Diagonal Buttons available.
//              > Center Button available.
//              > Support iPhone portrait mode (setCorner function)
// =====================================================================

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EasyArrows : CCNode 
{
	CCMenuItemImage *up;
	CCMenuItemImage *down;
	CCMenuItemImage *right;
	CCMenuItemImage *left;
	CCSprite *bg;
}
-(id)initWithBase:(NSString*)base buttonImage:(NSString*)v1 pressedButtonImage:(NSString*)v2 position:(CGPoint)v3;
-(id)getButton:(int)button;
-(void)setCorner:(int)corner;
@end
