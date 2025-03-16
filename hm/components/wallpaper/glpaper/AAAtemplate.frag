// Use this template to make shadertoy.com shaders work
// Put shadertoy shader between the big separators

precision highp float;

uniform float time;
uniform vec2 resolution;

float iTime;
vec2 iResolution;
varying vec2 fragCoord;
/////////////////////////////////////////////////////////////////////////////
// Source: 
// INSERT SOURCE URL AND SHADER CODE HERE



/////////////////////////////////////////////////////////////////////////////
void main()
{
	iTime = time;
	iResolution = resolution;
	mainImage(gl_FragColor, gl_FragCoord.xy);
}

