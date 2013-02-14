//
//  GLViewController.h
//  OpenGLTutorial
//
//  Created by Eric Lanz on 12/28/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@class ShaderController, TextureController;

@interface GLViewController : GLKViewController
{
    ShaderController * _shaders;
    TextureController * _textures;
    GLuint _quadVertexBuffer;
    GLuint _quadIndexBuffer;
    GLKMatrix4 _viewMatrix;
    NSMutableArray * _drawables;
    
    int _monkeyCounter;
    int _monkeySpawnDelay;
    NSMutableArray * _monkeysToKill;
}

@property (strong, nonatomic) EAGLContext * context;
@property (weak, nonatomic) IBOutlet UILabel *debugLabel;

@end
