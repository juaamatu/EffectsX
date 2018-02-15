using UnityEngine;

namespace EffectsX
{
    /// <summary>
    /// Luminance outline based on pixel brightness.
    /// Inspired by Unity legacy image-effect edge detection
    /// </summary>
    public class LuminanceOutline : EffectBase
    {
        [SerializeField] private float m_SampleDistance = 2;
        [SerializeField] private float m_Threshold = 0.5f;
        [SerializeField] private Color m_OutlineColor = Color.black;

        protected override void CreateMaterial()
        {
            m_Material = new Material(Shader.Find("Hidden/LuminanceOutline"));
        }

        protected override void SetShaderProperties()
        {
            m_Material.SetFloat("_SampleDistance", m_SampleDistance);
            m_Material.SetFloat("_Threshold", m_Threshold * 0.01f);
            m_Material.SetColor("_Color", m_OutlineColor);
        }
    }
}