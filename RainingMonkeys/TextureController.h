//
//  TextureController.h
//  OpenGLTutorial4
//
//  Created by Eric Lanz on 2/12/13.
//  Copyright (c) 2013 200Monkeys. All rights reserved.
//

#import <GLKit/GLKit.h>

typedef void(^textureLoadSuccessBlock)();
typedef void(^textureLoadFailureBlock)();

@interface ESTextureInfo : NSObject

@property (nonatomic, readwrite) GLuint textureName;
@property (nonatomic, readwrite) int width;
@property (nonatomic, readwrite) int height;

@end

@interface TextureController : NSObject
{
    EAGLContext * _loaderContext;
}

@property (nonatomic, retain) ESTextureInfo * sharedMonkeyTexture;

- (id) initWithShareGroup:(EAGLSharegroup*)sharegroup;

@end
