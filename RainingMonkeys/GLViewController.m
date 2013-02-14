//
//  GLViewController.m
//  OpenGLTutorial
//
//  Created by Eric Lanz on 12/28/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "GLViewController.h"
#import "ShaderController.h"
#import "TextureController.h"
#import "Vertex.h"
#import "ESDrawable.h"

#define ARC4RANDOM_MAX      0x100000000

static Vertex QuadVertices[] = {
    {{1, -1, 1}, {1, 0}},
    {{1, 1, 1}, {1, 1}},
    {{-1, 1, 1}, {0, 1}},
    {{-1, -1, 1}, {0, 0}}
};

const GLushort QuadIndices[] = {
    0, 1, 2,
    2, 3, 0
};

@interface GLViewController ()

@end

@implementation GLViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context)
        NSLog(@"Failed to create ES context");
    
    [EAGLContext setCurrentContext:self.context];
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    
    view.drawableMultisample = GLKViewDrawableMultisampleNone;
    self.preferredFramesPerSecond = 30;
    
    _shaders = [[ShaderController alloc] init];
    [_shaders loadShaders];
    _textures = [[TextureController alloc] initWithShareGroup:self.context.sharegroup];
    
    glGenBuffers(1, &_quadIndexBuffer);
    glGenBuffers(1, &_quadVertexBuffer);
    
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glEnableVertexAttribArray(ATTRIB_TEX01);
    
    glLineWidth(10.0);
    
    _drawables = [NSMutableArray array];
    _monkeysToKill = [NSMutableArray array];

    _monkeyCounter = 0;
    _monkeySpawnDelay = 0;
    
    glBindBuffer(GL_ARRAY_BUFFER, _quadVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(QuadVertices), QuadVertices, GL_STATIC_DRAW);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _quadIndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(QuadIndices), QuadIndices, GL_STATIC_DRAW);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    [_drawables enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(ESDrawable*)obj drawWithView:_viewMatrix];
    }];

#ifdef DEBUG
    static int framecount = 0;
    framecount ++;
    if (framecount > 30)
    {
        float ft = self.timeSinceLastDraw;
        NSString * debugText = [NSString stringWithFormat:@"%2.1f, %0.3f", 1.0/ft, ft];
        [self.debugLabel setText:debugText];
        framecount = 0;
    }
#endif
}

- (void)spawnMonkey
{
    float r = (arc4random() % 256)/(float)256;
    float g = (arc4random() % 256)/(float)256;
    float b = (arc4random() % 256)/(float)256;
    
    float scale = ((arc4random() % 256)/(float)128) + 5.0;
    float x = (arc4random() % 10);
    x -= 5;
    
    GLKVector4 color = GLKVector4Make(r, g, b, 1.0);
    ESDrawable * drawable = [[ESDrawable alloc] initWithShader:_shaders.tileShader
                                                         color:color
                                                      position:GLKVector3Make(x, 10.0, 0.0)];
    drawable.texture = _textures.sharedMonkeyTexture;
    [drawable setScale:GLKVector3Make(scale, scale, 1.0)];
    [drawable setDest_scale:drawable.scale];
    
    [_drawables addObject:drawable];
}

- (void)update
{
    float aspect = fabsf([UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height);
    _viewMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90.0f), aspect, 1.0, 100.0);
    
    _monkeySpawnDelay ++;
    if (_monkeyCounter < 200 && _monkeySpawnDelay >= 1)
    {
        _monkeySpawnDelay = 0; _monkeyCounter ++;
        [self spawnMonkey];
    }
    
    [_monkeysToKill removeAllObjects];
    
    [_drawables enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ESDrawable * drawable = obj;        
        [drawable updateWithDeltaTime:self.timeSinceLastUpdate];
        
        if (drawable.position.y <= -10)
        {
            [_monkeysToKill addObject:drawable];
        }
    }];
    
    for (ESDrawable * drawable in _monkeysToKill)
    {
        [_drawables removeObject:drawable];
        _monkeyCounter --;
    }
}

@end
