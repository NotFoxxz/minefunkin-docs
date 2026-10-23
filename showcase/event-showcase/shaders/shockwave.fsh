// A ring that runs out from the middle, bending the picture as it passes, with a cyan rim.
// params.x = strength, .y = speed (screen heights per second), .z = the moment it started (song
// seconds - a shader keeps no memory, so the script hands it the start).
vec4 effect(vec2 uv) {
    float age = time - params.z;

    if (age < 0.0 || age > 1.4) {
        return pixel(uv);
    }

    vec2 aspect = vec2(resolution.x / resolution.y, 1.0);
    vec2 d = (uv - 0.5) * aspect;
    float r = length(d);
    float ring = r - age * params.y;
    float fade = 1.0 - age / 1.4;
    float bend = exp(-(ring * ring) / 0.004) * params.x * fade;
    vec2 dir = d / max(r, 0.0001);

    // The three colours bent a little differently: a rainbow rim on the ring.
    vec2 off = dir / aspect * bend * 0.04;
    vec3 c = vec3(pixel(uv - off * 1.25).r, pixel(uv - off).g, pixel(uv - off * 0.75).b);
    c += bend * 0.22 * vec3(0.36, 0.95, 1.0);
    return vec4(c, 1.0);
}
