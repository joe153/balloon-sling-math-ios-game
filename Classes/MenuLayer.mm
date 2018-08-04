#import "MenuLayer.h"
#import "LevelMenu.h"
#import "Constants.h"
#import "BuyGameScene.h"
#import "CategoryMenu.h"

@implementation MenuLayer

@synthesize facebook;

NSArray *balloonImagesMenu;

Game *gameMenu;

/**
 The number of seconds since the last balloon was released.
 */
float secondsSinceLastBalloonMenu = 0;

+ (CCScene *)scene {
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];

    // 'layer' is an autorelease object.
    MenuLayer *layer = [MenuLayer node];

    // add layer as a child to scene
    [scene addChild:layer];

    // return the scene
    return scene;
}

- (id)init {
    if( (self=[super init] )) {
    //if (self = [super initWithColor:ccc4(204, 243, 255, 255)]) {
         gameMenu = [[Game alloc] init];
        
        [self setupSpriteSheet];
        
        [self setupMenuBackground];
        screenSize = [[CCDirector sharedDirector] winSize];
        //CCSpriteBatchNode *loadingBatchNode = [CCSpriteBatchNode batchNodeWithFile:screenToLoad];
        //[self addChild:loadingBatchNode z:4];



        playImageName    = @"resume";
        optionsImageName = @"options";
        shareImageName   = @"share";
        appStoreImageName= @"appstore";
        buyImageName= @"fullVersion";

        globalScale_ = 5;

        [self initBalloonImages];
        [self createMenu];

        [self createBuyButtonMenu];

        [self setupSchedule];

    }

    return self;
}


- (BOOL) takeScreenshot
{
	UIImage *tempImage = [self screenshotUIImage];
    NSString *link = @"http://itunes.apple.com/us/app/sling-math/id549720514?ls=1&mt=8";
    
	
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   tempImage,@"message",link,@"link",
								   nil];
	
	[facebook requestWithGraphPath:@"me/feed"   // or use page ID instead of 'me'
						 andParams:params
					 andHttpMethod:@"POST"
					   andDelegate:self];
     [self showBoardMessage:(NSString*)@"Photo posted in the \"Sling Math\" album on your account!"];
	
//    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    [_spinner.layer setValue:[NSNumber numberWithFloat:5.0f] forKeyPath:@"transform.scale"];
//    _spinner.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
//    
//
//
//    _spinner.hidesWhenStopped = YES;
//    [_spinner startAnimating];
    
//    [[CCDirector sharedDirector].openGLView addSubview:_spinner];
	//shareLayer.visible = YES;
	
	return YES;
}
-(UIImage*) screenshotUIImage
{
	CGSize displaySize	= [[CCDirector sharedDirector] winSize];
	CGSize winSize		= displaySize;
    
	//Create buffer for pixels
	GLuint bufferLength = displaySize.width * displaySize.height * 4;
	GLubyte* buffer = (GLubyte*)malloc(bufferLength);
    
	//Read Pixels from OpenGL
	glReadPixels(0, 0, displaySize.width, displaySize.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
	//Make data provider with data.
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);
    
	//Configure image
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	int bytesPerRow = 4 * displaySize.width;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	CGImageRef iref = CGImageCreate(displaySize.width, displaySize.height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
	uint32_t* pixels = (uint32_t*)malloc(bufferLength);
	CGContextRef context = CGBitmapContextCreate(pixels, winSize.width, winSize.height, 8, winSize.width * 4, CGImageGetColorSpace(iref), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
	CGContextTranslateCTM(context, 0, displaySize.height);
	CGContextScaleCTM(context, 1.0f, -1.0f);
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	switch (orientation)
	{
		case UIDeviceOrientationPortrait: break;
		case UIDeviceOrientationPortraitUpsideDown:
			CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(180));
			CGContextTranslateCTM(context, -displaySize.width, -displaySize.height);
			break;
		case UIDeviceOrientationLandscapeLeft:
			CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(-90));
			CGContextTranslateCTM(context, -displaySize.height, 0);
			break;
		case UIDeviceOrientationLandscapeRight:
			CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(90));
			CGContextTranslateCTM(context, displaySize.width * 0.5f, -displaySize.height);
			break;
        case UIDeviceOrientationUnknown:
            break;
        case UIDeviceOrientationFaceUp:
            break;
        case UIDeviceOrientationFaceDown:
            break;
	}
    
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, displaySize.width, displaySize.height), iref);
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	UIImage *outputImage = [UIImage imageWithCGImage:imageRef];
    
	//Dealloc
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGImageRelease(iref);
	CGColorSpaceRelease(colorSpaceRef);
	CGContextRelease(context);
	free(buffer);
	free(pixels);
    
	return outputImage;
}

