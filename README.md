# JSqlParser Performance Test

This project provides JMH (Java Microbenchmark Harness) benchmarks to compare the performance of the original JSqlParser version with an optimized version that includes timeout mechanism improvements.

## Overview

This benchmarking suite is designed to test and compare:
- **Original Version**: JSqlParser 4.5 (official release)
- **Optimized Version**: JSqlParser 4.5-ext-v1.0 (with timeout optimization)

The benchmarks focus on:
- Simple SQL queries (SELECT, INSERT, UPDATE, DELETE)
- Complex SQL queries (JOINs, subqueries, CTEs)
- Timeout mechanism performance
- Mixed query workloads

## ⭐ Performance Results

**The optimized version shows a 69.73% average performance improvement!** 🚀

📊 **[View Full Results Summary](RESULTS_SUMMARY.md)** - Detailed performance analysis and benchmark results

## Quick Start

📚 **See [USAGE.md](USAGE.md) for a complete step-by-step guide**

```bash
# 1. Download optimized version
./setup-optimized-version.sh

# 2. Run benchmarks for original version
./run-benchmarks.sh original

# 3. Run benchmarks for optimized version  
./run-benchmarks.sh optimized

# 4. Generate comparison report
./generate-report.sh results/benchmark_original_*.json results/benchmark_optimized_*.json
```

## Prerequisites

- Java 11 or higher
- Maven 3.6 or higher

## Project Structure

```
jsqlparser-perf-test/
├── pom.xml                           # Maven configuration with JMH dependencies
├── run-benchmarks.sh                 # Script to run all benchmarks
├── src/main/java/
│   └── com/github/lihongjie0209/benchmark/
│       ├── JSqlParserBenchmark.java  # Main benchmark suite
│       └── TimeoutBenchmark.java     # Timeout-specific benchmarks
└── results/                          # Benchmark results (generated)
```

## Building the Project

```bash
mvn clean package
```

This will create an executable JAR file at `target/benchmarks.jar`.

## Running Benchmarks

### Option 1: Use the convenience script

```bash
./run-benchmarks.sh
```

This script will:
1. Build the project
2. Run all benchmarks
3. Save results to the `results/` directory with timestamps

### Option 2: Run manually with Maven

```bash
# Run all benchmarks
java -jar target/benchmarks.jar

# Run specific benchmark class
java -jar target/benchmarks.jar JSqlParserBenchmark

# Run specific benchmark method
java -jar target/benchmarks.jar JSqlParserBenchmark.parseSimpleSelect

# Run with custom parameters
java -jar target/benchmarks.jar -wi 5 -i 10 -f 2
```

### Option 3: Run specific benchmarks with Maven exec plugin

```bash
# Run all benchmarks
mvn exec:exec -Dexec.executable="java" -Dexec.args="-jar target/benchmarks.jar"
```

## Benchmark Parameters

The benchmarks are configured with:
- **Warmup**: 3 iterations, 1 second each
- **Measurement**: 5 iterations, 1 second each
- **Forks**: 1 (can be increased for more reliable results)
- **Mode**: Average time
- **Time Unit**: Microseconds

You can customize these by modifying the annotations in the benchmark classes or using JMH command-line options.

## Understanding Results

JMH will output results in the following format:

```
Benchmark                                    Mode  Cnt   Score   Error  Units
JSqlParserBenchmark.parseSimpleSelect        avgt    5  12.345 ± 0.123  us/op
JSqlParserBenchmark.parseComplexSelect       avgt    5  45.678 ± 1.234  us/op
```

- **Mode**: Benchmark mode (avgt = average time)
- **Cnt**: Number of measurement iterations
- **Score**: Average time per operation
- **Error**: Measurement error margin
- **Units**: Time unit (us/op = microseconds per operation)

Lower scores indicate better performance.

## Comparing Versions

### Testing the Original Version

The current setup uses JSqlParser 4.5 as specified in `pom.xml`:

