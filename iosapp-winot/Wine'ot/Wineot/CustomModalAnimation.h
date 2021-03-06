//
//  CustomModalAnimation.h
//  Wineot
//
//  Created by Werck Ayrton on 18/02/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <pop/POP.h>

@interface PresentingAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@end

@interface DismissingAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@end