#!/bin/bash
#SBATCH --job-name=md_prod
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --time=48:00:00

# 시간 초과·취소로 강제 종료될 때도 알림
trap '$HOME/bin/mdnotify send "⚠️ MD 중단: $SLURM_JOB_NAME" "Slurm $SLURM_JOB_ID 이(가) 시간 초과 또는 취소로 종료됨 ($PWD)" high' TERM

# 정상 종료/실패 시 성능(ns/day)과 로그 요약을 함께 알림
$HOME/bin/mdnotify run --name "$SLURM_JOB_NAME" --log md.log -- \
    gmx mdrun -deffnm md -nb gpu
