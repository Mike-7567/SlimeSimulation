//
//  Math.h
//  MetalSimulations
//
//  Created by Gabriel Thomson on 12/8/24.
//

#ifndef Math_h
#define Math_h

uint hash(uint i);

float normalizedHash(uint i);

float3 sence(float angle, float sensorAngleOffset, float sensorDistance, float2 position, texture2d<float, access::sample>);

float3 palette(float t);

#endif /* Math_h */
