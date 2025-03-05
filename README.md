The current default main scene is start_page.tscn. Pressing the start button, 
the scene will switch to mediapipe.tscn

mediapipe.tscn has the camera with mediapipe landmarks.
This scene includes two script which are 'mediapipe_parent.gd'
and 'mediapipe.gd'. The 'mediapipe_parent.gd' is the parent 
script and 'mediapipe.gd' is the child script which can
inherit functions in the parent script.

All functions about mediapipe model can be found in 
'mediapipe_parent.gd'. In 'mediapipe.gd', you can read the 
comments and find places to obtain landmarks data, open camera
and close camera.