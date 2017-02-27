int joint_amount = 25;

int move_no = 28;

int dancer_live_no = 1;
int dancer_no = dancer_live_no+1;

int frame_closest = 0;
PVector dancing_hand = new PVector(0, 0, 0);

PVector[] joint_closest = new PVector[joint_amount];
PVector[] joint_closest_smooth = new PVector[joint_amount];

Button[] b_move = new Button[move_no];
Dancer[] dancer = new Dancer[dancer_no];

void setup() {
  size(displayWidth, displayHeight, P3D);
  frameRate(60);
  colorMode(HSB);
  read_data();
  for (int i = 0; i < move_no; i++) {
    float ypos = map(i, 0, move_no, 120, height-50);
    b_move[i] = new Button(str(i+1), 12, 40, ypos, 30, 30);
  }
  for (int i = 0; i < dancer_no; i++) {
    dancer[i] = new Dancer(i);
  }


  for (int j = 0; j < joint_amount; j++) {
    joint_closest[j] = new PVector(0, 0, 0);
    joint_closest_smooth[j] = new PVector(0, 0, 0);
  }

  kinectSetup();
}


void draw() {
  background(0);
  ArrayList<KSkeleton> skeletonArray_ref =  kinect.getSkeleton3d();
  dancer_live_no = skeletonArray_ref.size();
  movementSelection(); 
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateZ(radians(180));
  rotateY(radians(180+debug_mx));
  for (int i = 0; i < dancer_no; i++) {
    dancer[i].draw();
  }


  for (int j = 0; j < joint_amount; j++) {
    for (int m = 1; m < dancer_no; m++) {
      if (dancer_live_no > 0) {

        stroke(200, 200, 200, 200);
        strokeWeight(1);
        //line(dancer[0].joint_lerp[j].x, dancer[0].joint_lerp[j].y, dancer[0].joint_lerp[j].z, 
        //  dancer[m].joint_lerp[j].x, dancer[m].joint_lerp[j].y, dancer[m].joint_lerp[j].z);
      }
    }
  }
  dancing_hand.x = lerp(dancing_hand.x, dancer[0].joint_lerp[12].x, dancer[0].joint_smooth);
  dancing_hand.y = lerp(dancing_hand.y, dancer[0].joint_lerp[12].y, dancer[0].joint_smooth);
  dancing_hand.z = lerp(dancing_hand.z, dancer[0].joint_lerp[12].z, dancer[0].joint_smooth);
  popMatrix();



  debug();
}

void movementSelection() {
  //dancer[1].dancing_hand = dancer[0].joint_norm[7];
  for (int j = 0; j < move_no; j++) {
    if (b_move[j].clicked) {
      for (int d = 0; d < dancer_no; d++) {
        dancer[d].timer = 0;
        dancer[d].move_frame = 0;
        dancer[d].move_current = j;//(j+d)%move_no;
        for (int i = 0; i < dancer[d].trail_length; i++) {
          dancer[d].j_trail[i][0].x = dancer[d].joint_lerp[0].x;
          dancer[d].j_trail[i][0].y = dancer[d].joint_lerp[0].y;
          dancer[d].j_trail[i][0].z = dancer[d].joint_lerp[0].z;
        }
      }
    }
  }
}