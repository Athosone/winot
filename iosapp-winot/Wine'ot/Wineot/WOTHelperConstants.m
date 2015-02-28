//
//  WOTHelperConstants.m
//  Wineot
//
//  Created by Werck Ayrton on 17/12/2014.
//  Copyright (c) 2014 wineot. All rights reserved.
//

#import <objc/runtime.h>
#import "WOTHelperConstants.h"

@implementation WOTHelperConstants

/**
 *  Init button design
 *
 *  @param button button to be designed
 */
+ (void) initButtonBaseDesign:(UIButton*)button
{
    button.layer.borderColor = [WOTHelperConstants getWhiteColorApp].CGColor;
    button.layer.borderWidth = DEFAULT_BORDER_WIDTH;
    button.layer.cornerRadius = DEFAULT_BUTTON_CORNER;
    button.backgroundColor = [UIColor clearColor];
}

/**
 *  Get the Red defined color
 *
 *  @return return the UIColor
 */
+ (UIColor*) getRedColorApp
{
    return [UIColor colorWithRed:RRED_APP green:RGREEN_APP blue:RBLUE_APP alpha:1];
}


/**
 *  Get the White defined color
 *
 *  @return return UIColor
 */
+ (UIColor*) getWhiteColorApp
{
    return [UIColor whiteColor];//[UIColor colorWithRed:WRED_APP green:WGREEN_APP blue:WBLUE_APP alpha:1];
}

/**
 *  The function is made to create a new image which will kept good shape after resizing
 *
 *  @param image   the original image
 *  @param newSize the desired size for the image
 *
 *  @return return an UIImage* which match the newSize
 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0,newSize.width/3, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  Convert an object to NSMutableDictionary*
 *
 *  @param object object to be converted;For the moment it only support Object with "simple" type
 *
 *  @return return an NSMutableDictionary*
 */
+ (NSMutableDictionary*) toDictionary:(id)object
{
    Class clazz =  [object class];
    u_int count;
    objc_property_t* propList = class_copyPropertyList(clazz, &count);
    NSMutableDictionary    *dico = [[NSMutableDictionary alloc]init];
    
    for (u_int i = 0; i < count; ++i)
    {
        objc_property_t property = propList[i];
        const char *propName = property_getName(property);
        
        NSString *propNameString = [NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
        NSLog(@"PropName: %@", propNameString);
        if ([object valueForKey:propNameString])
            [dico setObject:[object valueForKey:propNameString] forKey:propNameString];
    }
    return dico;
}


@end
