class Dancer {
  boolean live;
  boolean dance;
  boolean choreograph;
  int id;
  int display_mode;
  int move_current = 25;
  float speed = 0.05f;
  float current_frame = 0.00f;
  float move_frame = 0.00f;
  float joint_smooth = 0.25f;
  float timer = 0.00f;
  int delay = 5;
  float distance_current = 0;
  float target_frame = 0.00f;
  float dance_speed = 1;

  int time_active = 0;

  PVector[] joint_temp = new PVector[joint_amount];
  PVector[] joint_live = new PVector[joint_amount];
  PVector[] joint_norm = new PVector[joint_amount];
  PVector[] joint_lerp = new PVector[joint_amount];
  PVector joint_compare = new PVector(0, 0, 0);

  int trail_length = 30;
  int trail_index = 0;
  int trail_amount = 30;
  PVector[][] j_trail = new PVector[trail_length][trail_amount];

  Dancer(int _id) {
    id = _id;
    if (id == 0) live = true;
    for (int i = 0; i < joint_amount; i++) {
      joint_norm[i] = new PVector(0, 0, 0);
      joint_lerp[i] = new PVector(0, 0, 0);
    }
    for (int i = 0; i < trail_length; i++) {
      for (int n = 0; n < trail_amount; n++) {
        j_trail[i][n] = new PVector(joint_lerp[0].x, joint_lerp[0].y, joint_lerp[0].z);
      }
    }
  }

  void draw() {
    if (id == 1) dance = true;
    if ((live && id < dancer_live_no) || !live) {

      normalizeJoints();

      joints(joint_lerp, id);
      bones(joint_lerp, id);
      if (id == 1) trailDraw();

      timeControl();
    } else {
      time_active = 0;
      if (live) {
        for (int j = 0; j < joint_amount; j++) {
          joint_norm[j] = new PVector(0, 0, -1000);
        }
      }
    }
  }

