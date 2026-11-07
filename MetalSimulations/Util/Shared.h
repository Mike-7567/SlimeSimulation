//
//  Shared.h
//  MetalSimulations
//
//  Created by Gabriel Thomson on 11/6/26.
//

#include <simd/simd.h>

#ifndef Shared_h
#define Shared_h

struct Agent {
    simd_float3 position;
    float angle;
    simd_float4 speciesMask;
};

struct SettingsStruct {
    float wanderStrength;
    float speed;
    float rotationAngle;
};

#endif /* Shared_h */
