//
//  Shader.fsh
//  OpenGLTutorial
//
//  Created by Eric Lanz on 4/15/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

precision mediump float;
varying vec4 v_constColor;

void main()
{
    gl_FragColor = v_constColor;
}
