struct VertexShaderOutput
{
    float32_t4 position : SV_POSITION;
    float32_t4 color : COLOR0;
};

struct Material
{
    float32_t4 color;
};
ConstantBuffer<Material> gMaterial : register(b0);
struct PixelShaderOutput
{
    float32_t4 color : SV_TARGET0;
};
PixelShaderOutput main(VertexShaderOutput input)
{
    PixelShaderOutput output;
    //output.color = gMaterial.color;
    output.color = gMaterial.color * input.color;
    return output;
}


