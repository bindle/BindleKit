//
//  main.m
//  Reachability
//
//  Created by David M. Syzdek on 10/6/11.
//  Copyright 2011 Bindle Binaries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKAppDelegate.h"

int main(int argc, char *argv[])
{
   NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
   int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([BKAppDelegate class]));
   [pool release];
   return retVal;
}
