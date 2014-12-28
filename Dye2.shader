Shader "Dye/dye2" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Area1R("Area1 R", vector) = (1.0,0,0,0)
		_Area1G("Area1 G", vector) = (0.0,1.0,0,0)
		_Area1B("Area1 B", vector) = (0.0,0,1.0,0)
		
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		half4 _Area1R;
		half4 _Area1G;
		half4 _Area1B;
		
		struct Input {
			float2 uv_MainTex;
		};
		
		half3 combine_one(half c, half4 a)
		{
			half3 newc = half3(c*a.r, c*a.g, c*a.b);
			return newc;
		}
		
		half3 combine_color(half4 ca, half4 a, half4 b, half4 c)
		{
			half3 newr = combine_one(ca.r,  a);
			half3 newg = combine_one(ca.g,  b);
			half3 newb = combine_one(ca.b,  c);
			
			half3 ans1 = newr + newg + newb;
			return ans1;
		}
		
		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			half3 area1c = combine_color(c, _Area1R, _Area1G, _Area1B);
			o.Albedo = area1c;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
