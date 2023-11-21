using System.Linq;
using UnityEngine;
using UnityEngine.Splines;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class CustomImageEffect : MonoBehaviour
{
    [SerializeField] private Material screenEffectMaterial;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, screenEffectMaterial);
    }
}
