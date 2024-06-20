{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.bash
    pkgs.tmux
    pkgs.coreutils
    pkgs.micromamba
    pkgs.python3
  ];

  shellHook = ''
    eval "$(micromamba shell hook --shell bash)"

    # If running for the first time
    if [ ! -d ~/micromamba ]; then
      echo "First time installation!"
      echo "Make sure to press 'Enter' for any questions that come up"
      sleep 3
      # Create a ros-humble desktop environment
      micromamba create -n ros_env -c conda-forge -c robostack-staging ros-humble-desktop ros-humble-gazebo-ros ros-humble-gazebo-ros-pkgs -c compilers cmake pkg-config make ninja colcon-common-extensions catkin_tools rosdep
    fi

    # Activate the environment
    micromamba activate ros_env

    echo "Conda environment 'ros_env' with ROS Humble Desktop is ready to use."
    echo "try running gazebo (~60 fps) or rviz2 (~30 fps) :)"
  '';
}
