using UnityEngine;
using UnityEngine.Splines;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class CustomImageEffect : MonoBehaviour
{
    [SerializeField] private SplineContainer splineContainer;
    [SerializeField] private Material lineMaterial;
    [SerializeField] private Material screenEffectMaterial;
    private float spotProgress;
    private Vector3 worldPosition = Vector3.zero;
    private Vector3 spotViewportPosition = Vector3.zero;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, screenEffectMaterial);
    }

    void Update()
    {
        // Retrieve the speed from the line shader
        float speed = lineMaterial.GetFloat("_Speed");
        spotProgress = Mathf.Repeat(Time.time * speed, 1);

        // Get the world position of the spot on the spline
        worldPosition = splineContainer.EvaluatePosition(spotProgress);

        // pass the spot's screen and world position to the screen effect shader
        // convert world position to viewport position
        screenEffectMaterial.SetVector("_SpotWorldPosition", new Vector4(worldPosition.x, worldPosition.y, worldPosition.z, 1));
        spotViewportPosition = Camera.main.WorldToViewportPoint(worldPosition);
        screenEffectMaterial.SetVector("_SpotScreenPosition", new Vector4(spotViewportPosition.x, spotViewportPosition.y, 0, 0));
    }
}
