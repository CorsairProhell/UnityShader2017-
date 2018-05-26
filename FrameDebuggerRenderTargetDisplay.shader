Shader "ShaderStor/UnitShader2017//FrameDebuggerRenderTargetDisplay"
{
	Properties
	{
		_MainTex ("Texture", any) = "white" {}
		_Channels("Channel",Vector)= (1,1,1,1)
		_Levels("_Levels",Vector)= (1,1,1,1)
		
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue"="Transparent"}
		//Blend SrcAlpha OneMinusSrcAlpha
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 uv : TEXCOORD0;
			};

			struct v2f
			{
				float3 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Channels;
    		half4 _Levels;
			
			fixed4 ProcessColor (half4 tex)
			{
				// adjust levels
				half4 col = tex;
				col -= _Levels.rrrr;
				col /= _Levels.gggg-_Levels.rrrr;

				// leave only channels we want to show
				col *= _Channels;

				// if we're showing only a single channel, display that as grayscale
				if (dot(_Channels,fixed4(1,1,1,1)) == 1.0)
				{
					half c = dot(col,half4(1,1,1,1));
					col = c;
				}

				return col;
			}

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half4 tex = tex2D (_MainTex, i.uv.xy);
                return ProcessColor (tex);
			}
			ENDCG
		}
	}
}
