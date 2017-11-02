Shader "Unlit/SepiaWithTransparency"
{
	Properties {
        _Color ("Color Tint", Color) = (1,1,1,1)
        _MainTex ("SelfIllum Color (RGB) Alpha (A)", 2D) = "white"
		_Intensity ("Effect Strength", Float) = 1
    }
    Category {
       Lighting On
       ZWrite Off
       Cull Front
       Blend SrcAlpha OneMinusSrcAlpha
       Tags {Queue=Transparent}
       SubShader {
            Material {
               Emission [_Color]
            }
            Pass {
               SetTexture [_MainTex] {
                      Combine Texture * Primary, Texture * Primary
                }
            }
			
			Pass {
				CGPROGRAM
				#pragma vertex vert_img
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest 
				#include "UnityCG.cginc"

				uniform sampler2D _MainTex;
				uniform Float _Intensity;

				float4 frag (v2f_img i) : COLOR
				{	
					float4 original = tex2D(_MainTex, i.uv);
	
					// get intensity value (Y part of YIQ color space)
					float Y = dot (float3(0.299, 0.587, 0.114), original.rgb);

					// Convert to Sepia Tone by adding constant
					float4 sepiaConvert = float4 (0.191, -0.054, -0.221, 0.0);
					float4 output = sepiaConvert + Y;
					output = lerp(output, original, 1 - _Intensity);

					output.a = original.a;
	
					return output;
				}
				ENDCG
			}
			
        } 
    }
}
 
