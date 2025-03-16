precision highp float;

uniform float time;
uniform vec2 resolution;

float iTime;
vec2 iResolution;
varying vec2 fragCoord;
/////////////////////////////////////////////////////////////////////////////
// Source: https://www.shadertoy.com/view/lX2SDc

float normSin(float x) {
    return (sin(x) + 1.)/2.;
}

vec4 fadeColor(float i, float t) {
    float rFactor = 1.0;
    float gFactor = 1.4;
    float bFactor = 1.3;
    return vec4(i*normSin(rFactor*t), i*normSin(gFactor*t), i*normSin(bFactor*t), 1.);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float offSet = 60000.;
    float speed = 0.2;
    float density = 0.01;
    float zoom = 16.;

    vec2 uv = floor((2.0 * fragCoord - iResolution.xy) / zoom) / iResolution.y;
    float d = length(uv);

    float offsetTime = speed * (iTime) + offSet + (iTime / 2.);
    float p = abs(sin(d*offsetTime));
    float i = density / p;
    fragColor = fadeColor(i, offsetTime);
}

/////////////////////////////////////////////////////////////////////////////
void main()
{
	iTime = time;
	iResolution = resolution;
	mainImage(gl_FragColor, gl_FragCoord.xy);
}

