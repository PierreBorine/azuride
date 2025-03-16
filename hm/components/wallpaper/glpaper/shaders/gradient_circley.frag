precision highp float;

uniform float time;
uniform vec2 resolution;

float iTime;
vec2 iResolution;
vec2 fragCoord;
/////////////////////////////////////////////////////////////////////////////
// Source: https://www.shadertoy.com/view/DsVcRt

const float OPACITY = 0.2;
const vec3 HALO_COL = vec3(0.2, 0.6, 1.0);
const vec3 EDGE1_COL = vec3(1.0, 0.68, 0.66);
const vec3 EDGE2_COL = vec3(1.0, 0.3, 0.2);
const vec3 BACKGROUND_COL = vec3(0, 0, 0.11);

float mod289(float x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec4 mod289(vec4 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec4 perm(vec4 x) { return mod289(((x * 34.0) + 1.0) * x); }

float noise(vec3 p)
{
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}

float rand1d(float n) { return fract(sin(n) * 43758.5453123); }

float noise1d(float p)
{
	float fl = floor(p);
	float fc = fract(p);
	return mix(rand1d(fl), rand1d(fl + 1.0), fc);
}

vec2 rot(vec2 v, float a)
{
	float s = sin(a);
	float c = cos(a);
	mat2 m = mat2(c, s, -s, c);
	return m * v;
}

vec3 circle(vec2 uv, float off)
{
    vec3 col = HALO_COL;
    float t = iTime * 0.5 + off;
    float rt = t * 0.4;
    float f = 0.002;
    uv = rot(uv, 6.2831853 * (noise1d(rt - 6816.6) * 0.5 + noise1d(rt * 1.25 - 3743.16) * 0.4 + noise1d(rt * 1.5 + 1741.516) * 0.3));
    float n = noise(vec3(uv * 1.2, t)) * 0.2 + noise(vec3(-uv * 1.7, t)) * 0.15 + noise(vec3(uv * 2.2, t)) * 0.1;
    float d = dot(uv, uv);
    float hd = d + n;
    col = pow(vec3(hd), vec3(3.5, 3.5, 2.0)) * HALO_COL * smoothstep(1.0, 1.0 - f, hd);
    float cd = d * hd * hd * smoothstep(1.0, 1.0 - f, hd) * 1.25;
    col += cd * cd * mix(EDGE1_COL, EDGE2_COL, pow(hd, 8.0)) - (cd * cd * cd) * col;
    col = mix(BACKGROUND_COL, col, smoothstep(1.0, 1.0 - f, hd));
    return col;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float min_res = min(iResolution.x, iResolution.y);
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / min_res * 1.1;

    vec3 col = mix(mix(mix(mix(
    circle(uv, 0.0),
    circle(uv, 1000.0), OPACITY),
    circle(uv, 2000.0), OPACITY),
    circle(uv, 3000.0), OPACITY),
    circle(uv, 4000.0), OPACITY);
    fragColor = vec4(col, 1.0);
}

/////////////////////////////////////////////////////////////////////////////
void main()
{
	iTime = time;
	iResolution = resolution;
	mainImage(gl_FragColor, gl_FragCoord.xy);
}

