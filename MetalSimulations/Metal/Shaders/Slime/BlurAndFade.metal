//
//  BlurAndFade.metal
//  MetalSimulations
//
//  Created by Gabriel Thomson on 12/7/24.
//

#include <metal_stdlib>
using namespace metal;

kernel void blurAndFade(uint2 index [[thread_position_in_grid]], texture2d<float, access::read> inTexture [[texture(0)]], texture2d<float, access::write> outTexture [[texture(1)]], constant uint &screenScale [[buffer(2)]]) {
    
    float3 totalValues = inTexture.read(index).rgb;
    int numOfValues = 1;
    
    if (index.x > 0) {
        numOfValues += 1;
        totalValues += inTexture.read(uint2(index.x - 1, index.y)).rgb;
    }
    if (index.x < 16 * screenScale - 1) {
        numOfValues += 1;
        totalValues += inTexture.read(uint2(index.x + 1, index.y)).rgb;
    }
    if (index.y > 0) {
        numOfValues += 1;
        totalValues += inTexture.read(uint2(index.x, index.y - 1)).rgb;
    }
    if (index.y < 9 * screenScale - 1) {
        numOfValues += 1;
        totalValues += inTexture.read(uint2(index.x, index.y + 1)).rgb;
    }
    
    outTexture.write(float4((totalValues / numOfValues) - 0.005, 1.), index);
}
