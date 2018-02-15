Shader "Hidden/InvertedHullsOutline"
{
	Properties
	{
		_Color("Color", Color) = (0, 0, 0, 1)
		_OutlineSize("Outline Size", float) = 1
	}

	SubShader
	{
		Cull Front ZWrite On ZTest LEqual

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			float _OutlineSize;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertex.xyz += -v.normal * _OutlineSize;
				return o;
			}
			
			float4 _Color;

			fixed4 frag (v2f i) : SV_Target
			{
				return _Color;
			}
			ENDCG
		}
	}
}