Shader "Hidden/SobelOutline"
{
	Properties
	{
		_Color("Color", Color) = (0, 0, 0, 1)
		_SampleDistance("Sample Distance", float) = 5
		_Threshold("Threshold", float) = 0.5
	}
	SubShader
	{
		Tags { "Queue" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off ZWrite Off	ZTest Always

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
			
			sampler2D _MainTex;
			sampler2D _CameraDepthTexture;
			float4 _CameraDepthTexture_TexelSize;
			float _SampleDistance;
			float4 _Color;
			float _Threshold;

			fixed4 frag (v2f i) : SV_Target
			{
				float dist = _SampleDistance * _CameraDepthTexture_TexelSize.xy;
				float2 uv = i.screenPos.xy / i.screenPos.w;

				float4 x = float4(0, 0, 0, 0);
				float4 y = float4(0, 0, 0, 0);

				x += Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv + float2(-1, 1) * dist));			// TL
				x -= Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv + float2(1, 1) * dist));			// TR
				x -= Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv + float2(1, 0) * dist)) * 2;		// R
				x -= Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv + float2(1, -1) * dist));			// BR
				x += Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv + float2(-1, -1) * dist));			// BL
				x += Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv + float2(-1, 0) * dist)) * 2;		// L

				y += Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv + float2(-1, 1) * dist));			// TL
				y += Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv + float2(0, 1) * dist)) * 2;		// T
				y += Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv + float2(1, 1) * dist));			// TR
				y -= Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv + float2(1, -1) * dist));			// BR
				y -= Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv + float2(0, -1) * dist)) * 2;		// B
				y -= Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv + float2(-1, -1) * dist));			// BL

				float magnitude = sqrt(x * x + y * y);
				magnitude = step(_Threshold, magnitude);
				return lerp(float4(0, 0, 0, 0), _Color, magnitude);
			}
			ENDCG
		}
	}
}
