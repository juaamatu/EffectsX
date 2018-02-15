using UnityEngine;

namespace EffectsX
{
    /// <summary>
    /// Draws an outline based on depth and normals using Roberts Cross
    /// Inspired by Unity legacy image-effect edge detection
    /// </summary>
    public class RobertsCrossDepthNormalsOutline : EffectBase
    {
        [SerializeField] private float m_SampleDistance = 2;
        [SerializeField] private float m_SensitivityDepth = 1;
        [SerializeField] private float m_SensitivityNormals = 1;
        [SerializeField] private Color m_OutlineColor = Color.black;

        private void Start()
        {
            Camera.main.depthTextureMode = DepthTextureMode.DepthNormals;
        }

        protected override void CreateMaterial()
        {
            m_Material = new Material(Shader.Find("Hidden/RobertsCrossDepthNormalsOutline"));
        }

        protected override void SetShaderProperties()
        {
            m_Material.SetFloat("_SampleDistance", m_SampleDistance);
            m_Material.SetVector("_Sensitivity", new Vector4(m_SensitivityDepth, m_SensitivityNormals, 1, m_SensitivityNormals));
            m_Material.SetColor("_Color", m_OutlineColor);
        }
    }
}