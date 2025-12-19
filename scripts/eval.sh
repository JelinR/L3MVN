#!/usr/bin/env bash
# Copyright [2023] Boston Dynamics AI Institute, Inc.

# Ensure you have 'export VLFM_PYTHON=<PATH_TO_PYTHON>' in your .bashrc, where
# <PATH_TO_PYTHON> is the path to the python executable for your conda env
# (e.g., PATH_TO_PYTHON=`conda activate <env_name> && which python`)


export PERSONAL_PYTHON='/mnt/anaconda3/envs/personal_l3mvn_og/bin/python'

easy_data_path="data/datasets/PersONAL/active_new/val/l3mvn_baseline/easy/easy.json.gz"
medium_data_path="data/datasets/PersONAL/active_new/val/l3mvn_baseline/medium/medium.json.gz"
hard_data_path="data/datasets/PersONAL/active_new/val/l3mvn_baseline/hard/hard.json.gz"

session_name=eval_l3mvn

#Ensure there are no running sessions with the same name
if tmux has-session -t "$session_name" 2>/dev/null; then
    echo "❌ tmux session '$session_name' already exists"
    exit 1
fi

# Create a detached tmux session
tmux new-session -d -s ${session_name}

# Split the window vertically
# tmux split-window -v -t ${session_name}:
# tmux split-window -h
# tmux split-window -h
# tmux select-layout even-horizontal


# Run commands in each pane
tmux send-keys -t ${session_name}:0.0 \
    "${PERSONAL_PYTHON} -m main_llm_zeroshot_personal \
        --split val \
        --eval 1 \
        --auto_gpu_config 0 \
        -n 1 \
        --num_eval_episodes 2000 \
        --load pretrained_models/llm_model.pt \
        --use_gtsem 0 \
        --task_config tasks/objectnav_personal.yaml \
        --log_dir logs/easy
        " C-m

# tmux send-keys -t ${session_name}:0.1 \
#     "${PERSONAL_PYTHON} -m main_llm_zeroshot_personal \
#         --split val \
#         --eval 1 \
#         --auto_gpu_config 0 \
#         -n 1 \
#         --num_eval_episodes 2000 \
#         --load pretrained_models/llm_model.pt \
#         --use_gtsem 0 \
#         --task_config tasks/objectnav_personal_medium.yaml \
#         --log_dir logs/medium
#         " C-m

# tmux send-keys -t ${session_name}:0.2 \
#     "${PERSONAL_PYTHON} -m main_llm_zeroshot_personal \
#         --split val \
#         --eval 1 \
#         --auto_gpu_config 0 \
#         -n 1 \
#         --num_eval_episodes 2000 \
#         --load pretrained_models/llm_model.pt \
#         --use_gtsem 0 \
#         --task_config tasks/objectnav_personal_hard.yaml \
#         --log_dir logs/hard
#         " C-m


# Attach to the tmux session to view the windows
echo "Created tmux session '${session_name}'"
echo "Run the following to monitor all the server commands:"
echo "tmux attach-session -t ${session_name}"
