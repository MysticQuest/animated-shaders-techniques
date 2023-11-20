Shader "Custom/BillboardShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Scale ("Faux Scale", Float) = 0.0
        _DepthOffset("Depth Offset", Float) = 0.0
        _Color("Tint Color", Color) = (1,1,1,1)
        
        _ZTestMode("ZTest Mode", Float) = 4
    }
   
    SubShader
    {
        Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "DisableBatching" = "False" }
 
        ZWrite Off
        ZTest [_ZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha
 
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
 
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };
 
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
 
            const float3 vect3Zero = float3(0.0, 0.0, 0.0);
 
            sampler2D _MainTex;
            float _Scale;
            float _DepthOffset;
            float _ZTestMode;
            float4 _Color;
 
            v2f vert(appdata v)
            {
                v2f o;

                // This gives us the camera's origin in 3D space (the position (0,0,0) in Camera Space)
                float4 camPos = float4(UnityObjectToViewPos(vect3Zero).xyz, 1.0);    
 
                // Since w is 0.0 this represents a vector direction instead of a position
                float4 viewDir = float4(v.pos.x, v.pos.y, 0.0, 0.0);

                // Add the camera position and direction, then multiply by UNITY_MATRIX_P to get the new projected vert position
                float4 outPos = mul(UNITY_MATRIX_P, camPos + viewDir * _Scale);            
                outPos.z += _DepthOffset;
                o.pos = outPos;
                o.uv = v.uv;

                return o;
            }
 
            fixed4 frag(v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv) * _Color;
            }
            ENDCG
        }
    }
}