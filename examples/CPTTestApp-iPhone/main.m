//
//  main.m
//  CPTTestApp-iPhone
//
//  Created by Brad Larson on 5/11/2009.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, nil);

        return retVal;
    }
}

// From here to end of file added by Injection Plugin //

#ifdef DEBUG
static char _inMainFilePath[] = __FILE__;
static const char *_inIPAddresses[] = {"127.0.0.1", "192.168.137.199", "192.168.1.105", NULL};

#define INJECTION_ENABLED
#import "/Applications/Injection Plugin.app/Contents/Resources/BundleInjection.h"
#endif
