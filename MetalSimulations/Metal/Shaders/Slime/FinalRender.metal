//
//  PassThrough.metal
//  MetalSimulations
//
//  Created by Gabriel Thomson on 11/27/24.
//

#include <metal_stdlib>
using namespace metal;
#include "../Util.h"

constexpr sampler samp = sampler(coord::normalized, filter::linear);

struct VertIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
    float2 texcoords [[attribute(2)]];
};

struct VertOut {
    float4 position [[position]];
    float4 color;
    float2 texcoords;
};

vertex VertOut finalRenderVsh(VertIn in [[stage_in]]) {
    VertOut out;
    out.position = in.position;
    out.color = in.color;
    out.texcoords = in.texcoords;
    return out;
}

fragment float4 finalRenderFsh(VertOut vert [[stage_in]], texture2d<float, access::sample> screen [[texture(0)]]) {
    float3 color = screen.sample(samp, vert.texcoords).rgb;
    
    return float4(color, 1.);
    
    return float4(palette(color.r * 5), 1.);
}


