Shader "Custom/ScrollingBackground"
{
    Properties
    {
        _MainTex ("Base Layer", 2D) = "white" {}
        _DetailTex ("Second Layer", 2D) = "white" {}
        _BaseScrollSpeed("Base Layer Scroll Speed", Float) = 1.0
        _DetailScrollSpeed("Second Layer Scroll Speed", Float) = 1.0
        _Multiplier("Layer Multiplier", Float) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _DetailTex;
            float4 _DetailTex_ST;
            float _BaseScrollSpeed;
            float _DetailScrollSpeed;
            float _Multiplier;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex) + frac(float2(_BaseScrollSpeed, 0.0) * _Time.y);
                o.uv.zw = TRANSFORM_TEX(v.texcoord, _DetailTex) + frac(float2(_DetailScrollSpeed, 0.0) * _Time.y);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 firstLayer = tex2D(_MainTex, i.uv.xy);
                fixed4 secondLayer = tex2D(_DetailTex, i.uv.zw);
                fixed4 col = lerp(firstLayer, secondLayer, secondLayer.a);
                col.rgb *=  _Multiplier;
                return col;
            }
            ENDCG
        }
    }
    FallBack "VertexLit"
}
