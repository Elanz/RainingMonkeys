//
//  ShaderController.m
//  OpenGLTutorial
//
//  Created by Eric Lanz on 4/15/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "ShaderController.h"
#import "Vertex.h"

@implementation ShaderController

@synthesize tileShader = _tileShader;
@synthesize lineShader = _lineShader;

- (void)loadShaders
{
    [self loadTileShader];
    [self LoadLineShader];
}

- (BOOL)loadTileShader
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _tileShader = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"TileShader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"TileShader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_tileShader, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_tileShader, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_tileShader, ATTRIB_VERTEX, "position");
    glBindAttribLocation(_tileShader, ATTRIB_TEX01, "a_texCoord");
    glBindAttribLocation(_tileShader, ATTRIB_COLOR, "a_constColor");
    
    // Link program.
    if (![self linkProgram:_tileShader]) {
        NSLog(@"Failed to link program: %d", _tileShader);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_tileShader) {
            glDeleteProgram(_tileShader);
            _tileShader = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX1] = glGetUniformLocation(_tileShader, "modelViewProjectionMatrix");
    uniforms[UNIFORM_TEX01] = glGetUniformLocation(_tileShader, "s_texture01");
    //uniforms[UNIFORM_TEX02] = glGetUniformLocation(_tileShader, "s_texture02");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_tileShader, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_tileShader, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)LoadLineShader
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _lineShader = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"LineShader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"LineShader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_lineShader, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_lineShader, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_lineShader, ATTRIB_VERTEX, "position");
    glBindAttribLocation(_lineShader, ATTRIB_COLOR, "a_constColor");
    
    // Link program.
    if (![self linkProgram:_lineShader]) {
        NSLog(@"Failed to link program: %d", _lineShader);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_lineShader) {
            glDeleteProgram(_lineShader);
            _lineShader = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX2] = glGetUniformLocation(_lineShader, "modelViewProjectionMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_lineShader, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_lineShader, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}


@end
