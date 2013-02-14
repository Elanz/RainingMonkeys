//
//  ShaderController.h
//  OpenGLTutorial
//
//  Created by Eric Lanz on 4/15/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ShaderController : NSObject

@property (nonatomic, readonly) GLuint lineShader;
@property (nonatomic, readonly) GLuint tileShader;

- (void)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;

@end
