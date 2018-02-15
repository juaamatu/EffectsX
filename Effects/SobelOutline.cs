using UnityEngine;

namespace EffectsX
{
    /// <summary>
    /// Draws the outline based on the Sobel operator
    /// https://en.wikipedia.org/wiki/Sobel_operator
    /// </summary>
    public class SobelOutline : EffectBase
    {
        [SerializeField] private float m_SampleDistance = 2;
        [SerializeField] private float m_Threshold = 0.5f;
        [SerializeField] private Color m_OutlineColor = Color.black;

        private void Start()
        {
            Camera.main.depthTextureMode = DepthTextureMode.Depth;
        }

        protected override void CreateMaterial()
        {
            m_Material = new Material(Shader.Find("Hidden/SobelOutline"));
        }

        protected override void SetShaderProperties()
        {
            m_Material.SetFloat("_SampleDistance", m_SampleDistance);
            m_Material.SetFloat("_Threshold", m_Threshold);
            m_Material.SetColor("_Color", m_OutlineColor);
        }
    }
}