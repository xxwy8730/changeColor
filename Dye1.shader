Shader "Dye/dye1" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_AreaTex ("AreaTex", 2D) = "red" {}
		_Area1R("Area1 R", vector) = (1.0,0,0,0)
		_Area1G("Area1 G", vector) = (0.0,1.0,0,0)
		_Area1B("Area1 B", vector) = (0.0,0,1.0,0)
		
		_Area2R("Area2 R", vector) = (1.0,0,0,0)
		_Area2G("Area2 G", vector) = (0.0,1.0,0,0)
		_Area2B("Area2 B", vector) = (0.0,0,1.0,0)
		
		_Area3R("Area3 R", vector) = (1.0,0,0,0)
		_Area3G("Area3 G", vector) = (0.0,1.0,0,0)
		_Area3B("Area3 B", vector) = (0.0,0,1.0,0)
		
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _AreaTex;
		half4 _Area1R;
		half4 _Area1G;
		half4 _Area1B;

		half4 _Area2R;
		half4 _Area2G;
		half4 _Area2B;
	
		half4 _Area3R;
		half4 _Area3G;
		half4 _Area3B;
		
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
			half4 bianSe = tex2D (_AreaTex, IN.uv_MainTex);
			
			half area1 = step(0.9, bianSe.r);
			half area2 = step(0.9, bianSe.g);
			half area3 = step(0.9, bianSe.b);
			half orgin = step(area1+area2+area3, 0.99);


			half3 area1c = combine_color(c, _Area1R, _Area1G, _Area1B);
			half3 area2c = combine_color(c, _Area2R, _Area2G, _Area2B);
			half3 area3c = combine_color(c, _Area3R, _Area3G, _Area3B);
			
						
			half3 orginColor = half3(c.r, c.g, c.b);				
		
			half3 allc = orginColor*orgin + area1c*area1 + area2c*area2 + area3c*area3;


			o.Albedo = allc;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
