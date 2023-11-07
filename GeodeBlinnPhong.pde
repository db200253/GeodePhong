PShader lightShader;
PShape geode;

float t = 200, o = t*(1.0+sqrt(5.0))/2.0;
float rayon = 750;
int niveau = 5;
float camX = 0, camY = 0, camZ = 0;
float theta = 0;
float phi = 0;
PVector[] ico = {
  new PVector(-t, 0, o),
  new PVector(-o, t, 0),
  new PVector(0, o, t),
  
  new PVector(-t, 0, -o),
  new PVector(o, t, 0),
  new PVector(0, o, -t),
  
  new PVector(t, 0, -o),
  new PVector(o, -t, 0),
  new PVector(0, -o, t),
  
  new PVector(t, 0, o),
  new PVector(-o, -t, 0),
  new PVector(0, -o, -t),
};

PVector[] lightPos = { 
  new PVector(-201, -201, -201),
  new PVector(-201, 201, 201),
  new PVector(-201, 201, -201),
  new PVector(201, -201, 201),
  new PVector(201, -201, -201),
  new PVector(201, 201, 201),
  new PVector(201, 201, -201),
};

PVector[] lightColor = {
  new PVector(0, 0, 255),
  new PVector(0, 255, 255),
  new PVector(255, 255, 0),
  new PVector(255, 0, 0),
  new PVector(0,255,0),
  new PVector(255, 0, 255),
  new PVector(255, 165, 0)
};

PShape creerGeode() {
  PShape geode = createShape();
  
  geode.beginShape();
    recTriangle(geode, ico[0], ico[1], ico[2], niveau);
    recTriangle(geode, ico[0], ico[1], ico[10], niveau);
    recTriangle(geode, ico[0], ico[2], ico[9], niveau);
    recTriangle(geode, ico[0], ico[9], ico[8], niveau); 
    recTriangle(geode, ico[0], ico[10], ico[8], niveau); 
    recTriangle(geode, ico[1], ico[2], ico[5], niveau); 
    recTriangle(geode, ico[1], ico[3], ico[5], niveau); 
    recTriangle(geode, ico[1], ico[3], ico[10], niveau); 
    recTriangle(geode, ico[2], ico[4], ico[5], niveau); 
    recTriangle(geode, ico[2], ico[4], ico[9], niveau);
    recTriangle(geode, ico[3], ico[5], ico[6], niveau);
    recTriangle(geode, ico[3], ico[6], ico[11], niveau);
    recTriangle(geode, ico[3], ico[11], ico[10], niveau); 
    recTriangle(geode, ico[4], ico[5], ico[6], niveau); 
    recTriangle(geode, ico[4], ico[6], ico[7], niveau);
    recTriangle(geode, ico[4], ico[7], ico[9], niveau);
    recTriangle(geode, ico[6], ico[7], ico[11], niveau);
    recTriangle(geode, ico[7], ico[8], ico[11], niveau); 
    recTriangle(geode, ico[7], ico[9], ico[8], niveau);
    recTriangle(geode, ico[8], ico[10], ico[11], niveau); 
  geode.endShape();
  
  return geode;
}

void setup() {
  size(1000, 1000, P3D);
  geode = creerGeode();
  //lightShader = loadShader("Lambert1DiffuseFrag.glsl", "Lambert1DiffuseVert4.glsl");
  lightShader = loadShader("FragShader.glsl", "VertexShader.glsl");
}

void draw() {
  background(0);
  shader(lightShader);
  ambientLight(10, 10, 10);
  
  for(int i=0; i<lightPos.length; i++) {
    lightSpecular(lightColor[i].x, lightColor[i].y, lightColor[i].z);
    pointLight(lightColor[i].x, lightColor[i].y, lightColor[i].z, 
               lightPos[i].x, lightPos[i].y, lightPos[i].z);
  }   
  
  for(int i=0; i<lightPos.length; i++) {
    pushMatrix();
        noStroke();
        emissive(lightColor[i].x, lightColor[i].y, lightColor[i].z);
        translate(lightPos[i].x, lightPos[i].y, lightPos[i].z);
        box(10, 10, 10);
    popMatrix();
  }

  bougerCamera();
  camera(
    camX, -camY, camZ,
    0, 0, 0,
    0, 1, 0);
  shape(geode);
}

void recTriangle(PShape geode, PVector x, PVector y, PVector z, int n) {
  if (n > 1) {
    PVector m1 = new PVector((x.x + y.x) / 2.0, (x.y + y.y) / 2.0, (x.z + y.z) / 2.0);
    PVector m2 = new PVector((y.x + z.x) / 2.0, (y.y + z.y) / 2.0, (y.z + z.z) / 2.0);
    PVector m3 = new PVector((x.x + z.x) / 2.0, (x.y + z.y) / 2.0, (x.z + z.z) / 2.0);

    recTriangle(geode, x, m1, m3, n - 1);
    recTriangle(geode, m1, y, m2, n - 1);
    recTriangle(geode, m1, m2, m3, n - 1);
    recTriangle(geode, m3, m2, z, n - 1);
  } else {
    
    PVector xi = x.copy().normalize();
    PVector yi = y.copy().normalize();
    PVector zi = z.copy().normalize();
    
    geode.beginShape(TRIANGLE);
      geode.noStroke();
      geode.fill(color(255));
      geode.normal(xi.x, xi.y, xi.z);
      geode.shininess(25);
      geode.vertex((xi.x)*t, (xi.y)*t, (xi.z)*t);
      geode.fill(color(255));
      geode.normal(yi.x, yi.y, yi.z);
      geode.shininess(25);
      geode.vertex((yi.x)*t, (yi.y)*t, (yi.z)*t);
      geode.fill(color(255));
      geode.normal(zi.x, zi.y, zi.z);
      geode.shininess(25);
      geode.vertex((zi.x)*t, (zi.y)*t, (zi.z)*t);
    geode.endShape();
  }
}

void bougerCamera() {
  camX = rayon * cos(phi) * sin(theta);
  camY = rayon * sin(phi);
  camZ = rayon * cos(phi) * cos(theta);

  theta += 0.025;
  phi = 0.01;
}
