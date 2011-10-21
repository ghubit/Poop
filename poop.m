//
//  AppDelegate.mm
//  AnimationMockupTest
//
//  Created by B. Lee Projects on 10/20/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "HelloWorldLayer.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window;

@synthesize testAnimationSprite;
@synthesize walkAction, moveAction;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
	
//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();	
}

- (void) testAnimationMethod
{

    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
     @"walking_animation.plist"];
    
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode 
                                      batchNodeWithFile:@"walking_animation.png"];
    [self addChild:spriteSheet];
    
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 8; ++i) {
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"%d.png", i]]];
    }
    
    CCAnimation *walkAnim = [CCAnimation 
                             animationWithFrames:walkAnimFrames delay:0.1f];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    self.testAnimationSprite = [CCSprite spriteWithSpriteFrameName:@"testAnimationSprite1.png"];        
    testAnimationSprite.position = ccp(winSize.width/2, winSize.height/2);
    self.walkAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
    [testAnimationSprite runAction:walkAction];
    [spriteSheet addChild:testAnimationSprite];
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	
	CCDirector *director = [CCDirector sharedDirector];;
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
//	if( ! [director enableRetinaDisplay:YES] )
//		CCLOG(@"Retina Display Not supported");
	
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:YES];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// Assusme PVR images have the alpha channel premultiplied
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// create scene
	CCScene *scene = [CCScene node];
	[scene addChild:[HelloWorldLayer node]];
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: scene];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

@end

