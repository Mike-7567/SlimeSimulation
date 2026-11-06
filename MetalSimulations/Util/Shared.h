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
};

struct Settings {
    float wanderStrength;
    float speed;
    float rotationAngle;
};

#endif /* Shared_h */
