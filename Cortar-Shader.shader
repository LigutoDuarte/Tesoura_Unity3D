Shader "Cortar-Shader"{
	//Mostrar os valores que poderão ser editados via Unity (Menu)
	Properties{
		_Color ("Tint", Color) = (0, 0, 0, 1)
		_MainTex ("Texture", 2D) = "white" {}
		_Smoothness ("Smoothness", Range(0, 1)) = 0
		_Metallic ("Metalness", Range(0, 1)) = 0
		[HDR]_Emission ("Emission", color) = (0,0,0)
		[HDR]_CutoffColor("Cutoff Color", Color) = (1,0,0,0)
	}

	SubShader{
		//O material é completamente não transparente e é renderizado ao mesmo tempo 
		//que a outra geometria opaca
		Tags{ "RenderType"="Opaque" "Queue"="Geometry"}

		// Renderizar os planos se não estiverem posicionados direcionados para a camera
		Cull Off

		CGPROGRAM
		// O shader é um shader de superfície, o que significa que ele será estendido por 
		// unidade no fundo para ter iluminação sofisticada e outros recursos
		// A função de shader de superfície é chamada de surf e usamos nosso modelo de 
		// iluminação personalizado

		#pragma surface surf Standard 
		#pragma target 3.0

		sampler2D _MainTex;
		fixed4 _Color;

		half _Smoothness;
		half _Metallic;
		half3 _Emission;

		float4 _Plane;

		float4 _CutoffColor;

		//estrutura de entrada que é preenchida automaticamente pela unidade
		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
			float facing : VFACE;
		};

		//a função de shader de superfície que define os parâmetros que a função de
		// iluminação usa
		void surf (Input i, inout SurfaceOutputStandard o) {
			//calcula a distância até o plano
			float distance = dot(i.worldPos, _Plane.xyz);
			distance = distance + _Plane.w;
			//descarta a superfície acima do plano
			clip(-distance);
			
			//nessa hora é traçado o shader pelo objeto, fazendo com que seja 
			//aparente o interior do mesmo
			float facing = 0.9;
			
			//Cores normais
			fixed4 col = tex2D(_MainTex, i.uv_MainTex);
			col *= _Color;
			o.Albedo = col.rgb * facing;
			o.Metallic = _Metallic * facing;
			o.Smoothness = _Smoothness * facing;
			o.Emission = lerp(_CutoffColor, _Emission, facing);
		}
		ENDCG
	}
FallBack "Standard" //fallback adiciona uma passagem de sombra para que tenhamos sombras em outros objetos
}