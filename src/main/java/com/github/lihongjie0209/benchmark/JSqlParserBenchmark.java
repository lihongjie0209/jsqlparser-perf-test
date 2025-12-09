package com.github.lihongjie0209.benchmark;

import net.sf.jsqlparser.parser.CCJSqlParserUtil;
import net.sf.jsqlparser.statement.Statement;
import org.openjdk.jmh.annotations.*;
import org.openjdk.jmh.infra.Blackhole;

import java.util.concurrent.TimeUnit;

/**
 * JMH Benchmark for JSqlParser performance testing
 * Comparing original version with optimized timeout mechanism
 */
@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.MICROSECONDS)
@State(Scope.Benchmark)
@Warmup(iterations = 3, time = 1)
@Measurement(iterations = 5, time = 1)
@Fork(1)
public class JSqlParserBenchmark {

    // Simple SQL queries
    private static final String SIMPLE_SELECT = "SELECT * FROM users WHERE id = 1";
    private static final String SIMPLE_INSERT = "INSERT INTO users (id, name) VALUES (1, 'John')";
    private static final String SIMPLE_UPDATE = "UPDATE users SET name = 'Jane' WHERE id = 1";
    private static final String SIMPLE_DELETE = "DELETE FROM users WHERE id = 1";

    // Complex SQL queries
    private static final String COMPLEX_SELECT = 
        "SELECT u.id, u.name, o.order_id, o.total " +
        "FROM users u " +
        "INNER JOIN orders o ON u.id = o.user_id " +
        "WHERE u.status = 'active' " +
        "AND o.total > 100 " +
        "ORDER BY o.total DESC " +
        "LIMIT 10";

    private static final String COMPLEX_SUBQUERY = 
        "SELECT * FROM users WHERE id IN (" +
        "SELECT user_id FROM orders WHERE total > (" +
        "SELECT AVG(total) FROM orders WHERE status = 'completed'))";

    private static final String COMPLEX_JOIN = 
        "SELECT u.name, COUNT(o.id) as order_count, SUM(o.total) as total_amount " +
        "FROM users u " +
        "LEFT JOIN orders o ON u.id = o.user_id " +
        "LEFT JOIN order_items oi ON o.id = oi.order_id " +
        "WHERE u.created_at > '2023-01-01' " +
        "GROUP BY u.id, u.name " +
        "HAVING COUNT(o.id) > 5 " +
        "ORDER BY total_amount DESC";

    private static final String COMPLEX_CTE = 
        "WITH user_stats AS (" +
        "    SELECT user_id, COUNT(*) as order_count, SUM(total) as total_spent " +
        "    FROM orders " +
        "    GROUP BY user_id" +
        "), " +
        "top_users AS (" +
        "    SELECT user_id FROM user_stats WHERE order_count > 10" +
        ") " +
        "SELECT u.*, us.order_count, us.total_spent " +
        "FROM users u " +
        "JOIN user_stats us ON u.id = us.user_id " +
        "WHERE u.id IN (SELECT user_id FROM top_users)";

    // Nested complex query
    private static final String VERY_COMPLEX_QUERY = 
        "SELECT * FROM (" +
        "    SELECT u.id, u.name, " +
        "    (SELECT COUNT(*) FROM orders o WHERE o.user_id = u.id) as order_count, " +
        "    (SELECT MAX(total) FROM orders o WHERE o.user_id = u.id) as max_order " +
        "    FROM users u " +
        "    WHERE u.status IN ('active', 'premium')" +
        ") AS user_summary " +
        "WHERE order_count > 5 " +
        "ORDER BY max_order DESC " +
        "LIMIT 20";

    @Benchmark
    public void parseSimpleSelect(Blackhole blackhole) throws Exception {
        Statement stmt = CCJSqlParserUtil.parse(SIMPLE_SELECT);
        blackhole.consume(stmt);
    }

    @Benchmark
    public void parseSimpleInsert(Blackhole blackhole) throws Exception {
        Statement stmt = CCJSqlParserUtil.parse(SIMPLE_INSERT);
        blackhole.consume(stmt);
    }

    @Benchmark
    public void parseSimpleUpdate(Blackhole blackhole) throws Exception {
        Statement stmt = CCJSqlParserUtil.parse(SIMPLE_UPDATE);
        blackhole.consume(stmt);
    }

    @Benchmark
    public void parseSimpleDelete(Blackhole blackhole) throws Exception {
        Statement stmt = CCJSqlParserUtil.parse(SIMPLE_DELETE);
        blackhole.consume(stmt);
    }

    @Benchmark
    public void parseComplexSelect(Blackhole blackhole) throws Exception {
        Statement stmt = CCJSqlParserUtil.parse(COMPLEX_SELECT);
        blackhole.consume(stmt);
    }

    @Benchmark
    public void parseComplexSubquery(Blackhole blackhole) throws Exception {
        Statement stmt = CCJSqlParserUtil.parse(COMPLEX_SUBQUERY);
        blackhole.consume(stmt);
    }

    @Benchmark
    public void parseComplexJoin(Blackhole blackhole) throws Exception {
        Statement stmt = CCJSqlParserUtil.parse(COMPLEX_JOIN);
        blackhole.consume(stmt);
    }

    @Benchmark
    public void parseComplexCTE(Blackhole blackhole) throws Exception {
        Statement stmt = CCJSqlParserUtil.parse(COMPLEX_CTE);
        blackhole.consume(stmt);
    }

    @Benchmark
    public void parseVeryComplexQuery(Blackhole blackhole) throws Exception {
        Statement stmt = CCJSqlParserUtil.parse(VERY_COMPLEX_QUERY);
        blackhole.consume(stmt);
    }

    /**
     * Test parsing multiple queries in sequence
     */
    @Benchmark
    public void parseMixedQueries(Blackhole blackhole) throws Exception {
        blackhole.consume(CCJSqlParserUtil.parse(SIMPLE_SELECT));
        blackhole.consume(CCJSqlParserUtil.parse(SIMPLE_INSERT));
        blackhole.consume(CCJSqlParserUtil.parse(COMPLEX_SELECT));
        blackhole.consume(CCJSqlParserUtil.parse(COMPLEX_SUBQUERY));
    }
}
