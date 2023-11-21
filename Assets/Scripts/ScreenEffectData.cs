using System.Linq;
using UnityEngine;
using UnityEngine.Splines;
public class ScreenEffectData : MonoBehaviour
{
    [SerializeField] private SplineContainer splineContainer;
    [SerializeField] private Material lineMaterial;
    [SerializeField] private Material screenEffectMaterial;
    private float spotProgress;
    private Vector3 worldPosition = Vector3.zero;
    private float speed;

    private void Start()
    {
        speed = lineMaterial.GetFloat("_Speed");
        screenEffectMaterial.SetFloat("_Speed", speed);
    }

    void Update()
    {
        spotProgress = Mathf.Repeat(Time.time * speed, 1);
        worldPosition = splineContainer.EvaluatePosition(spotProgress);
        screenEffectMaterial.SetVector("_SpotWorldPosition", new Vector4(worldPosition.x, worldPosition.y, worldPosition.z, 0));
    }
}
