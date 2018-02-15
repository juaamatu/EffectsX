using UnityEngine;

namespace EffectsX
{
    /// <summary>
    /// Base class used by all per object effect scripts
    /// </summary>
    public abstract class EffectBase : MonoBehaviour
    {
        public bool m_DrawEffect = true;        // Toggles drawing
        protected MeshFilter m_MeshFilter;      // Reference to mesh filter component so we can access static mesh
        protected MeshRenderer m_MeshRenderer;  // Reference to mesh renderer component so we can access sub mesh count
        protected SkinnedMeshRenderer m_SkinnedMeshRenderer;    // Reference to skinned mesh renderer so we can bake skinned mesh
        protected Material m_Material;          // Effect material we are going to use for drawing
        protected Mesh m_SkinnedMesh;           // Skinned mesh reference used for drawing

        /// <summary>
        /// Reference needed component and create material
        /// </summary>
        protected virtual void Awake()
        {
            m_MeshFilter = GetComponentInChildren<MeshFilter>();
            m_SkinnedMeshRenderer = GetComponentInChildren<SkinnedMeshRenderer>();
            m_MeshRenderer = GetComponentInChildren<MeshRenderer>();
            CreateMaterial();
        }

        /// <summary>
        /// Check if we should draw and set shader properties
        /// </summary>
        protected virtual void Update()
        {
            if ((m_MeshFilter == null && m_MeshRenderer == null) && m_SkinnedMeshRenderer == null)
            {
                Debug.LogError("No mesh renderer and mesh filter or skinned mesh renderer found in object " + gameObject.name);
                enabled = false;
                return;
            }

            if (!m_DrawEffect)
                return;

            SetShaderProperties();
            Draw();
        }

        /// <summary>
        /// Draw either static mesh or skinned mesh based on available components
        /// </summary>
        protected virtual void Draw()
        {
            Destroy(m_SkinnedMesh);     // Destroy to avoid memory leak

            if (m_MeshFilter != null && m_MeshRenderer != null)
            {
                DrawStaticMesh();
            }

            if (m_SkinnedMeshRenderer != null)
            {
                DrawSkinnedMesh();
            }
        }

        /// <summary>
        /// Create the matrial that is used to draw effect
        /// </summary>
        protected virtual void CreateMaterial()
        {
            m_Material = new Material(Shader.Find("Standard"));
        }

        /// <summary>
        /// Draws the static mesh by using mesh provided by mesh filter
        /// </summary>
        protected virtual void DrawStaticMesh()
        {
            for (int i = 0; i < m_MeshRenderer.sharedMaterials.Length; i++)
            {
                Graphics.DrawMesh(m_MeshFilter.sharedMesh, transform.position, transform.rotation, m_Material, gameObject.layer, Camera.main, i, null, false, false, true);
            }
        }

        /// <summary>
        /// Draw skinned mesh by baking mesh with skinned mesh renderer
        /// </summary>
        protected virtual void DrawSkinnedMesh()
        {
            m_SkinnedMesh = new Mesh();
            m_SkinnedMeshRenderer.BakeMesh(m_SkinnedMesh);
            for (int i = 0; i < m_SkinnedMeshRenderer.sharedMaterials.Length; i++)
            {
                Graphics.DrawMesh(m_SkinnedMesh, transform.position, transform.rotation, m_Material, gameObject.layer, Camera.main, i, null, false, false, true);
            }
        }

        /// <summary>
        /// All shader property updates should be put here
        /// </summary>
        protected virtual void SetShaderProperties()
        {
        }
    }
}