Shader "Hidden/RobertsCrossDepthNormalsOutline"
{
	SubShader
	{
		Tags{ "Queue" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off ZWrite Off	ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			half4 _Sensitivity;

			// This function is directly from Unity3D standard assets edge detection image-effect shader
			inline half CheckSame(half2 centerNormal, float centerDepth, half4 theSample)
			{
				// difference in normals
				// do not bother decoding normals - there's no need here
				half2 diff = abs(centerNormal - theSample.xy) * _Sensitivity.y;
				half isSameNormal = (diff.x + diff.y) * _Sensitivity.y < 0.1;
				// difference in depth
				float sampleDepth = DecodeFloatRG(theSample.zw);
				float zdiff = abs(centerDepth - sampleDepth);
				// scale the required threshold by the distance
				half isSameDepth = zdiff * _Sensitivity.x < 0.09 * centerDepth;

				// return:
				// 1 - if normals and depth are similar enough
				// 0 - otherwise

				return isSameNormal * isSameDepth;
			}

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
			
			sampler2D _CameraDepthNormalsTexture;
			float4 _CameraDepthNormalsTexture_TexelSize;
			float _SampleDistance;
			float4 _Color;

			fixed4 frag (v2f i) : SV_Target
			{
				float dist = _SampleDistance * _CameraDepthNormalsTexture_TexelSize.xy;
				float2 uv = i.screenPos.xy / i.screenPos.w;
				
				half4 tr = tex2D(_CameraDepthNormalsTexture, uv + float2(1, 1) * dist);
				half4 bl = tex2D(_CameraDepthNormalsTexture, uv + float2(-1, -1) * dist);
				half4 tl = tex2D(_CameraDepthNormalsTexture, uv + float2(-1, 1) * dist);
				half4 br = tex2D(_CameraDepthNormalsTexture, uv + float2(1, -1) * dist);			

				half edge = 1.0;

				edge *= CheckSame(tr.xy, DecodeFloatRG(tr.zw), bl);
				edge *= CheckSame(tl.xy, DecodeFloatRG(tl.zw), br);

				return lerp(_Color, float4(0, 0, 0, 0), edge);
			}
			ENDCG
		}
	}
}
