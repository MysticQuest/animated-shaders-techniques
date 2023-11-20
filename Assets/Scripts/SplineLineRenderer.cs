using UnityEngine;
using UnityEngine.Splines;

[RequireComponent(typeof(LineRenderer))]
public class SplineLineRenderer : MonoBehaviour
{
    public SplineContainer splineContainer;
    private LineRenderer lineRenderer;

    void Start()
    {
        lineRenderer = GetComponent<LineRenderer>();
        lineRenderer.startColor = Color.yellow;
        lineRenderer.endColor = Color.yellow;
        lineRenderer.startWidth = 0.1f;
        lineRenderer.endWidth = 0.1f;
        UpdateLineRenderer();
    }

    void Update()
    {
        UpdateLineRenderer();
    }

    void UpdateLineRenderer()
    {
        if (splineContainer != null && splineContainer.Splines.Count > 0)
        {
            Spline spline = splineContainer.Splines[0]; // first and only spline
            int segmentCount = 100; // increase/decrease the line resolution
            Vector3[] points = new Vector3[segmentCount];

            for (int i = 0; i < segmentCount; i++)
            {
                float t = i / (segmentCount - 1.0f);
                points[i] = splineContainer.EvaluatePosition(0, t);
            }

            lineRenderer.positionCount = segmentCount;
            lineRenderer.SetPositions(points);
        }
    }
}
