Shader "Custom/ScreenSpaceTextureShader"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _SpotTexture ("Spot Texture", 2D) = "white" {}
        _SpotScreenPosition("Spot Screen Position", Vector) = (0,0,0,0)
        _SpotWorldPosition("Spot World Position", Vector) = (0,0,0,0)
        _SpotTextureScaleFactor("Spot Texture Scale", Float) = 1
        _PerspectiveScale("Perspective Scale", Float) = 1.0
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            const float3 vect3Zero = float3(0.0, 0.0, 0.0);

            sampler2D _MainTex;
            sampler2D _SpotTexture;
            float4 _SpotScreenPosition;
            float4 _SpotWorldPosition;
            float _PerspectiveScale;
            float _SpotTextureScale;
            float _SpotTextureScaleFactor;

            fixed4 frag (v2f_img i) : SV_Target
            {
                // Sample the main texture
                fixed4 col = tex2D(_MainTex, i.uv);
    
                // Calculate the normalized screen space UV for the spot
                float2 screenSpaceUV = (i.uv - _SpotScreenPosition.xy) * 2.0;
                screenSpaceUV.y *= _ScreenParams.y / _ScreenParams.x; // Correct for aspect ratio

                float distanceToSpot = length(_SpotWorldPosition - _WorldSpaceCameraPos);
                float perspectiveScale = 1.0 / (distanceToSpot * _PerspectiveScale);
                perspectiveScale *= _SpotTextureScaleFactor;

                // Scale UV to match the texture scale
                screenSpaceUV /= perspectiveScale;

                // Center the texture on the spot
                float2 centeredUV = screenSpaceUV + float2(0.5, 0.5);

                // Clamp the UVs so the texture doesn't tile
                float2 clampedUV = saturate(centeredUV);

                // Only apply the texture within its bounds
                if (all(clampedUV >= 0) && all(clampedUV <= 1))
                {
                    // Sample the spot texture using the clamped UV coordinates
                    fixed4 spotTexColor = tex2D(_SpotTexture, clampedUV);

                    // Blend the spot texture over the main texture based on the alpha of the spot texture
                    col = lerp(col, spotTexColor, spotTexColor.a);
                }

                return col;
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
