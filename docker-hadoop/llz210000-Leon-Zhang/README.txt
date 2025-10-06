README

Question 1:
Copy Q1Analysis.jar and q1_dataset.txt into directory with Hadoop

docker cp q1_dataset.txt namenode:/tmp/words.txt
docker exec -it namenode hdfs dfs -mkdir -p /input
docker exec -it namenode hdfs dfs -put -f /tmp/words.txt /input/words.txt
docker cp Q1Analysis.jar resourcemanager:/tmp/
docker exec -t resourcemanager hadoop jar /tmp/Q1Analysis.jar /input /Q1output A
docker exec -t resourcemanager hadoop jar /tmp/Q1Analysis.jar /input /Q1output B
docker exec -t resourcemanager hadoop jar /tmp/Q1Analysis.jar /input /Q1output C
docker exec -it namenode hdfs dfs -get /Q1output-A/part-r-00000 /tmp/Q1OutputA
docker cp namenode:/tmp/Q1OutputA ./Q1OutputA
docker exec -it namenode hdfs dfs -get /Q1output-B/part-r-00000 /tmp/Q1OutputB
docker cp namenode:/tmp/Q1OutputB ./Q1OutputB
docker exec -it namenode hdfs dfs -get /Q1output-C/part-r-00000 /tmp/Q1OutputC
docker cp namenode:/tmp/Q1OutputC ./Q1OutputC

Question 2:
Copy Q2Analysis.jar and q2_dataset.txt into directory with Hadoop
Docker exec -it namenode hdfs ifs -rm -r -f /input
docker cp q2_dataset.txt namenode:/tmp/words2.txt
docker exec -it namenode hdfs dfs -mkdir -p /input
docker exec -it namenode hdfs dfs -put -f /tmp/words2.txt /input/words2.txt
docker cp Q2Analysis.jar resourcemanager:/tmp/
docker exec -t resourcemanager hadoop jar /tmp/Q2Analysis.jar /input /Q2output A
docker exec -t resourcemanager hadoop jar /tmp/Q2Analysis.jar /input /Q2output B
docker exec -it namenode hdfs dfs -get /Q2output-A/part-r-00000 /tmp/Q2OutputA
docker cp namenode:/tmp/Q2OutputA ./Q2OutputA
docker exec -it namenode hdfs dfs -get /Q2output-B/part-r-00000 /tmp/Q2OutputB
docker cp namenode:/tmp/Q2OutputB ./Q2OutputB
