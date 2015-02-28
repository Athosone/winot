//
//  main.m
//  Wine'ot
//
//  Created by Werck Ayrton on 02/11/2014.
//  Copyright (c) 2014 wineot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

// From here to end of file added by Injection Plugin //

#ifdef DEBUG
static char _inMainFilePath[] = __FILE__;
static const char *_inIPAddresses[] = {"127.0.0.1", "192.168.1.7", "192.168.2.1", NULL};

#define INJECTION_ENABLED
#import "/Users/Athos/Library/Application Support/Developer/Shared/Xcode/Plug-ins/InjectionPlugin.xcplugin/Contents/Resources/BundleInjection.h"
#endif
