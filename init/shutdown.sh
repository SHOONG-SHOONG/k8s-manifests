#!/bin/bash

CLUSTER_NAME="shoong-eks-cluster1"
REGION="ap-northeast-2"

NODEGROUPS=(
  "kafka-ng"
  "streaming-infra-ng"
  "was-ng"
)

for NG in "${NODEGROUPS[@]}"; do
  echo "🔻 Deleting node group: $NG"
  eksctl delete nodegroup "$NG" \
    --cluster "$CLUSTER_NAME"
done

echo "✅ All node groups deletion initiated."

echo "🔍 $REGION 리전에서 실행 중(Running)인 인스턴스 조회 중..."
REGION="ap-northeast-2"

INSTANCE_IDS=$(aws ec2 describe-instances \
  --region "$REGION" \
  --filters "Name=instance-state-name,Values=running" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

if [ -z "$INSTANCE_IDS" ]; then
  echo "✅ 중지할 인스턴스가 없습니다."
  exit 0
fi

echo "🛑 중지 대상 인스턴스:"
echo "$INSTANCE_IDS"
echo ""

for INSTANCE_ID in $INSTANCE_IDS; do
  echo "⏳ 중지 요청: $INSTANCE_ID"
  
  aws ec2 stop-instances \
    --region "$REGION" \
    --instance-ids "$INSTANCE_ID" \
    --output text
  
  if [ $? -eq 0 ]; then
    echo "✅ 중지 요청 성공: $INSTANCE_ID"
  else
    echo "❌ 중지 실패 또는 권한 문제: $INSTANCE_ID"
  fi

  echo ""
done

echo "🏁 모든 중지 요청 완료"