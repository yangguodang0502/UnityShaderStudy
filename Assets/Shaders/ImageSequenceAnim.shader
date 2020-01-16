Shader "Custom/ImageSequenceAnim"
{
    Properties
    {
        _Color("Color Tint", Color) = (1, 1 ,1, 1)
        _MainTex ("Texture", 2D) = "white" {}
        _HorizontalAmount("Horizontal Amount", Float) = 4
        _VerticalAmount("Vertical Amount", Float) = 4
        _Speed("Speed", Range(1, 100)) = 30
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }

        Pass
        {
            Tags { "LightMode"="ForwardBase" }
            
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            
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
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            float _HorizontalAmount;
            float _VerticalAmount;
            float _Speed;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float time = floor(_Time.y * _Speed);
                float yIndex = floor(time / _HorizontalAmount);
                float xIndex = time - yIndex * _VerticalAmount;
                
                half2 uv = half2((i.uv.x + xIndex) / _HorizontalAmount, (i.uv.y - yIndex) / _VerticalAmount);
                
                fixed4 col = tex2D(_MainTex, uv);
                col.rgb *=  _Color;
                return col;
            }
            ENDCG
        }
    }
    FallBack "Transparent/VertexLit"
}
