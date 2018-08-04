// ***** START TESTING *****
// for testing unlock all levels
#define ALL_LEVELS_UNLOCKED false
// for testing return only 1 question per level
#define SHOW_ONLY_ONE_QUESTION false
// enable app purchase
#define APP_PURCHASE_ENABLED true
// ***** END TESTING *****
#define IAP_LEVEL 3 // after this level the user has to purchase the game

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

#define GAME_AUTOROTATION kGameAutorotationUIViewController
#endif

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

//depth levels
#define depthStrapBack -202
#define depthPlatform -201
#define depthSlingShotFront -179
#define depthBackground -300
#define depthScore 6

#define depthVisualFx 50
#define depthPointScore 100

// number of clouds in the sky
#define CLOUD_COUNT 3
// guarantee of how often the correct answer should be returned.  Higher this number more rare the correct questionString appears
#define CORRECT_ANSWER_RETURN_RATE_MAX 2
// balloon time frequency e.g. 5.0f appears too often
#define BALLOON_TIME_FREQUENCY 3.0f
// app store url for this game
#define APP_STORE_URL @"http://itunes.apple.com/us/app/sling-math/id549720514?ls=1&mt=8"
// in store purchase id
#define IN_STORE_PURCHASE_ID @"com.jrubenstech.slingmath"

// dialog box font
#define DIALOG_FONT @"futura-48.fnt"

#define breakEffectSmokePuffs 1
#define breakEffectExplosion 2

//pList
#define SPRITE_SHEET1_HD @"sprite_sheet1-hd.plist"
#define SPRITE_SHEET1 @"sprite_sheet1.plist"
#define SPRITE_SHEET1_IPADHD @"sprite_sheet1-ipadhd-hd.plist"

#define SPRITE_BATCH1 @"sprite_sheet1.png";
#define SPRITE_BATCH1_HD @"sprite_sheet1-hd.png";
#define SPRITE_BATCH1_IPADHD @"sprite_sheet1-ipadhd-hd.png";

#define SPRITE_SHEET2_HD @"sprite_sheet2-hd.plist"
#define SPRITE_SHEET2 @"sprite_sheet2.plist"
#define SPRITE_SHEET2_IPADHD @"sprite_sheet2-ipadhd-hd.plist"

#define SPRITE_BATCH2 @"sprite_sheet2.png";
#define SPRITE_BATCH2_HD @"sprite_sheet2-hd.png";
#define SPRITE_BATCH2_IPADHD @"sprite_sheet2-ipadhd-hd.png";

#define SPRITE_SHEET3_HD @"sprite_sheet3-hd.plist"
#define SPRITE_SHEET3 @"sprite_sheet3.plist"
#define SPRITE_SHEET3_IPADHD @"sprite_sheet3-ipadhd-hd.plist"

#define SPRITE_BATCH3 @"sprite_sheet3.png";
#define SPRITE_BATCH3_HD @"sprite_sheet3-hd.png";
#define SPRITE_BATCH3_IPADHD @"sprite_sheet3-ipadhd-hd.png";

// correct image based on the device
#define deviceFile(file, ext) \
  ([[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound ? \
    [NSString stringWithFormat:@"%@-ipad.%@", file, ext] : \
    [NSString stringWithFormat:@"%@.%@", file, ext])
