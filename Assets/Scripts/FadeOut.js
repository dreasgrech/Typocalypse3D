#pragma strict

var colorStart : Color;
var colorEnd : Color;
var duration = 1.0;

function Start () {
  colorStart = renderer.material.color;
  colorEnd = Color(colorStart.r, colorStart.g, colorStart.b, 0.0);
}

function Update () {
  FadeOut();
}

function FadeOut ()
{
  for (var t = 0.0; t < duration; t += Time.deltaTime) {
	  //print(renderer.material);
      print(renderer.materials[1]);
      renderer.materials[1].color = Color.Lerp (colorStart, colorEnd, t/duration);
    yield;
  }
}
