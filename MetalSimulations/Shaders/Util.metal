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

float3 sence(float angle, float sensorAngleOffset, float sensorDistance, float2 position, texture2d<float, access::sample> map, float4 speciesMask) {
    
    float4 inverseMask = (speciesMask - 1.0) * -1.0;
    
    float4 leftSample = map.sample(samp, float2(position.x + cos(angle + sensorAngleOffset) * sensorDistance, position.y + sin(angle + sensorAngleOffset) * sensorDistance));
    
    float4 leftAttraction = leftSample * speciesMask;
    float4 leftAversion = leftSample * inverseMask;
    
    float leftArea = leftAttraction.x + leftAttraction.y + leftAttraction.z + leftAttraction.w - leftAversion.x - leftAversion.y - leftAversion.z - leftAversion.w;
    
    
    float4 forwardSample = map.sample(samp, float2(position.x + cos(angle) * sensorDistance, position.y + sin(angle) * sensorDistance));
    
    float4 forwardAttraction = forwardSample * speciesMask;
    float4 forwardAversion = forwardSample * inverseMask;
    
    float forwardArea = forwardAttraction.x + forwardAttraction.y + forwardAttraction.z + forwardAttraction.w - forwardAversion.x - forwardAversion.y - forwardAversion.z - forwardAversion.w;
    
    
    float4 rightSample = map.sample(samp, float2(position.x + cos(angle - sensorAngleOffset) * sensorDistance, position.y + sin(angle - sensorAngleOffset) * sensorDistance));
    
    float4 rightAttraction = rightSample * speciesMask;
    float4 rightAversion = rightSample * inverseMask;
    
    float rightArea = rightAttraction.x + rightAttraction.y + rightAttraction.z + rightAttraction.w - rightAversion.x - rightAversion.y - rightAversion.z - rightAversion.w;
    
    return float3(leftArea, forwardArea, rightArea);
}

float3 palette(float t) {
    float3 a = float3(0., 0., 1.);
    float3 b = float3(1., 0., 0.);
    float3 c = float3(0., 1., 0.);
    float3 d = float3(0., 0., 1.);
    
    return a + b * cos(6.28318 * (c * t + d));
}
