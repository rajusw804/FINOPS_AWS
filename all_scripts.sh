# Get the list of stopped instance IDs
stopped_instances=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=stopped" --query "Reservations[*].Instances[*].InstanceId" --output text)

# Terminate each stopped instance
if [ -n "$stopped_instances" ]; then
  aws ec2 terminate-instances --instance-ids $stopped_instances
  echo "Terminated instances: $stopped_instances"
else
  echo "No stopped instances found."
fi

------------------------
# Get the load balancer names or ARNs
load_balancers=$(aws elbv2 describe-load-balancers --query "LoadBalancers[*].LoadBalancerArn" --output text)

# Delete each load balancer
for lb in $load_balancers; do
  aws elbv2 delete-load-balancer --load-balancer-arn $lb
  echo "Deleted load balancer ARN: $lb"
done

------------------------
# Get the list of available volume IDs
available_volumes=$(aws ec2 describe-volumes --filters "Name=status,Values=available" --query "Volumes[*].VolumeId" --output text)

# Delete each available volume
for vol in $available_volumes; do
  aws ec2 delete-volume --volume-id $vol
  echo "Deleted volume ID: $vol"
done
------------------------
#!/bin/bash

# Date 30 days ago in the format used by AWS
date_30_days_ago=$(date -d '-30 days' +'%Y-%m-%dT%H:%M:%S')

# Delete available EBS volumes older than 30 days
available_volumes=$(aws ec2 describe-volumes --filters "Name=status,Values=available" --query "Volumes[?CreateTime<=\`${date_30_days_ago}\`].VolumeId" --output text)

for vol in $available_volumes; do
  aws ec2 delete-volume --volume-id $vol
  echo "Deleted EBS Volume ID: $vol"
done

# Delete EBS snapshots older than 30 days
old_snapshots=$(aws ec2 describe-snapshots --owner-ids self --query "Snapshots[?StartTime<=\`${date_30_days_ago}\`].SnapshotId" --output text)

for snap in $old_snapshots; do
  aws ec2 delete-snapshot --snapshot-id $snap
  echo "Deleted Snapshot ID: $snap"
done

# Deregister AMIs older than 30 days
old_amis=$(aws ec2 describe-images --owners self --query "Images[?CreationDate<=\`${date_30_days_ago}\`].ImageId" --output text)

for ami in $old_amis; do
  aws ec2 deregister-image --image-id $ami
  echo "Deregistered AMI ID: $ami"
done
------------------------
#!/bin/bash

# Date format for 30 days ago, compatible with AWS RDS snapshot creation timestamps
date_30_days_ago=$(date -d '-30 days' +'%Y-%m-%dT%H:%M:%S')

# Find RDS snapshots older than 30 days
old_snapshots=$(aws rds describe-db-snapshots --snapshot-type manual --query "DBSnapshots[?SnapshotCreateTime<=\`${date_30_days_ago}\`].DBSnapshotIdentifier" --output text)

# Delete each snapshot older than 30 days
for snapshot in $old_snapshots; do
  aws rds delete-db-snapshot --db-snapshot-identifier $snapshot
  echo "Deleted RDS Snapshot ID: $snapshot"
done
