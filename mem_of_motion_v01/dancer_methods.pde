void joints(PVector[] _joint, int _id) {
  //draw joints
  float fade = map(_id, 6, dancer_no, 1, 0.05);
  //stroke(190*fade, 255*fade, 255*fade, 255*fade);

  //if(_id < 6)strokeWeight(6*fade);

  if (_id > 0) {
    strokeWeight(16);
    stroke(140);
  } else {
    stroke(200, 255, 255);
    strokeWeight(16);
  }

  for (int j = 0; j < joint_amount; j++) {
    //if (_id < 5) text("X = "+_joint[j].x+", Y = "+_joint[j].y+", Z = "+_joint[j].z, _joint[j].x, _joint[j].y, _joint[j].z);
    point(_joint[j].x, _joint[j].y, _joint[j].z);
  }
}


void bones(PVector[] _joint, int _id) {
  //draw "bones"
  float fade = map(_id, 0, dancer_no, 1, 0.1);
  stroke(255*fade, 255, 255);
  strokeWeight(8);

  for (int j = 0; j < 4; j++) {
    //Head - Neck
    line(_joint[j].x, _joint[j].y, _joint[j].z, 
      _joint[j+1].x, _joint[j+1].y, _joint[j+1].z);
  }
  for (int j = 0; j < 2; j++) {
    //SpineShoulder - Shoulder
    line(_joint[2].x, _joint[2].y, _joint[2].z, 
      _joint[5+j].x, _joint[5+j].y, _joint[5+j].z);
  }
  for (int j = 0; j < 2; j++) {
    //Shoulder - Elbow
    line(_joint[5+j].x, _joint[5+j].y, _joint[5+j].z, 
      _joint[9+j].x, _joint[9+j].y, _joint[9+j].z);
  }
  for (int j = 0; j < 6; j++) {
    //Elbow - HandTip
    line(_joint[9+j].x, _joint[9+j].y, _joint[9+j].z, 
      _joint[9+j+2].x, _joint[9+j+2].y, _joint[9+j+2].z);
  }
  for (int j = 0; j < 2; j++) {
    //Wrist - Thumb
    line(_joint[13+j].x, _joint[13+j].y, _joint[13+j].z, 
      _joint[17+j].x, _joint[17+j].y, _joint[17+j].z);
  }
  for (int j = 0; j < 2; j++) {
    //SpineBase - Hips
    line(_joint[4].x, _joint[4].y, _joint[4].z, 
      _joint[7+j].x, _joint[7+j].y, _joint[7+j].z);
  }
  for (int j = 0; j < 2; j++) {
    //Hips - Knees
    line(_joint[7+j].x, _joint[7+j].y, _joint[7+j].z, 
      _joint[19+j].x, _joint[19+j].y, _joint[19+j].z);
  }
  for (int j = 0; j < 4; j++) {
    //Knees - Ankles
    line(_joint[19+j].x, _joint[19+j].y, _joint[19+j].z, 
      _joint[21+j].x, _joint[21+j].y, _joint[21+j].z);
  }
}