#pragma mark RESET OR ADVANCE LEVEL
-(void) showBoardMessage:(NSString*)theMessage {
    
    CCLabelTTF* boardMessage = [CCLabelTTF labelWithString:theMessage fontName:@"Marker Felt" fontSize:12];
    [self addChild:boardMessage z:depthPointScore];
    [boardMessage setColor:ccc3(255,255,255)];
    boardMessage.position = ccp( screenSize.width /2, screenSize.height * .7 );
    
    
    CCSequence *seq = [CCSequence actions:
                       
                       [CCScaleTo actionWithDuration:3.0f scale:1.5f],
                       [CCFadeTo actionWithDuration:7.0f opacity:0.0f],
                       [CCCallFuncN actionWithTarget:self selector:@selector(removeBoardMessage:)], nil];  //NOTE: CCCallFuncN  works, CCCallFunc does not.
    
    [boardMessage runAction:seq];
}

-(void) removeBoardMessage:(id)sender {
    
    CCLabelTTF *boardMessage = (CCLabelTTF *)sender;
    
	[self removeChild:boardMessage cleanup:YES];
    
}

- (void) facebookLogin
{
	// The screenshot is going to be taken instantly after the login,
	// so already hide GUI/unecessary stuff
//	shareLayer.visible = NO;
	
	if (facebook == nil) {
		facebook = [[Facebook alloc] initWithAppId:@"383101755086667"];
	}
	
	NSArray* permissions =  [[NSArray arrayWithObjects:
							  @"publish_stream", @"offline_access", nil] retain];
	
	[facebook authorize:permissions delegate:self];
	
	// If you want to add Logout capability:
	//	if (isFBLogged) {
	//		[facebook logout:self];
	//	} else { // then the code above inside the else
}

#pragma mark -
#pragma mark FBSessionDelegate
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
	isFBLogged = YES;
	[self takeScreenshot];
	
	// If we wanted to allow logging out:
	// facebookLoginButton.visible = NO;
	// facebookLogoutButton.visible = YES;
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	if (cancelled) {
//		[message setString:@"Login cancelled. No Login, No Share, No Game! :)"];
	} else {
//		[message setString:@"Error. Please try again."];
	}
    
//	shareLayer.visible = YES;
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
	isFBLogged = NO;
	share.visible = YES;
	facebookLogoutButton.visible = NO;
}

#pragma mark -
#pragma mark FBRequestDelegate
/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
	//[message setString:@"Photo posted in the \"APP NAME\" album on your account!"];
	//shareLayer.visible = YES;
	
};

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	//[message setString:@"Error. Please try again."];
	//shareLayer.visible = YES;
};

#pragma mark -
#pragma mark FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog {
	NSLog(@"publish successfully");
}
/**
 Setup the balloon images
 */
- (void)initBalloonImages {
    balloonImagesMenu = [[NSArray alloc] initWithObjects:@"balloon_blue", @"balloon_brown", @"balloon_cyan", @"balloon_lime", @"balloon_olive", @"balloon_orange", @"balloon_pink", @"balloon_purple", @"balloon_red", nil];
}

/**
 Sets up the scheduler
 */
- (void)setupSchedule {
    // schedule a repeating callback on every frame
    [self schedule:@selector(updateBalloons:)];
    
}

/**
 Updates balloon positions.
 @param dt The number of seconds elasped since the last frame.
 */
