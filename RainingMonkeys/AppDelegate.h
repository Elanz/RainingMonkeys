//
//  AppDelegate.h
//  OpenGLTutorial
//
//  Created by Eric Lanz on 12/28/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    GLViewController * _glView;
}

@property (strong, nonatomic) UIWindow *window;

@end
