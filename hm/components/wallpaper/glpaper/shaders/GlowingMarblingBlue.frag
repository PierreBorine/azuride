precision highp float;

uniform float time;
uniform vec2 resolution;

float iTime;
vec2 iResolution;
varying vec2 fragCoord;
/////////////////////////////////////////////////////////////////////////////
// Source: https://www.shadertoy.com/view/DdXBDn
// Original: https://www.shadertoy.com/user/nasana

float speed = .2;

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (2.0 * fragCoord - iResolution.xy) / min(iResolution.x, iResolution.y);

    for(float i = 1.0; i < 10.0; i++) {
        uv.x += 0.6 / i * cos(i * 2.5 * uv.y + (iTime * speed));
        uv.y += 0.6 / i * cos(i * 1.5 * uv.x + (iTime * speed));
    }

    // Tinte rojo con azul fuerte
    vec3 redTint = vec3(0.105, 0.545, 1.0);
    vec3 blueColor = vec3(0.0, 0.184, 0.713);
    vec3 finalColor = mix(redTint, blueColor, abs(sin((iTime * speed) - uv.y - uv.x)));

    fragColor = vec4(finalColor, 1.0);
}

/////////////////////////////////////////////////////////////////////////////
void main()
{
	iTime = time;
	iResolution = resolution;
	mainImage(gl_FragColor, gl_FragCoord.xy);
}

