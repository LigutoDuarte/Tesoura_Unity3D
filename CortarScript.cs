using UnityEngine;

[ExecuteAlways]
public class CortarScript : MonoBehaviour {
	//Material que passaremos os valores
	public Material mat;
	
	//Essa função será executada a toda atualização de frame
	void Update () {
        //Criar o objeto Plano e descobrir a posição atual
        Plane plane = new Plane(transform.up, transform.position);
        //transferir os valores do Plano para o Vetor 4 (Vector 4)
        Vector4 planeRepresentation = new Vector4(
	plane.normal.x, 
	plane.normal.y, 
	plane.normal.z, 
	plane.distance
	);

	//Passando o vetor para o Shader
	mat.SetVector("_Plane", planeRepresentation);
	}
}



