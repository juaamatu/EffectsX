using UnityEngine;

namespace EffectsX
{
    /// <summary>
    /// Draws the outline by inverting hulls and extruding mesh with normals
    /// </summary>
    public class InvertedHullsOutline : EffectBase
    {
        [SerializeField] private float m_OutlineWidth = 5;
        [SerializeField] private Color m_OutlineColor = Color.black;

        protected override void CreateMaterial()
        {
            m_Material = new Material(Shader.Find("Hidden/InvertedHullsOutline"));
        }

        protected override void SetShaderProperties()
        {
            m_Material.SetFloat("_OutlineSize", m_OutlineWidth / 1000);
            m_Material.SetColor("_Color", m_OutlineColor);
        }
    }
}