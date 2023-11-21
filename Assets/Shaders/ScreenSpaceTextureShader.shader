// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ScreenSpaceTextureShader"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _SpotTexture ("Spot Texture", 2D) = "white" {}
        _TextureColor ("Texture Color", Color) = (1,1,1,1)
        [HideInInspector] _SpotWorldPosition("Spot World Position", Vector) = (0,0,0,0)
        _SpotTextureScaleFactor("Spot Texture Scale", Float) = 1
        [HideInInspector] _PerspectiveScale("Perspective Scale", Float) = 1.0
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
            sampler2D _CameraDepthTexture;
            float4 _TextureColor;
            float4 _SpotWorldPosition;
            float _PerspectiveScale;
            float _SpotTextureScaleFactor;

            fixed2 WorldToScreenPos(fixed3 vectorWorldToCam){
                vectorWorldToCam = normalize(vectorWorldToCam - _WorldSpaceCameraPos);
                fixed3 vectorCameraSpace = mul(unity_WorldToCamera, vectorWorldToCam);
                fixed height = 2 * vectorCameraSpace.z / unity_CameraProjection._m11;
                fixed width = _ScreenParams.x / _ScreenParams.y * height;
                fixed2 uv = 0;
                uv.x = (vectorCameraSpace.x + width / 2) / width;
                uv.y = (vectorCameraSpace.y + height / 2) / height;
                return uv;
            }

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                fixed2 _SpotScreenPosition = WorldToScreenPos(_SpotWorldPosition);

                // Calculate the normalized screen space UV for the spot
                float2 screenSpaceUV = i.uv - _SpotScreenPosition;
                // Correct for aspect ratio
                screenSpaceUV.y *= _ScreenParams.y / _ScreenParams.x; 

                // Distance to scale 
                float distanceToSpot = length(_SpotWorldPosition - _WorldSpaceCameraPos);
                float perspectiveScale = 1.0 / (distanceToSpot * _PerspectiveScale);
                perspectiveScale *= _SpotTextureScaleFactor;

                // Scale UV to match the texture scale
                screenSpaceUV /= perspectiveScale;

                // Center the texture on the spot
                float2 centeredUV = screenSpaceUV + float2(0.5, 0.5);

                // Clamp the UVs so the texture doesn't tile
                float2 clampedUV = saturate(centeredUV);

                // Sample the spot texture using the clamped UV coordinates
                fixed4 spotTexColor = tex2D(_SpotTexture, clampedUV);
                spotTexColor *= _TextureColor;
                // Blend the spot texture over the main texture based on the alpha of the spot texture
                col = lerp(col, spotTexColor, spotTexColor.a);

                return col;
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
