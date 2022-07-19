#!/bin/bash

# Start visit data processing
cd /emr/instance-controller/lib/bootstrap-actions/1/app/data-processing/visits-processing/service/dev
sudo make run

# Export mysql data to s3
sudo docker exec ground-level-insights-dev-mysql bash -c '/usr/bin/mysqldump --column-statistics=0 --no-tablespaces -P45071 -u ground-level-insights -p"ground-level-insights" ground-level-insights > /home/visits.sql' 
sudo docker cp ground-level-insights-dev-mysql:/home/visits.sql /home/hadoop/
sudo aws s3 cp /home/hadoop/visits.sql s3://gli-emr-scripts/visits.sql