- (void)updateBalloons:(ccTime)dt {
    // raise all balloons
    for (Balloon *balloon in gameMenu.balloons) {
        [balloon raise:dt * balloon.speed];
    }
    
    secondsSinceLastBalloonMenu += dt;
    if (secondsSinceLastBalloonMenu > gameMenu.balloonPace) {
        [self newBalloon];
        secondsSinceLastBalloonMenu = 0;
    }
}

/**
 * Creates a new balloon
 * @returns Balloon* A pointer to a balloon
 */
- (void)newBalloon {
    NSString *spriteFile = [balloonImagesMenu objectAtIndex:arc4random() % balloonImagesMenu.count];
    //CCSprite *balloonSprite = [CCSprite spriteWithFile:spriteFile];
    CCSprite *balloonSprite = [CCSprite  spriteWithSpriteFrameName:spriteFile];
    
    Balloon *balloon = [gameMenu newBalloonMenu:balloonSprite];
    
    balloon.sprite.scale *= globalScale_;
    
    int minX = screenSize.width - (screenSize.width * 0.7); // 70% of the screen
    int maxX = screenSize.width - balloon.sprite.boundingBox.size.height;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    [balloon setPosition:ccp(actualX, -balloon.sprite.boundingBox.size.height)];
    
    [self addChild:balloon.sprite];
    [self addChild:balloon.label];

    [balloon release];
}

- (void)startGame:(CCMenuItem *)menuItem {
    [[CCDirector sharedDirector] pushScene:[CategoryMenu scene]];
}

-(void) shareGame{
    [self facebookLogin];

}

- (void)setupSpriteSheet {
    if ([UIScreen instancesRespondToSelector:@selector(scale)])
    {
        CGFloat scale = [[UIScreen mainScreen] scale];
        NSString* valueDevice = [[UIDevice currentDevice] model];
        if (scale > 1.0)
        {
            CCLOG(@"HD Screen");
            
            if ([valueDevice rangeOfString:@"iPad"].location == NSNotFound)
            {
                NSLog(@"iPhone HD");
                
                pListToLoad1 = SPRITE_SHEET1_HD;
                pListToLoad2 = SPRITE_SHEET2_HD;
                pListToLoad3 = SPRITE_SHEET3_HD;
                
                screenToLoad1 = SPRITE_BATCH1_HD;
                screenToLoad2 = SPRITE_BATCH2_HD;
                screenToLoad3 = SPRITE_BATCH3_HD;
                
            } else {
                NSLog(@"iPad HD");
                
                pListToLoad1 = SPRITE_SHEET1_IPADHD;
                pListToLoad2 = SPRITE_SHEET2_IPADHD;
                pListToLoad3 = SPRITE_SHEET3_IPADHD;
                
                screenToLoad1 = SPRITE_BATCH1_IPADHD;
                screenToLoad2 = SPRITE_BATCH2_IPADHD;
                screenToLoad3 = SPRITE_BATCH3_IPADHD;
            }
        }else {
            CCLOG(@"SD Screen");
            
            if ([valueDevice rangeOfString:@"iPad"].location == NSNotFound)
            {
                NSLog(@"iPhone");
                
                pListToLoad1 = SPRITE_SHEET1;
                pListToLoad2 = SPRITE_SHEET2;
                pListToLoad3 = SPRITE_SHEET3;
                
                screenToLoad1 = SPRITE_BATCH1;
                screenToLoad2 = SPRITE_BATCH2;
                screenToLoad3 = SPRITE_BATCH3;
                
            } else {
                NSLog(@"iPad");
                
                pListToLoad1 = SPRITE_SHEET1_HD;
                pListToLoad2 = SPRITE_SHEET2_HD;
                pListToLoad3 = SPRITE_SHEET3_HD;
                
                screenToLoad1 = SPRITE_BATCH1_HD;
                screenToLoad2 = SPRITE_BATCH2_HD;
                screenToLoad3 = SPRITE_BATCH3_HD;
                
            }
        }
    }
    CCSpriteBatchNode *loadingBatchNode1 = [CCSpriteBatchNode batchNodeWithFile:screenToLoad1];
    [self addChild:loadingBatchNode1];
    CCSpriteBatchNode *loadingBatchNode2 = [CCSpriteBatchNode batchNodeWithFile:screenToLoad2];
    [self addChild:loadingBatchNode2];
    CCSpriteBatchNode *loadingBatchNode3 = [CCSpriteBatchNode batchNodeWithFile:screenToLoad3];
    [self addChild:loadingBatchNode3];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:pListToLoad1];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:pListToLoad2];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:pListToLoad3];
}

