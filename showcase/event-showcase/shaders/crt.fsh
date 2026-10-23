// Overdrive's old TV: a curved screen with rounded corners and scanlines, which can open out of a
// line and close into a dot like a CRT switching on and off.
// params.x = curvature (0-1), .y = how far it's open sideways (0-1), .z = how far it's open up and
// down (0-1), .w = scanlines (0-1).
vec4 effect(vec2 uv) {
    vec2 c = uv * 2.0 - 1.0;
    c *= 1.0 + 0.1 * params.x * dot(c, c);

    // The picture squeezed into the open part: a thin line is the whole picture pressed flat.
    vec2 open = max(vec2(params.y, params.z), vec2(0.004));
    vec2 q = c / open;

    // A rounded rectangle: the corners round off with the curvature.
    float n = mix(40.0, 7.0, clamp(params.x, 0.0, 1.0));
    float e = pow(pow(abs(q.x), n) + pow(abs(q.y), n), 1.0 / n);

    if (e > 1.0) {
        return vec4(0.0, 0.0, 0.0, 1.0);
    }

    vec2 st = q * 0.5 + 0.5;
    vec3 col = pixel(st).rgb;

    // All the light pressed into the line: the tighter, the brighter.
    float squeeze = (1.0 - open.x) + (1.0 - open.y);
    col *= 1.0 + 3.0 * squeeze;

    col *= 1.0 - params.w * 0.2 * (0.5 + 0.5 * sin(st.y * resolution.y * 3.14159));
    // A brighter band rolling slowly down the tube.
    col *= 1.0 + 0.05 * params.w * sin((st.y + time * 0.3) * 6.2831);
    // Darker toward the curved edges.
    col *= mix(1.0, smoothstep(1.0, 0.8, e), params.x);

    return vec4(col, 1.0);
}
