//
//  UpdateAgents.metal
//  MetalSimulations
//
//  Created by Gabriel Thomson on 12/6/24.
//

#include <metal_stdlib>
using namespace metal;
#include "../Util.h"

struct Agent {
    float3 position;
    float angle;
};

struct Settings {
    float wanderStrength;
    float speed;
    float rotationAngle;
};

kernel void updateAgents(uint index [[thread_position_in_grid]], texture2d<float, access::sample> inTexture [[texture(0)]], texture2d<float, access::write> outTexture [[texture(1)]], device Agent *agents [[buffer(0)]], constant Settings &settings [[buffer(1)]], constant uint &screenScale [[buffer(2)]]) {
    float sizeOfScreen = screenScale;
    float speed = 1.25;
    float rotationAngle = 1.25;
    float wanderStrength = 0.7;
    
    speed = settings.speed;
    rotationAngle = settings.rotationAngle;
    wanderStrength = settings.wanderStrength;
    
    float3 senceResult = sence(agents[index].angle, rotationAngle, speed, agents[index].position.xy, inTexture);
    float wanderValue = (normalizedHash(agents[index].position.x - index * agents[index].position.y) * 2 - 1) * wanderStrength;
    
    if (senceResult.y > senceResult.x && senceResult.y > senceResult.z) {
        //Stay facing same direction
    } else if (senceResult.y < senceResult.x && senceResult.y < senceResult.z) {
        //Rotate randomly left or right
        agents[index].angle += rotationAngle * sign(normalizedHash(agents[index].position.y * index + agents[index].position.x) - .5) + wanderValue;
    } else if (senceResult.x < senceResult.z) {
        //Rotate right
        agents[index].angle += -rotationAngle + wanderValue;
    } else if (senceResult.z < senceResult.x) {
        //Rotate left
        agents[index].angle += rotationAngle + wanderValue;
    }
    
    agents[index].position.y = agents[index].position.y + (sin(agents[index].angle) * speed);
    agents[index].position.x = agents[index].position.x + (cos(agents[index].angle) * speed);
    
    if (agents[index].position.x < 0) {
        agents[index].position.x = 0;
        agents[index].angle += 3;
    }
    if (agents[index].position.x >= 16 * sizeOfScreen) {
        agents[index].position.x = 16 * sizeOfScreen - 1;
        agents[index].angle += 3;
    }
    if (agents[index].position.y < 0) {
        agents[index].position.y = 0;
        agents[index].angle += 3;
    }
    if (agents[index].position.y >= 9 * sizeOfScreen) {
        agents[index].position.y = 9 * sizeOfScreen - 1;
        agents[index].angle += 3;
    }
    
    
    
    
    int x = int(agents[index].position.x);
    int y = int(agents[index].position.y);
    
    outTexture.write(float4(1., 1., 1., 1.), uint2(x, y));
}


