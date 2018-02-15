// Inspired by Unity image-effect egde detection
Shader "Hidden/LuminanceOutline"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SampleDistance("Sample Distance", float) = 1
		_Threshold("Threshold", float) = 1
		_Color("Color", Color) = (0, 0, 0, 1)
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent" }
		Cull Off ZWrite On ZTest Always

		GrabPass { }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 screenPos : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.screenPos = ComputeScreenPos(o.vertex);
				return o;
			}
			
			sampler2D _GrabTexture;
			float4 _GrabTexture_TexelSize;
			float _SampleDistance;
			float _Threshold;
			float4 _Color;

			fixed4 frag (v2f i) : SV_Target
			{
				float dist = _GrabTexture_TexelSize.xy * _SampleDistance;
				float2 uv = i.screenPos.xy / i.screenPos.w;

				half3 center = tex2D(_GrabTexture, uv);
				half3 left = tex2D(_GrabTexture, uv + float2(-1, 0) * dist);
				half3 right = tex2D(_GrabTexture, uv + float2(1, 0) * dist);
				half3 top = tex2D(_GrabTexture, uv + float2(0, 1) * dist);
				half3 bottom = tex2D(_GrabTexture, uv + float2(0, -1) * dist);
				// we probably dont really need diagonal data but here it is anyhow
				half3 topLeft = tex2D(_GrabTexture, uv + float2(-1, 1) * dist);
				half3 topRight = tex2D(_GrabTexture, uv + float2(1, 1) * dist);
				half3 bottomRight = tex2D(_GrabTexture, uv + float2(1, -1) * dist);
				half3 bottomLeft = tex2D(_GrabTexture, uv + float2(-1, -1) * dist);

				half3 diff = center * 8 - left - right - top - bottom - topLeft - topRight - bottomRight- bottomLeft;
				half len = dot(diff, diff);
				len = step(_Threshold, len);
				return lerp(tex2D(_GrabTexture, uv), _Color, len);
			}
			ENDCG
		}
	}
}