```xml
<dependency>
    <groupId>com.github.jsql-parser</groupId>
    <artifactId>jsqlparser</artifactId>
    <version>4.5</version>
</dependency>
```

### Testing the Optimized Version

To test the optimized version (jsqlparser-4.5-ext-v1.0):

1. **Option A: Install locally from release**
   
   Download the JAR from https://github.com/lihongjie0209/JSqlParser/releases/tag/jsqlparser-4.5-ext-v1.0
   
   ```bash
   mvn install:install-file \
     -Dfile=path/to/jsqlparser-4.5-ext-v1.0.jar \
     -DgroupId=com.github.jsql-parser \
     -DartifactId=jsqlparser \
     -Dversion=4.5-ext-v1.0 \
     -Dpackaging=jar
   ```
   
   Then update `pom.xml`:
   ```xml
   <dependency>
       <groupId>com.github.jsql-parser</groupId>
       <artifactId>jsqlparser</artifactId>
       <version>4.5-ext-v1.0</version>
   </dependency>
   ```

2. **Option B: Build from source**
   
   Clone and build the optimized version:
   ```bash
   git clone https://github.com/lihongjie0209/JSqlParser.git
   cd JSqlParser
   git checkout jsqlparser-4.5-ext-v1.0
   mvn clean install -DskipTests
   ```
   
   Then update the version in this project's `pom.xml`.

### Running Comparative Tests

1. Run benchmarks with original version:
   ```bash
   ./run-benchmarks.sh
   mv results/benchmark_results_*.json results/original_version.json
   ```

2. Update `pom.xml` to use optimized version

3. Run benchmarks with optimized version:
   ```bash
   ./run-benchmarks.sh
   mv results/benchmark_results_*.json results/optimized_version.json
   ```

4. Compare results manually or use JMH visualization tools

## Benchmark Suites

### JSqlParserBenchmark

Tests general SQL parsing performance with:
- Simple SELECT, INSERT, UPDATE, DELETE statements
- Complex SELECT with JOINs
- Subqueries
- Common Table Expressions (CTEs)
- Nested queries
- Mixed query workloads

### TimeoutBenchmark

Focuses on timeout mechanism performance:
- Parsing without timeout
- Parsing with timeout configured
- Rapid successive parsing
- Varying complexity queries
- Mixed statement types

## Advanced Usage

### Running with Different JVM Options

```bash
java -Xmx2g -XX:+UseG1GC -jar target/benchmarks.jar
```

### Generating Reports

JMH supports various output formats:

```bash
# JSON format
java -jar target/benchmarks.jar -rf json -rff results/results.json

# CSV format
java -jar target/benchmarks.jar -rf csv -rff results/results.csv

# Text format (default)
java -jar target/benchmarks.jar -rf text -rff results/results.txt
```

### Running with Profilers

JMH includes built-in profilers:

```bash
# GC profiler
java -jar target/benchmarks.jar -prof gc

# Stack profiler
java -jar target/benchmarks.jar -prof stack

# All profilers
java -jar target/benchmarks.jar -lprof
```

## Troubleshooting

### Out of Memory Error

If you encounter OutOfMemoryError, increase heap size:
```bash
java -Xmx4g -jar target/benchmarks.jar
```

### Benchmarks Taking Too Long

Reduce iterations or warmup time:
```bash
java -jar target/benchmarks.jar -wi 1 -i 3
```

## Contributing

Feel free to add more benchmark scenarios by:
1. Adding new benchmark methods to existing classes
2. Creating new benchmark classes in `src/main/java/com/github/lihongjie0209/benchmark/`
3. Following JMH best practices

## References

- [JMH Documentation](https://github.com/openjdk/jmh)
- [JSqlParser GitHub](https://github.com/JSQLParser/JSqlParser)
- [Optimized JSqlParser Release](https://github.com/lihongjie0209/JSqlParser/releases/tag/jsqlparser-4.5-ext-v1.0)