#!/bin/bash

CLUSTER_NAME="shoong-eks-cluster1"
REGION="ap-northeast-2"
NODEGROUP_FILE="./shoong-nodegroups.yaml"  # 위에서 보여준 yaml 파일 경로

echo "🚀 EKS 노드그룹 복원 시작 (eksctl) ..."
eksctl create nodegroup \
  --config-file "$NODEGROUP_FILE"

echo "⏳ 노드그룹 Ready 상태 확인 중 ..."
kubectl get nodes -o wide

echo "✅ 모든 노드그룹 생성 완료!"
