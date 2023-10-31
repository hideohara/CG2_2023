#include "object3d.hlsli"

struct Material
{
    float32_t4 color;
    int32_t enableLighting;
};
struct DirectionalLight
{
    float32_t4 color; //!< ライトの色
    float32_t3 direction; //!< ライトの向き
    float intensity; //!< 輝度
};
struct Camera
{
    float32_t3 worldPosition;
};

ConstantBuffer<Material> gMaterial : register(b0);
ConstantBuffer<DirectionalLight> gDirectionalLight : register(b1);
ConstantBuffer<Camera> gCamera : register(b2);

struct PixelShaderOutput
{
    float32_t4 color : SV_TARGET0;
};
PixelShaderOutput main(VertexShaderOutput input)
{
    PixelShaderOutput output;
    //output.color = gMaterial.color;
    if (gMaterial.enableLighting != 0)
    { // Lightingする場合
        float32_t3 toEye = normalize(gCamera.worldPosition - input.worldPosition);
        float32_t3 reflectLight = reflect(gDirectionalLight.direction, normalize(input.normal));
        float RdotE = dot(reflectLight, toEye);
        float specularPow = pow(saturate(RdotE), 50); // 反射強度

        float cos = saturate(dot(normalize(input.normal), -gDirectionalLight.direction));
        //output.color = gMaterial.color * gDirectionalLight.color * cos * gDirectionalLight.intensity;
    
        // 拡散反射
        float32_t3 diffuse =
        gMaterial.color.rgb * gDirectionalLight.color.rgb * cos * gDirectionalLight.intensity;
        // 鏡面反射
        float32_t3 specular =
        gDirectionalLight.color.rgb * gDirectionalLight.intensity * specularPow * float32_t3(1.0f, 1.0f, 1.0f);
        // 拡散反射+鏡面反射
        output.color.rgb = diffuse + specular;
        // アルファは今まで通り
        output.color.a = gMaterial.color.a;


    }
    else
    { // Lightingしない場合。前回までと同じ演算
        output.color = gMaterial.color;
    }

    return output;
}


