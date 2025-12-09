#!/bin/bash

# Script to automatically run benchmarks for both versions and compare results

set -e

echo "=========================================="
echo "JSqlParser Automatic Comparison Runner"
echo "=========================================="
echo ""

# Create results directory
mkdir -p results

# Function to run benchmarks
run_benchmark() {
    local version=$1
    local output_prefix=$2
    
    echo "Building and running benchmarks for $version..."
    mvn clean package
    
    if [ ! -f "target/benchmarks.jar" ]; then
        echo "Error: Build failed for $version"
        return 1
    fi
    
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    
    echo "Running benchmarks for $version..."
    java -jar target/benchmarks.jar \
        -rf json \
        -rff "results/${output_prefix}_${TIMESTAMP}.json" \
        2>&1 | tee "results/${output_prefix}_${TIMESTAMP}.txt"
    
    echo ""
    echo "$version benchmarks completed!"
    echo "Results saved to results/${output_prefix}_${TIMESTAMP}.*"
    echo ""
}

# Check if we should run both versions
if [ "$1" == "--both" ]; then
    echo "This script will:"
    echo "1. Run benchmarks with the current JSqlParser version (original)"
    echo "2. Prompt you to update pom.xml to use the optimized version"
    echo "3. Run benchmarks with the optimized version"
    echo "4. Compare the results"
    echo ""
    read -p "Do you want to continue? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
    
    # Run original version
    echo ""
    echo "Step 1: Running benchmarks with original version..."
    run_benchmark "Original JSqlParser" "original"
    
    # Prompt for version change
    echo ""
    echo "=========================================="
    echo "Step 2: Update pom.xml"
    echo "=========================================="
    echo ""
    echo "Please update pom.xml to use the optimized JSqlParser version."
    echo "Change the version to: 4.5-ext-v1.0"
    echo ""
    echo "Make sure you have installed the optimized version locally:"
    echo "  mvn install:install-file -Dfile=path/to/jsqlparser-4.5-ext-v1.0.jar \\"
    echo "    -DgroupId=com.github.jsql-parser -DartifactId=jsqlparser \\"
    echo "    -Dversion=4.5-ext-v1.0 -Dpackaging=jar"
    echo ""
    read -p "Press Enter when you have updated pom.xml..." 
    
    # Run optimized version
    echo ""
    echo "Step 3: Running benchmarks with optimized version..."
    run_benchmark "Optimized JSqlParser" "optimized"
    
    echo ""
    echo "=========================================="
    echo "Step 4: Comparison"
    echo "=========================================="
    echo ""
    echo "Both benchmark runs completed!"
    echo "You can now compare the results in the results/ directory."
    echo ""
    echo "To compare results, use:"
    echo "  ./compare-results.sh results/original_*.txt results/optimized_*.txt"
    echo ""
    
else
    # Run single benchmark with current version
    echo "Running benchmarks with current configuration..."
    echo ""
    run_benchmark "Current JSqlParser" "benchmark"
    
    echo ""
    echo "To run comparison between both versions, use:"
    echo "  $0 --both"
    echo ""
fi

echo "=========================================="
echo "Done!"
echo "=========================================="