- (void)setupMenuBackground {

    //CCSprite *background = [CCSprite spriteWithFile:@"menustart.png"];
    CCSprite *background = [[CCSprite node] initWithFile:deviceFile(@"menustart", @"png")];

    //CCSprite *background =[CCSprite  spriteWithSpriteFrameName:@"menustart"];

   // background.position = ccp(240, 160);
   // background.position = ccp(screenSize.width , screenSize.height);
    background.anchorPoint = ccp(0, 0);
    background.position = ccp(0, 0);
    [self addChild:background z:0];
}

#pragma mark menu

-(void) createMenu {

    [self removeChild:MainMenu cleanup:YES];

    CCMenuItemSprite *playMenu = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:playImageName] selectedSprite:[CCSprite spriteWithSpriteFrameName:playImageName] target:self selector:@selector(startGame:)];


    if ([[GamePlayConfig instance] gamePurchased]) { // don't show the buy button if the game already purchased
        MainMenu = [CCMenu menuWithItems:playMenu, nil];
    } else {
        CCMenuItemSprite *buy = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:buyImageName] selectedSprite:[CCSprite spriteWithSpriteFrameName:buyImageName] target:self selector:@selector(buyScreen)];
        MainMenu = [CCMenu menuWithItems:playMenu, buy, nil];
    }

    
    

    //screenSize.width - MainMenu.boundingBox.size.width / 7 - MainMenu.boundingBox.size.width / 20
    MainMenu.position = ccp(screenSize.width - MainMenu.boundingBox.size.width / 7 - MainMenu.boundingBox.size.width / 20,
    screenSize.height - MainMenu.boundingBox.size.height / 4 - MainMenu.boundingBox.size.height / 4);

    [MainMenu alignItemsVertically];


    [self addChild:MainMenu z:10];
}

/**
 Shows the Buy notice when the round rolls over.
 */
- (void)buyScreen {
    [[CCDirector sharedDirector] pushScene:[BuyGameLayer scene]];
}
-(void) createBuyButtonMenu {
    
    [self removeChild:AppStoreMenu cleanup:YES];
    
    share = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:shareImageName] selectedSprite:[CCSprite spriteWithSpriteFrameName:shareImageName] target:self selector:@selector(shareGame)];
//    
//    facebookLogoutButton = [CCMenuItemImage itemFromNormalImage:@"LogoutNormal.png" selectedImage:@"LogoutPressed.png" disabledImage:@"LogoutPressed.png" target:self selector:@selector(facebookLogin)];
//    facebookLogoutButton.visible = NO;
    
    CCMenuItemSprite *appStore = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:appStoreImageName] selectedSprite:[CCSprite spriteWithSpriteFrameName:appStoreImageName] target:self selector:@selector(launchAppStore)];
    
    AppStoreMenu = [CCMenu menuWithItems:share,appStore, nil];
    AppStoreMenu.position= ccp(screenSize.width - AppStoreMenu.boundingBox.size.width/2,
                               screenSize.height-AppStoreMenu.boundingBox.size.height/2-AppStoreMenu.boundingBox.size.height/2.4);
    [AppStoreMenu alignItemsHorizontally];
    

    
    [self addChild:AppStoreMenu z:10  ];
}

-(void)  launchAppStore {

    NSString *iTunesLink = APP_STORE_URL;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

- (void)showRetry {
    [[CCDirector sharedDirector] replaceScene:[BalloonLayer scene]];
}

- (void)showMainMenu {
    // Run the intro Scene
    [[GameSounds sharedGameSounds] stopBackgroundMusic];
    [[CCDirector sharedDirector] pushScene:[LevelMenu scene]];
}

-(void) dealloc{
    [facebook release];
    [gameMenu release];
    [balloonImagesMenu release];
    [super dealloc];
}


@end
