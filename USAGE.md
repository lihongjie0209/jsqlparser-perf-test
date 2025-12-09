# JSqlParser Performance Testing - Quick Start Guide

This guide will help you quickly set up and run performance benchmarks comparing the original JSqlParser 4.5 with the optimized version 4.5-ext-v1.0.

## Prerequisites

- Java 11 or higher
- Maven 3.6 or higher

## Quick Start

### Step 1: Download the Optimized Version

```bash
./setup-optimized-version.sh
```

This will download the optimized JSqlParser JAR to the `lib/` directory.

### Step 2: Run Benchmarks for Original Version

```bash
./run-benchmarks.sh original
```

This builds the project with JSqlParser 4.5 from Maven Central and runs all benchmarks.
Results will be saved in `results/benchmark_original_*.txt` and `*.json`.

### Step 3: Run Benchmarks for Optimized Version

```bash
./run-benchmarks.sh optimized
```

This rebuilds the project with the optimized JSqlParser 4.5-ext-v1.0 and runs all benchmarks.
Results will be saved in `results/benchmark_optimized_*.txt` and `*.json`.

### Step 4: Compare Results

```bash
./compare-results.sh results/benchmark_original_*.txt results/benchmark_optimized_*.txt
```

This will display a side-by-side comparison of the results.

## Alternative: Automated Comparison

Run both versions automatically:

```bash
./run-comparison.sh --both
```

This script will:
1. Run benchmarks with the original version
2. Prompt you to confirm setup (will check for optimized JAR)
3. Run benchmarks with the optimized version
4. Provide instructions for comparing results

## Benchmark Suites

### JSqlParserBenchmark

Tests general SQL parsing performance:
- `parseSimpleSelect` - Simple SELECT statements
- `parseSimpleInsert` - Simple INSERT statements
- `parseSimpleUpdate` - Simple UPDATE statements
- `parseSimpleDelete` - Simple DELETE statements
- `parseComplexSelect` - Complex SELECT with JOINs
- `parseComplexSubquery` - Subqueries
- `parseComplexJoin` - Multi-table JOINs
- `parseComplexCTE` - Common Table Expressions
- `parseVeryComplexQuery` - Nested complex queries
- `parseMixedQueries` - Mixed query workload

### TimeoutBenchmark

Tests timeout mechanism performance:
- `parseWithoutTimeout` - Baseline parsing
- `parseWithShortTimeout` - Parsing with timeout configured
- `rapidSuccessiveParsing` - Rapid successive parsing (stress test)
- `varyingComplexityParsing` - Mixed complexity queries
- `mixedStatementTypes` - Different statement types

## Understanding Results

JMH output format:
```
Benchmark                              Mode  Cnt    Score    Error  Units
JSqlParserBenchmark.parseSimpleSelect  avgt    5   12.345 ± 0.123  us/op
```

- **Mode**: `avgt` = average time per operation
- **Cnt**: Number of measurement iterations
- **Score**: Average time in microseconds (us/op = microseconds per operation)
- **Error**: Measurement error margin (±)
- **Lower scores are better** (faster parsing)

## Performance Metrics to Look For

### Expected Improvements in Optimized Version

1. **Reduced Overhead**: Lower baseline parsing time
2. **Better Timeout Handling**: Faster timeout checking without thread creation
3. **Improved Throughput**: Better performance in rapid successive parsing
4. **Reduced Latency**: More consistent timing with lower variance

### Key Comparisons

Compare these metrics between versions:
- Average time (Score) - should be lower in optimized version
- Error margin - should be similar or lower (more consistent)
- Throughput (ops/s) - calculated as 1/(score in seconds)

Example calculation:
- Original: 245 us/op = 4,082 ops/second
- Optimized: 200 us/op = 5,000 ops/second
- Improvement: ~22.5%

## Advanced Usage

### Run Specific Benchmarks

```bash
# Run only timeout benchmarks
java -jar target/benchmarks.jar TimeoutBenchmark

# Run a specific method
java -jar target/benchmarks.jar JSqlParserBenchmark.parseComplexSelect

# Run with custom parameters
java -jar target/benchmarks.jar -wi 5 -i 10 -f 2
```

Parameters:
- `-wi N` : Number of warmup iterations
- `-i N` : Number of measurement iterations
- `-f N` : Number of forks
- `-t N` : Number of threads

### Generate Reports

```bash
# JSON format (for visualization tools)
java -jar target/benchmarks.jar -rf json -rff results/report.json

# CSV format (for spreadsheets)
java -jar target/benchmarks.jar -rf csv -rff results/report.csv
```

### Profiling

```bash
# GC profiler (memory allocation)
java -jar target/benchmarks.jar -prof gc

# Stack profiler (hotspots)
java -jar target/benchmarks.jar -prof stack

# List all profilers
java -jar target/benchmarks.jar -lprof
```

## Troubleshooting

### Build Fails

If the build fails with dependency errors:
```bash
# Clear Maven cache and rebuild
rm -rf ~/.m2/repository/com/github/jsqlparser
mvn clean package -U
```

### Optimized Version Not Found

If you get "optimized JAR not found" error:
```bash
# Re-download the optimized version
rm -rf lib/
./setup-optimized-version.sh
```

### Benchmarks Take Too Long

For faster testing during development:
```bash
# Reduce iterations
java -jar target/benchmarks.jar -wi 1 -i 2 -f 1
```

### Out of Memory

Increase JVM heap size:
```bash
java -Xmx4g -jar target/benchmarks.jar
```

## Tips for Accurate Benchmarking

1. **Close other applications** to reduce system noise
2. **Run multiple forks** (-f 3 or more) for statistical significance
3. **Use consistent hardware** when comparing results over time
4. **Warm up the JVM** properly (default: 3 warmup iterations)
5. **Consider GC impact** - use `-prof gc` to see allocation patterns
6. **Run at different times** to account for environmental factors

## Visualization

For better visualization of results:

1. **JMH Visualizer**: Upload JSON results to https://jmh.morethan.io/
2. **Spreadsheets**: Import CSV results into Excel/Google Sheets
3. **Custom Scripts**: Parse JSON with Python/R for custom analysis

## Example Complete Workflow

```bash
# 1. Setup
git clone <this-repo>
cd jsqlparser-perf-test
./setup-optimized-version.sh

# 2. Build with original version
mvn clean package

# 3. Quick test
java -jar target/benchmarks.jar JSqlParserBenchmark.parseSimpleSelect -wi 1 -i 2 -f 1

# 4. Full benchmark - original
./run-benchmarks.sh original

# 5. Full benchmark - optimized
./run-benchmarks.sh optimized

# 6. Compare
./compare-results.sh results/benchmark_original_*.txt results/benchmark_optimized_*.txt

# 7. Analyze JSON results
# Upload to https://jmh.morethan.io/ or parse with your tools
```

## Contact & Support

For issues or questions:
- Check the main [README.md](README.md) for detailed documentation
- Review the [JSqlParser documentation](https://github.com/JSQLParser/JSqlParser)
- Check the [optimized version release notes](https://github.com/lihongjie0209/JSqlParser/releases/tag/jsqlparser-4.5-ext-v1.0)
