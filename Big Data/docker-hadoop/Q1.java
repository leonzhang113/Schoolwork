//import java.io.BufferedReader;
//import java.io.File;
//import java.io.FileReader;
import java.io.IOException;
//import java.net.URI;
//import java.util.ArrayList;
//import java.util.Collections;
//import java.util.Comparator;
//import java.util.HashMap;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
//import org.apache.hadoop.mapreduce.Mapper.Context;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
//import org.apache.hadoop.mapreduce.lib.input.MultipleInputs;
//import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

public class Q1 {

    public static class Map
            extends Mapper<LongWritable, Text, Text, IntWritable>{

        private final static IntWritable one = new IntWritable(1);
        private Text word = new Text(); // type of output key

        //emits each word and a value of one
        public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
            String[] mydata = value.toString().split("[^a-zA-Z]+");
            for (String data : mydata) {
                if (!data.trim().isEmpty()) {
                    word.set(data.toLowerCase());
                    context.write(word, one);
                }
            }
        }
    }

    public static class Reduce
            extends Reducer<Text,IntWritable,Text,IntWritable> {

        private IntWritable result = new IntWritable();

        //sums all values of each word key
        public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
            int sum = 0;
            for (IntWritable val : values) {
                sum += val.get();
            }
            result.set(sum);
            context.write(key, result);
        }
    }

    public static class TargetMap extends Mapper<LongWritable, Text, Text, IntWritable> {
        private final static IntWritable one = new IntWritable(1);
        private Text word = new Text(); // type of output key

        //checks if each word is 'whale', 'sea', or 'ship' before setting key value pair, uses same reduce as part A
        public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
            String[] mydata = value.toString().split("[^a-zA-Z]+");
            for (String data : mydata) {
                if(data.equalsIgnoreCase("whale") || data.equalsIgnoreCase("sea") ||  data.equalsIgnoreCase("ship")) {
                    word.set(data);
                    context.write(word, one);
                }
            }
        }
    }

    public static class PatternMap extends Mapper<LongWritable, Text, Text, IntWritable> {
        private final static IntWritable one = new IntWritable(1);
        private Text word = new Text(); // type of output key

        //key is made up the length of the word and its first char, uses same reduce as A
        public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
            String[] mydata = value.toString().split("[^a-zA-Z]+");
            for (String data : mydata) {
                if(!data.trim().isEmpty()){
                    String pattern = data.length() + "," + data.toLowerCase().charAt(0);
                    word.set(pattern);
                    context.write(word, one);
                }
            }
        }
    }

    // Driver program
    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        String[] otherArgs = new GenericOptionsParser(conf, args).getRemainingArgs();

        if (otherArgs.length != 3) {
            System.err.println("Usage: WordCount <in> <out> <part>");
            System.err.println("part: A (WordCount), B (TargetWords), C(Pattern)");
            System.exit(2);
        }

        String part = otherArgs[2];

        Job job = null;

        if (part.equalsIgnoreCase("A")) {
            job = Job.getInstance(conf, "WordCount");
            job.setJarByClass(Q1.class);
            job.setMapperClass(Map.class);
            job.setReducerClass(Reduce.class);
            job.setOutputKeyClass(Text.class);
            job.setOutputValueClass(IntWritable.class);
            FileInputFormat.addInputPath(job, new Path(otherArgs[0]));
            FileOutputFormat.setOutputPath(job, new Path(otherArgs[1] + "-A"));
        }
        else if (part.equalsIgnoreCase("B")) {
            job = Job.getInstance(conf, "TargetWords");
            job.setJarByClass(Q1.class);
            job.setMapperClass(TargetMap.class);
            job.setReducerClass(Reduce.class);
            job.setOutputKeyClass(Text.class);
            job.setOutputValueClass(IntWritable.class);
            FileInputFormat.addInputPath(job, new Path(otherArgs[0]));
            FileOutputFormat.setOutputPath(job, new Path(otherArgs[1] + "-B"));
        }
        else if (part.equalsIgnoreCase("C")) {
            job = Job.getInstance(conf, "Pattern");
            job.setJarByClass(Q1.class);
            job.setMapperClass(PatternMap.class);
            job.setReducerClass(Reduce.class);
            job.setOutputKeyClass(Text.class);
            job.setOutputValueClass(IntWritable.class);
            FileInputFormat.addInputPath(job, new Path(otherArgs[0]));
            FileOutputFormat.setOutputPath(job, new Path(otherArgs[1] + "-C"));
        } else {
            System.exit(2);
        }

        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}