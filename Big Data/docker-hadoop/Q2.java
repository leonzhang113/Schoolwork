//import java.io.BufferedReader;
//import java.io.File;
//import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
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
import org.apache.hadoop.util.LineReader;

public class Q2 {

    public static class IndexMap
            extends Mapper<LongWritable, Text, Text, IntWritable>{

        private final static IntWritable one = new IntWritable(1);
        private Text word = new Text(); // type of output key
        private IntWritable line = new IntWritable();

        //Looks at every line, and emits <word, linenumber> for each word in the line
        public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
            String[] mydata = value.toString().split(",");
            int lineNumber = Integer.parseInt(mydata[0]);
            for (int i = 1; i < mydata.length; i++) {
                String data = mydata[i];
                word.set(data);
                line.set(lineNumber);
                context.write(word, line);
            }
        }
    }

    public static class Reduce
            extends Reducer<Text,IntWritable,Text,Iterable<Integer>> {

        //Emits the word and the list of line numbers it appears on
        public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
            ArrayList<Integer> list = new ArrayList<>();
            for (IntWritable val : values) {
                list.add(val.get());
            }
            context.write(key, list);
        }
    }

    public static class Combiner
            extends Reducer<Text,IntWritable,Text,IntWritable> {

        private IntWritable result = new IntWritable();

        //Sums the total number of times each word is seen
        public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
            int sum = 0;
            for(IntWritable val : values){
                sum ++;
            }
            result.set(sum);
            context.write(key, result);
        }

    }

    public static class MaxOccurrenceReduce
            extends Reducer<Text,IntWritable,Text,IntWritable> {
        private int MaxOccurrence = 0;
        private HashMap<Integer, ArrayList<String>> occurrences = new HashMap<>();

        //Hashmap stores every number of times every word has been seen as keys. The values is a list of words that have been seen that n number
        //of times. MaxOccurrence is a global variable so we dont have to iterate later through the map to find the highest amount.
        public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
            for(IntWritable val : values) {
                occurrences.computeIfAbsent(val.get(), k -> new ArrayList<>()).add(key.toString());
                if (val.get() > MaxOccurrence) {
                    MaxOccurrence = val.get();
                }
            }
        }

        //Cleanup function emits all the words that have the highest number of occurrences
        @Override
        public void cleanup(Context context) throws IOException, InterruptedException {
            for(String s : occurrences.get(MaxOccurrence)){
                context.write(new Text(s), new IntWritable(MaxOccurrence));
            }
        }

    }

    // Driver program
    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        String[] otherArgs = new GenericOptionsParser(conf, args).getRemainingArgs();

        if (otherArgs.length != 3) {
            System.err.println("Usage: WordCount <in> <out> <part>");
            System.err.println("part: A (InvertIndexConstruction), B (MaximumOccurrenceWords)");
            System.exit(2);
        }

        String part = otherArgs[2];

        Job job = null;

        if (part.equalsIgnoreCase("A")) {
            job = Job.getInstance(conf, "InvertIndexConstruction");
            job.setJarByClass(Q2.class);
            job.setMapperClass(IndexMap.class);
            job.setReducerClass(Reduce.class);
            job.setOutputKeyClass(Text.class);
            job.setOutputValueClass(IntWritable.class);
            FileInputFormat.addInputPath(job, new Path(otherArgs[0]));
            FileOutputFormat.setOutputPath(job, new Path(otherArgs[1] + "-A"));
        }
        else if (part.equalsIgnoreCase("B")) {
            job = Job.getInstance(conf, "MaximumOccurrenceWords");
            job.setJarByClass(Q2.class);
            job.setMapperClass(IndexMap.class);
            job.setCombinerClass(Combiner.class);
            job.setReducerClass(MaxOccurrenceReduce.class);
            job.setOutputKeyClass(Text.class);
            job.setOutputValueClass(IntWritable.class);
            FileInputFormat.addInputPath(job, new Path(otherArgs[0]));
            FileOutputFormat.setOutputPath(job, new Path(otherArgs[1] + "-B"));
        }
        else {
            System.exit(2);
        }

        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}