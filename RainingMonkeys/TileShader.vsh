//
//  Shader.vsh
//  test
//
//  Created by Eric Lanz on 4/15/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

attribute vec4 position;
uniform mat4 modelViewProjectionMatrix;
attribute vec2 a_texCoord;
attribute vec4 a_constColor;
varying vec2 v_texCoord;
varying vec4 v_constColor;

void main()
{
    gl_Position = modelViewProjectionMatrix * position;
    v_texCoord = a_texCoord;
    v_constColor = a_constColor;
}

