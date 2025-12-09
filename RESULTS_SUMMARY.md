# JSqlParser Performance Testing Results

## Overview

This repository contains comprehensive JMH (Java Microbenchmark Harness) benchmarks comparing the performance of JSqlParser 4.5 (original) with JSqlParser 4.5-ext-v1.0 (optimized with cooperative timeout mechanism).

## Test Results

### Performance Improvements

The optimized version demonstrates **significant performance improvements** across all test scenarios:

| Category | Average Improvement | Speedup Range |
|----------|---------------------|---------------|
| **Simple Queries** | 82-88% faster | 5.7x - 8.7x |
| **Complex Queries** | 42-58% faster | 1.7x - 2.4x |
| **Timeout Scenarios** | 75-76% faster | 4.0x - 4.2x |
| **Mixed Workloads** | 57-86% faster | 2.4x - 7.4x |
| **Overall Average** | **69.73% faster** | **4.8x speedup** |

### Detailed Benchmark Results

#### Simple SQL Queries

| Benchmark | Original (μs) | Optimized (μs) | Improvement |
|-----------|---------------|----------------|-------------|
| parseSimpleSelect | 217.51 | 31.37 | **+85.58%** (6.93x) |
| parseSimpleInsert | 193.31 | 22.36 | **+88.43%** (8.65x) |
| parseSimpleUpdate | 209.90 | 36.81 | **+82.46%** (5.70x) |
| parseSimpleDelete | 195.33 | 22.39 | **+88.53%** (8.72x) |

**Key Takeaway**: Simple queries show the most dramatic improvements (82-88% faster), with up to 8.7x speedup.

#### Complex SQL Queries

| Benchmark | Original (μs) | Optimized (μs) | Improvement |
|-----------|---------------|----------------|-------------|
| parseComplexSelect | 368.17 | 154.55 | **+58.02%** (2.38x) |
| parseComplexJoin | 406.10 | 199.93 | **+50.77%** (2.03x) |
| parseComplexSubquery | 419.03 | 203.73 | **+51.38%** (2.06x) |
| parseComplexCTE | 481.54 | 273.55 | **+43.19%** (1.76x) |
| parseVeryComplexQuery | 727.39 | 421.48 | **+42.05%** (1.73x) |

**Key Takeaway**: Complex queries show consistent improvements (42-58% faster), doubling parsing speed.

#### Timeout Mechanism Performance

| Benchmark | Original (μs) | Optimized (μs) | Improvement |
|-----------|---------------|----------------|-------------|
| parseWithoutTimeout | 1214.60 | 296.27 | **+75.61%** (4.10x) |
| parseWithShortTimeout | 1215.51 | 289.87 | **+76.15%** (4.19x) |
| rapidSuccessiveParsing | 1987.44 | 186.89 | **+90.60%** (10.63x) |
| mixedStatementTypes | 825.38 | 112.21 | **+86.40%** (7.36x) |
| varyingComplexityParsing | 867.57 | 265.57 | **+69.39%** (3.27x) |

**Key Takeaway**: The cooperative timeout mechanism eliminates thread creation overhead, resulting in 75-90% faster parsing in timeout scenarios.

## Optimization Details

### Cooperative Timeout Mechanism

The optimized version (4.5-ext-v1.0) implements a cooperative timeout mechanism with the following features:

✅ **Zero Thread Creation**: Eliminates the overhead of creating temporary threads for timeout handling
✅ **Strategic Checkpoints**: Adds timeout checkpoints at key parsing locations:
  - Expression parsing loops (XOR, OR, AND)
  - SELECT items list processing
  - JOIN operation parsing
  - Set operations (UNION, INTERSECT, EXCEPT)
  - Expression lists

✅ **Backward Compatible**: Maintains full API compatibility with JSqlParser 4.5
✅ **Java 8+ Compatible**: Works with Java 8 and above

### Why the Improvements?

1. **Reduced Overhead**: No thread creation/destruction for each parse operation
2. **Better CPU Utilization**: Less context switching and thread management
3. **Optimized Code Paths**: More efficient timeout checking at strategic points
4. **Lower Memory Allocation**: Reduced object creation during parsing

## Test Environment

- **Java Version**: OpenJDK 17.0.17
- **JVM**: OpenJDK 64-Bit Server VM
- **CPU**: AMD EPYC 7763 64-Core Processor
- **Memory**: 15GB RAM
- **OS**: Linux 6.11.0
- **JMH Version**: 1.37
- **Warmup**: 2-3 iterations
- **Measurement**: 3-5 iterations

## Use Cases

### Recommended For:

1. **High-Throughput Applications**
   - Web services parsing thousands of SQL queries per second
   - Batch processing systems
   - SQL query analyzers and validators

2. **Latency-Sensitive Applications**
   - Interactive SQL editors with real-time parsing
   - IDE plugins with auto-completion
   - Query builders with instant validation

3. **Timeout-Critical Systems**
   - Applications with strict SLA requirements
   - Multi-tenant systems with resource limits
   - Systems processing untrusted SQL queries

### Expected Performance Gains:

- **Simple queries**: 5-8x faster → Ideal for high-frequency, simple SQL parsing
- **Complex queries**: 1.7-2.4x faster → Good for all query types
- **Rapid successive parsing**: 10x faster → Excellent for batch operations

## Running the Benchmarks

### Quick Start

```bash
# 1. Setup
./setup-optimized-version.sh

# 2. Run benchmarks for original version
./run-benchmarks.sh original

# 3. Run benchmarks for optimized version
./run-benchmarks.sh optimized

# 4. Generate comparison report
./generate-report.sh results/benchmark_original_*.json results/benchmark_optimized_*.json
```

### Custom Benchmarks

```bash
# Run specific benchmark
java -jar target/benchmarks.jar JSqlParserBenchmark.parseSimpleSelect

# Run with custom parameters
java -jar target/benchmarks.jar -wi 5 -i 10 -f 3

# Run with profiling
java -jar target/benchmarks.jar -prof gc
```

See [USAGE.md](USAGE.md) for detailed instructions.

## Conclusion

The optimized JSqlParser 4.5-ext-v1.0 demonstrates **significant and consistent performance improvements** across all test scenarios:

- **69.73% average improvement** across all benchmarks
- **100% of benchmarks show improvements** (15/15)
- **No performance regressions** observed
- **Maintains full API compatibility** with original version

The cooperative timeout mechanism successfully eliminates the overhead of thread creation while providing better timeout responsiveness, making it an excellent choice for production deployments, especially in high-throughput or latency-sensitive applications.

## References

- [JSqlParser Original Repository](https://github.com/JSQLParser/JSqlParser)
- [Optimized Version Release](https://github.com/lihongjie0209/JSqlParser/releases/tag/jsqlparser-4.5-ext-v1.0)
- [JMH (Java Microbenchmark Harness)](https://github.com/openjdk/jmh)
- [Full Performance Report](results/performance_report_20251209_134847.md)
- [Detailed Usage Guide](USAGE.md)

## License

This benchmarking project follows the same license as JSqlParser.
