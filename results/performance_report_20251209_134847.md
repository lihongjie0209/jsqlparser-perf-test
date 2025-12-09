# JSqlParser Performance Comparison Report

## Executive Summary

This report compares the performance of:
- **Original Version**: JSqlParser 4.5 (from Maven Central)
- **Optimized Version**: JSqlParser 4.5-ext-v1.0 (with cooperative timeout mechanism)

## Test Environment

- **Date**: 2025-12-09 13:48:47
- **Java Version**: openjdk version "17.0.17" 2025-10-21
- **JVM**: OpenJDK Runtime Environment Temurin-17.0.17+10 (build 17.0.17+10)
- **OS**: Linux 6.11.0-1018-azure
- **CPU**: AMD EPYC 7763 64-Core Processor
- **Memory**: 15Gi

## Benchmark Configuration

- **Warmup Iterations**: 3
- **Measurement Iterations**: 5
- **Forks**: 1
- **Benchmark Mode**: Average Time (microseconds per operation)
- **JMH Version**: 1.37

## Results

### Original Version (4.5)

```
Results from: results/benchmark_original_demo.json
parseComplexCTE                             481.542 ± 1333.950 us/op
parseComplexJoin                            406.103 ±  564.365 us/op
parseComplexSelect                          368.173 ±  226.511 us/op
parseComplexSubquery                        419.033 ±  847.369 us/op
parseMixedQueries                          1266.676 ± 1872.377 us/op
parseSimpleDelete                           195.331 ±  131.923 us/op
parseSimpleInsert                           193.308 ±  116.085 us/op
parseSimpleSelect                           217.510 ±  375.063 us/op
parseSimpleUpdate                           209.901 ±  133.425 us/op
parseVeryComplexQuery                       727.386 ± 2154.468 us/op
mixedStatementTypes                         825.378 ±  563.328 us/op
parseWithShortTimeout                      1215.507 ± 1303.720 us/op
parseWithoutTimeout                        1214.604 ± 2902.256 us/op
rapidSuccessiveParsing                     1987.435 ± 2030.562 us/op
varyingComplexityParsing                    867.570 ±  653.134 us/op
```

### Optimized Version (4.5-ext-v1.0)

```
Results from: results/benchmark_optimized_demo.json
parseComplexCTE                             273.550 ± 1968.301 us/op
parseComplexJoin                            199.931 ±  388.871 us/op
parseComplexSelect                          154.550 ±  109.534 us/op
parseComplexSubquery                        203.732 ± 1230.098 us/op
parseMixedQueries                           539.052 ± 3750.422 us/op
parseSimpleDelete                            22.395 ±    0.530 us/op
parseSimpleInsert                            22.359 ±    2.215 us/op
parseSimpleSelect                            31.371 ±    1.949 us/op
parseSimpleUpdate                            36.810 ±   13.113 us/op
parseVeryComplexQuery                       421.485 ± 1080.738 us/op
mixedStatementTypes                         112.211 ±   33.991 us/op
parseWithShortTimeout                       289.872 ± 1931.771 us/op
parseWithoutTimeout                         296.268 ± 1138.866 us/op
rapidSuccessiveParsing                      186.886 ±   21.610 us/op
varyingComplexityParsing                    265.566 ±  498.289 us/op
```

## Performance Comparison

| Benchmark | Original (μs) | Optimized (μs) | Improvement | Speedup |
|-----------|---------------|----------------|-------------|---------|
| parseComplexCTE                |     481.54 |     273.55 |     +43.19% |   1.76x |
| parseComplexJoin               |     406.10 |     199.93 |     +50.77% |   2.03x |
| parseComplexSelect             |     368.17 |     154.55 |     +58.02% |   2.38x |
| parseComplexSubquery           |     419.03 |     203.73 |     +51.38% |   2.06x |
| parseMixedQueries              |    1266.68 |     539.05 |     +57.44% |   2.35x |
| parseSimpleDelete              |     195.33 |      22.39 |     +88.53% |   8.72x |
| parseSimpleInsert              |     193.31 |      22.36 |     +88.43% |   8.65x |
| parseSimpleSelect              |     217.51 |      31.37 |     +85.58% |   6.93x |
| parseSimpleUpdate              |     209.90 |      36.81 |     +82.46% |   5.70x |
| parseVeryComplexQuery          |     727.39 |     421.48 |     +42.05% |   1.73x |
| mixedStatementTypes            |     825.38 |     112.21 |     +86.40% |   7.36x |
| parseWithShortTimeout          |    1215.51 |     289.87 |     +76.15% |   4.19x |
| parseWithoutTimeout            |    1214.60 |     296.27 |     +75.61% |   4.10x |
| rapidSuccessiveParsing         |    1987.44 |     186.89 |     +90.60% |  10.63x |
| varyingComplexityParsing       |     867.57 |     265.57 |     +69.39% |   3.27x |

**Note**: Positive improvement percentage means optimized version is faster.


## Analysis

### Key Findings

1. **Average Performance Improvement**: 69.73%
2. **Best Improvement**: 90.60%
3. **Worst Case**: 42.05%
4. **Benchmarks Improved**: 15/15 (100.0%)
5. **Overall Assessment**: The optimized version shows a 69.73% average improvement across all benchmarks.

cat >> "results/performance_report_20251209_134847.md" << 'EOF'

### Timeout Mechanism

The optimized version implements a **cooperative timeout mechanism** that:
- ✅ Eliminates thread creation during parsing
- ✅ Adds strategic timeout checkpoints in parsing loops
- ✅ Provides faster timeout detection
- ✅ Reduces overall parsing overhead

### Recommendations

Based on these results:

1. **For Production Use**: 
   - If improvements are significant (>10%), consider adopting the optimized version
   - Conduct additional testing with production workloads

2. **For High-Throughput Scenarios**:
   - The optimized version shows particular benefits in rapid successive parsing
   - Recommended for applications with frequent SQL parsing operations

3. **For Timeout-Critical Applications**:
   - The cooperative timeout mechanism provides more predictable timeout behavior
   - Better suited for applications with strict SLA requirements

## Visualization

For interactive visualization of these results:
1. Upload the JSON files to [JMH Visualizer](https://jmh.morethan.io/)
2. Import the CSV results into spreadsheet software
3. Use the provided data for custom analysis

## Conclusion

This performance comparison demonstrates the effectiveness of the timeout mechanism optimization in JSqlParser 4.5-ext-v1.0. The results show improvements in parsing performance while maintaining API compatibility with the original version.

---

**Report Generated**: EOF
date >> "results/performance_report_20251209_134847.md"
echo "**Report File**: results/performance_report_20251209_134847.md" >> "results/performance_report_20251209_134847.md"

echo ""
echo "=========================================="
echo "Performance Report Generated!"
echo "=========================================="
echo ""
echo "Report saved to: results/performance_report_20251209_134847.md"
echo ""
echo "To view the report:"
echo "  cat results/performance_report_20251209_134847.md"
echo ""
echo "Or open in a markdown viewer/browser."
echo "=========================================="
