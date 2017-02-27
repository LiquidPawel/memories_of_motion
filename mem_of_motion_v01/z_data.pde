int longest_movement = 0;
int[] movement_length = new int[move_no];

PVector[][][] joint;
PVector joint_min, joint_max;

String[] read_data = new String[3];
String[] variable = new String[joint_amount];

Table[] movement_read = new Table[move_no];

void assignNames() {
  //List of variables
  variable[0] = "Head";
  variable[1] = "Neck";
  variable[2] = "SpineShoulder";
  variable[3] = "SpineMid";
  variable[4] = "SpineBase";
  variable[5] = "ShoulderLeft";
  variable[6] = "ShoulderRight";
  variable[7] = "HipLeft";
  variable[8] = "HipRight";
  variable[9] = "ElbowLeft";
  variable[10] = "ElbowRight";
  variable[11] = "WristLeft";
  variable[12] = "WristRight";
  variable[13] = "HandLeft";
  variable[14] = "HandRight";
  variable[15] = "HandTipLeft";
  variable[16] = "HandTipRight";
  variable[17] = "ThumbLeft";
  variable[18] = "ThumbRight";
  variable[19] = "KneeLeft";
  variable[20] = "KneeRight";
  variable[21] = "AnkleLeft";
  variable[22] = "AnkleRight";
  variable[23] = "FootLeft";
  variable[24] = "FootRight";
}

//Only this required in setup
void read_data() {
  assignNames();
  joint_min = new PVector(10000, 10000, 10000);
  joint_max = new PVector(-10000, -10000, -10000);

  //Check length of 3d movements
  for (int no = 0; no < move_no; no++) {
    print("Reading 3D movement "+no+" ...");
    movement_read[no] = loadTable("3d_rec_"+(no+1)+".csv", "header");
    print("Done!");
    movement_length[no] = movement_read[no].getColumnCount()-2;
    println("  Movement length: "+movement_length[no]);
    if (longest_movement < movement_length[no]) {
      longest_movement = movement_length[no];
    }
  }

  println("---------------------");
  println("3D movements loaded");
  println("");

  joint = new PVector[move_no][longest_movement][joint_amount];
  for (int no = 0; no < move_no; no++) {
    print("Assigning positions...");
    for (int n = 0; n < movement_length[no]; n++) {
      for (int i = 0; i < joint_amount; i++) {
        read_data = split(movement_read[no].getString(i, n+1), '|');
        PVector temp_vector = new PVector (float(read_data[0]), float(read_data[1]), float(read_data[2]));
        //min/max x
        if (temp_vector.x < joint_min.x) {  
          joint_min.x = temp_vector.x;
        } else if (temp_vector.x > joint_max.x) {
          joint_max.x = temp_vector.x;
        }
        //min/max y
        if (temp_vector.y < joint_min.y) {  
          joint_min.y = temp_vector.y;
        } else if (temp_vector.y > joint_max.y) {
          joint_max.y = temp_vector.y;
        }
        //min/max z
        if (temp_vector.z < joint_min.z && temp_vector.z != 0) {  
          joint_min.z = temp_vector.z;
        } else if (temp_vector.z > joint_max.z) {
          joint_max.z = temp_vector.z;
        }
        joint[no][n][i] = new PVector(map(temp_vector.x, joint_min.x, joint_max.x, -width/2, width/2), 
          map(temp_vector.y, joint_min.y, joint_max.y, -height/2, height/2), 
          map(temp_vector.z, joint_min.z, joint_max.z, -width/2, width/2));
      }
    }
    println(" Done! Movement "+no+" is "+movement_length[no]+" frames long and ready to play!");
    println("------------------------------------------------------------------");
  }
  println("All "+move_no+" 3D movements loaded!");
  println("");
  println("Min/Max values:");
  println("");
  println("3D, min x = "+joint_min.x+", max x = "+joint_max.x);
  println("3D, min y = "+joint_min.y+", max y = "+joint_max.y);
  println("3D, min z = "+joint_min.z+", max z = "+joint_max.z);
  println("------------------------------------------------------------------");
}