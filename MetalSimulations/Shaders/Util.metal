//
//  Math.metal
//  MetalSimulations
//
//  Created by Gabriel Thomson on 12/8/24.
//

#include <metal_stdlib>
using namespace metal;
#include "Util.h"

constexpr sampler samp = sampler(coord::pixel, filter::linear, address::clamp_to_zero);

uint hash(uint i) {
    i ^= 2747636419u;
    i *= 2654435669u;
    i ^= i >> 16;
    i *= 2654435769u;
    i ^= i >> 16;
    i *= 2654435769u;
    return i;
}

float normalizedHash(uint i) {
    return hash(i) / 4294967295.0;
}

float3 sence(float angle, float sensorAngleOffset, float sensorDistance, float2 position, texture2d<float, access::sample> map) {
    
    float leftArea = 0;
    leftArea += map.sample(samp, float2(position.x + cos(angle + sensorAngleOffset) * sensorDistance, position.y + sin(angle + sensorAngleOffset) * sensorDistance)).r;
    
    float forwardArea = 0;
    forwardArea += map.sample(samp, float2(position.x + cos(angle) * sensorDistance, position.y + sin(angle) * sensorDistance)).r;
    
    float rightArea = 0;
    rightArea += map.sample(samp, float2(position.x + cos(angle - sensorAngleOffset) * sensorDistance, position.y + sin(angle - sensorAngleOffset) * sensorDistance)).r;
    
    return float3(leftArea, forwardArea, rightArea);
}

float3 palette(float t) {
    float3 a = float3(0., 0., 1.);
    float3 b = float3(1., 0., 0.);
    float3 c = float3(0., 1., 0.);
    float3 d = float3(0., 0., 1.);
    
    return a + b * cos(6.28318 * (c * t + d));
}
