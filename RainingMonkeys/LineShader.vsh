//
//  Shader.vsh
//  OpenGLTutorial
//
//  Created by Eric Lanz on 4/15/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

attribute vec4 position;
attribute vec4 a_constColor;
varying vec4 v_constColor;
uniform mat4 modelViewProjectionMatrix;

void main()
{
    gl_Position = modelViewProjectionMatrix * position;
    v_constColor = a_constColor;
}

