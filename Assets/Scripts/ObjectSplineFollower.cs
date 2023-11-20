using UnityEngine;
using UnityEngine.Splines;

public class ObjectSplineFollower : MonoBehaviour
{
    public SplineContainer splineContainer;
    public GameObject objectToMove;
    public float speed = 1.0f; // Units per second
    private float t = 0.0f; // Normalized time along the spline

    void Update()
    {
        if (splineContainer != null && objectToMove != null)
        {
            // Increment t based on the speed and time
            t += speed * Time.deltaTime;
            t = Mathf.Clamp01(t); // Ensure t stays between 0 and 1

            // Calculate the position of the object at time t
            Vector3 newPosition = splineContainer.EvaluatePosition(t);

            // Set the object's position to the new position
            objectToMove.transform.position = newPosition;

            // Optionally, look forward along the spline
            if (t < 1.0f)
            {
                Vector3 nextPosition = splineContainer.EvaluatePosition(Mathf.Clamp01(t + 0.01f));
                objectToMove.transform.LookAt(nextPosition);
            }

            // Reset t for loop
            if (t >= 1.0f)
            {
                t = 0.0f;
            }
        }
    }
}
