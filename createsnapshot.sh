#!/bin/bash
export EC2_PRIVATE_KEY=[Your EC2 private key]
export EC2_CERT=[Your EC2 cert]
export AWS_ACCESS_KEY=[Your AWS access key]
export AWS_SECRET_KEY=[Your AWS secret key]
export JAVA_HOME=/usr/lib/jvm/jre
export EC2_HOME=/opt/aws/apitools/ec2
INSTANCE_ID=`/usr/bin/curl http://169.254.169.254/latest/meta-data/instance-id`
echo instance id is $INSTANCE_ID
VOLUME_ID=`/opt/aws/bin/ec2-describe-volumes --filter "attachment.instance-id=$INSTANCE_ID" | grep VOLUME | awk '{print $2}'`
echo volume id is $VOLUME_ID
/sbin/service mysqld stop
SNAP_ID=`/opt/aws/bin/ec2-create-snapshot $VOLUME_ID -d "josh.sg weekly backup" | awk '{ print $2 }'`
echo snap id is $SNAP_ID
STATUS=pending
while [ "$STATUS" != "completed" ]
do
        echo volume $VOLUME_ID, awaiting snap complete...
        sleep 3
        STATUS=`/opt/aws/bin/ec2-describe-snapshots $SNAP_ID | grep SNAPSHOT | awk '{ print $4 }'`
done                                                                            
/sbin/service mysqld start
               
