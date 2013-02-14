//
//  Shader.fsh
//  test
//
//  Created by Eric Lanz on 4/15/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

precision mediump float;
varying vec2 v_texCoord;
varying vec4 v_constColor;
uniform sampler2D s_texture01;

void main()
{
    vec4 color1 = texture2D(s_texture01, v_texCoord);
    
    vec4 tintedColor = vec4(v_constColor.r*color1.r, v_constColor.g*color1.g, v_constColor.b*color1.b, color1.a*v_constColor.a);
    
    gl_FragColor = tintedColor;
}
