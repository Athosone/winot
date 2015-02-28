//
//  WOTHelperConstants.h
//  Wineot
//
//  Created by Werck Ayrton on 17/12/2014.
//  Copyright (c) 2014 wineot. All rights reserved.
//

#import                         <Foundation/Foundation.h>
#import                         <UIKit/UIKit.h>

#define RRED_APP                169.0/255.0
#define RGREEN_APP              22.0/255.0
#define RBLUE_APP               31.0/255.0

#define WRED_APP                255.0/255.0
#define WGREEN_APP              254.0/255.0
#define WBLUE_APP               222.0/255.0
#define DEFAULT_BUTTON_CORNER   8.0f;
#define DEFAULT_BORDER_WIDTH    8.0f;


@interface WOTHelperConstants : NSObject

+ (UIColor*)                    getRedColorApp;
+ (UIColor*)                    getWhiteColorApp;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (NSMutableDictionary*) toDictionary:(id)object;
+ (void) initButtonBaseDesign:(UIButton*)button;

@end