  void normalizeJoints() {
    if (!live) {
      if (dance) {
        float distance_min = 10000;
        for (int f = 0; f < movement_length[move_current]; f++) {
          joint_compare = joint[move_current][f][12];
          distance_current = dist(joint_compare.x, joint_compare.y, joint_compare.z, dancing_hand.x, dancing_hand.y, dancing_hand.z);
          if (distance_current < distance_min) {
            distance_min = distance_current;
            target_frame = f;
          }
        }
        dance_speed = constrain(map(abs(target_frame-current_frame), 3, 300, 1, 5), 1, 5);
        if (target_frame < current_frame+1) {
          current_frame-=dance_speed;
        } else if (target_frame > current_frame-1) {
          current_frame+=dance_speed;
        } else {
          current_frame = target_frame;
        }
      } else {
        current_frame = move_frame;
      }

      for (int j = 0; j < joint_amount; j++) {
        if (current_frame%1 == 0) {
          joint_norm[j] = joint[move_current][int(current_frame)][j];
        } else {
          int prev_frame = floor(current_frame)%movement_length[move_current];
          int next_frame = ceil(current_frame)%movement_length[move_current];
          float balance = prev_frame-current_frame;
          float joint_mid_x = joint[move_current][prev_frame][j].x*(1-balance)+joint[move_current][next_frame][j].x*balance;
          float joint_mid_y = joint[move_current][prev_frame][j].y*(1-balance)+joint[move_current][next_frame][j].y*balance;
          float joint_mid_z = joint[move_current][prev_frame][j].z*(1-balance)+joint[move_current][next_frame][j].z*balance;
          joint_norm[j].x = joint_mid_x;
          joint_norm[j].y = joint_mid_y;
          joint_norm[j].z = joint_mid_z;
        }
        smoothJoints(j);
        trailAssign(j);
      }
      line(dancing_hand.x, dancing_hand.y, dancing_hand.z, joint_lerp[12].x, joint_lerp[12].y, joint_lerp[12].z);
    }

    if (live) {
      ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();
      for (int i = 0; i < skeletonArray.size(); i++) {
        if (id == i) {
          KSkeleton skeleton = (KSkeleton) skeletonArray.get(id);
          if (skeleton.isTracked()) {
            time_active++;
            KJoint[] joint_kinect = skeleton.getJoints();
            for (int j = 0; j < joint_amount; j++) {
              joint_temp[j] = new PVector(joint_kinect[j].getX(), joint_kinect[j].getY(), joint_kinect[j].getZ());
            }
            ///Reassign the joints
            joint_live[0] = joint_temp[3];
            joint_live[1] = joint_temp[2];
            joint_live[2] = joint_temp[20];
            joint_live[3] = joint_temp[1];
            joint_live[4] = joint_temp[0];
            joint_live[5] = joint_temp[4];
            joint_live[6] = joint_temp[8];
            joint_live[7] = joint_temp[12];
            joint_live[8] = joint_temp[16];
            joint_live[9] = joint_temp[5];
            joint_live[10] = joint_temp[9];
            joint_live[11] = joint_temp[6];
            joint_live[12] = joint_temp[10];
            joint_live[13] = joint_temp[7];
            joint_live[14] = joint_temp[11];
            joint_live[15] = joint_temp[21];
            joint_live[16] = joint_temp[23];
            joint_live[17] = joint_temp[22];
            joint_live[18] = joint_temp[24];
            joint_live[19] = joint_temp[13];
            joint_live[20] = joint_temp[17];
            joint_live[21] = joint_temp[14];
            joint_live[22] = joint_temp[18];
            joint_live[23] = joint_temp[15];
            joint_live[24] = joint_temp[19];


            for (int j = 0; j < joint_amount; j++) {
              joint_norm[j].x = map(joint_live[j].x, joint_min.x, joint_max.x, -width/2, width/2);
              joint_norm[j].y = map(joint_live[j].y, joint_min.y, joint_max.y, -height/2, height/2);
              joint_norm[j].z = map(joint_live[j].z, joint_min.z, joint_max.z, -width/2, width/2);
              smoothJoints(j);
              trailAssign(j);
            }
          }
        }
      }
    }
  }

  void findClosest() {
    if (dance) {
      for (int j = 0; j < joint_amount; j++) {
      }
    }
  }


  void smoothJoints(int j) {
    joint_lerp[j].x = lerp(joint_lerp[j].x, joint_norm[j].x, joint_smooth);
    joint_lerp[j].y = lerp(joint_lerp[j].y, joint_norm[j].y, joint_smooth);
    joint_lerp[j].z = lerp(joint_lerp[j].z, joint_norm[j].z, joint_smooth);
  }

  void trailAssign(int j) {
    j_trail[trail_index][j].x = joint_lerp[j].x;
    j_trail[trail_index][j].y = joint_lerp[j].y;
    j_trail[trail_index][j].z = joint_lerp[j].z;
  }

  void trailDraw() {
    for (int n = 0; n < trail_amount; n++) {
      beginShape();
      for (int i = 0; i < trail_length; i++) {
        int trail_pos = (trail_index+i)%trail_length;
        float fade = map(i, 0, trail_length, 0, 1);
        strokeWeight(3*fade);
        stroke(180*fade, 255*fade, 255*fade, 255*fade);
        noFill();
        vertex(j_trail[trail_pos][n].x, j_trail[trail_pos][n].y, j_trail[trail_pos][n].z);
      }
      endShape();
    }
  }

  void timeControl() {
    //speed = map(debug_my, -width/2, width/2, 0.00f, 8);
    speed = 0.8f;
    if (speed > 1) {
      speed = round(speed);
      timer+=speed;
      timer = int(timer);
      joint_smooth = 0.25f;
    } else {
      timer+=speed;
      joint_smooth = map(speed, 0.00f, 1, 0.00f, 0.25f);
    }
    move_frame = constrain((timer-(delay*id))%movement_length[move_current], 0, movement_length[move_current]);
    trail_index = (trail_index+1)%trail_length;
  }
}