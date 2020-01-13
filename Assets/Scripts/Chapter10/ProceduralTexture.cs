using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ProceduralTexture : MonoBehaviour
{
    public Material material = null;
    private Texture2D mGenTexture = null;

    #region Material Properties

    [SerializeField, SetProperty("TextureWidth")]
    private int mTextureWidth = 512;
    public int TextureWidth
    {
        get { return mTextureWidth; }
        set { mTextureWidth = value; UpdateMaterial(); }
    }
    
    [SerializeField, SetProperty("BgColor")]
    private Color mBgColor = Color.white;
    public Color BgColor
    {
        get { return mBgColor; }
        set { mBgColor = value; UpdateMaterial(); }
    }
   
    [SerializeField, SetProperty("CircleColor")]
    private Color mCircleColor = Color.yellow;
    public Color CircleColor
    {
        get { return mCircleColor; }
        set { mCircleColor = value; UpdateMaterial(); }
    }

    [SerializeField, SetProperty("BlurFactor")]
    private float mBlurFactor = 2.0f;
    public float BlurFactor
    {
        get { return mBlurFactor; }
        set { mBlurFactor = value; }
    }
    #endregion

    private void Start()
    {
        if (material == null)
        {
            Renderer renderer = gameObject.GetComponent<Renderer>();
            if (renderer == null)
            {
                Debug.LogWarning("Cannot find a renderer.");
                return;
            }

            material = renderer.sharedMaterial;
        }
        
        UpdateMaterial();
    }

    private void UpdateMaterial()
    {
        if (material != null)
        {
            mGenTexture = GenProcedureTexture();
            material.SetTexture("_MainTex", mGenTexture);
        }
    }
    
    private Color MixColor(Color color0, Color color1, float mixFactor) {
        Color mixColor = Color.white;
        mixColor.r = Mathf.Lerp(color0.r, color1.r, mixFactor);
        mixColor.g = Mathf.Lerp(color0.g, color1.g, mixFactor);
        mixColor.b = Mathf.Lerp(color0.b, color1.b, mixFactor);
        mixColor.a = Mathf.Lerp(color0.a, color1.a, mixFactor);
        return mixColor;
    }
    
    private Texture2D GenProcedureTexture()
    {
        Texture2D texture = new Texture2D(TextureWidth, TextureWidth);
        float circleInterval = TextureWidth / 4.0f;
        float radius = TextureWidth / 10.0f;
        float edgeBlur = 1.0f / BlurFactor;

        for (int w = 0; w < TextureWidth; w++)
        {
            for (int h = 0; h < TextureWidth; h++)
            {
                Color pixel = BgColor;
                for (int i = 0; i < 3; i++)
                {
                    for (int j = 0; j < 3; j++)
                    {
                        Vector2 circleCenter = new Vector2(circleInterval * (i + 1), circleInterval * (j + 1));
                        float dist = Vector2.Distance(new Vector2(w, h), circleCenter) - radius;
                        Color color = MixColor(CircleColor, new Color(pixel.r, pixel.g, pixel.a, 0), Mathf.SmoothStep(0f, 1f, dist * edgeBlur));
                        pixel = MixColor(pixel, color, color.a);
                    }
                }
                texture.SetPixel(w, h, pixel);
            }
        }
        
        texture.Apply();
        return texture;
    }
}
