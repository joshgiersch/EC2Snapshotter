#!/bin/bash
export EC2_PRIVATE_KEY=[Your EC2 private key] 
export EC2_CERT=[Your EC2 certificate]       
export AWS_ACCESS_KEY=[Your AWS access key]
export AWS_SECRET_KEY=[Your AWS secret key]
export JAVA_HOME=/usr/lib/jvm/jre                                               
export EC2_HOME=/opt/aws/apitools/ec2    

INSTANCE_ID=`/usr/bin/curl http://169.254.169.254/latest/meta-data/instance-id`
echo instance id is $INSTANCE_ID
VOLUME_ID=`/opt/aws/bin/ec2-describe-volumes --filter "attachment.instance-id=$INSTANCE_ID" | grep VOLUME | awk '{print $2}'`
echo Volume ID is $VOLUME_ID

SNAPSHOT_ID=`/opt/aws/bin/ec2-describe-snapshots --filter volume-id=$VOLUME_ID --filter description="josh.sg weekly backup" | sort -r -k 5 | sed 1,2d | cut -f 2`
echo Snapshot ID to delete is $SNAPSHOT_ID

/opt/aws/bin/ec2-delete-snapshot $SNAPSHOT_ID
echo Snapshot deleted
