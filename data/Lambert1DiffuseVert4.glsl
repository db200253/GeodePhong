#define PROCESSING_LIGHT_SHADER

uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

uniform int lightCount;
uniform vec4 lightPosition[8];
uniform vec3 lightDiffuse[8];
uniform vec3 lightAmbient[8];
uniform vec3 lightSpecular[8];

attribute vec4 emissive;
attribute float shininess; 
attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;

float lambertFactor(vec3 lightDir, vec3 vecNormal) {
    return max(0.0, dot(lightDir, vecNormal));
}

float blinnPhongFactor(vec3 lightDir, vec3 vertPos, vec3 vecNormal, float shine) {
    vec3 np = normalize(vertPos);
    vec3 ldp = normalize(lightDir - np);
    return pow(max(0.0, dot(ldp, vecNormal)), shine);
}

void main() {
    gl_Position = transform * position;
  
    vec3  ecPosition = vec3(modelview * position);
    vec3  ecNormal   = normalize(normalMatrix * normal);
    vec3  dfColor    = vec3(0);
    vec3  amColor    = vec3(0);
    vec3  spColor    = vec3(0);

    if(emissive.x > 0 || emissive.y > 0 || emissive.z > 0) {
        vertColor = emissive;
    } else {
        for(int i=0; i<lightCount; i++) {
            vec3  direction = normalize(lightPosition[i].xyz - ecPosition);
            float intensity = lambertFactor(direction, ecNormal);
            float spec      = blinnPhongFactor(direction, ecPosition, ecNormal, shininess);
    
            dfColor += color.rgb * lightDiffuse[i] * intensity;
            spColor += lightSpecular[i] * spec;
            amColor += lightAmbient[i];
        }

        vertColor = vec4(dfColor + amColor + spColor, color.a);
    }
}
