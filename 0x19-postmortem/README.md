# Postmortem: Database Deadlock Incident

## Issue Summary
- **Duration**: 3 hours and 27 minutes (January 15, 2025, 14:32 - 18:59 UTC)
- **Impact**: Search functionality was completely down for 78% of users. The remaining users experienced search response times exceeding 30 seconds.
- **Root Cause**: Database deadlock caused by a recently deployed feature that introduced a race condition in concurrent database transactions.

## Timeline
- **14:32 UTC** - Issue detected when our monitoring system triggered alerts for high latency in search API endpoints.
- **14:40 UTC** - Engineering team acknowledged alert and began investigation, initially suspecting search indexing issues.
- **15:05 UTC** - Customer support reported increasing user complaints about search functionality not working.
- **15:25 UTC** - Initial investigation focused on search service and its dependencies, ruling out network issues and load balancer configuration.
- **15:55 UTC** - Database metrics showed abnormally high number of locked rows, suggesting potential deadlock.
- **16:10 UTC** - Team spent time investigating a recent CDN change as possible cause, which turned out to be a misleading path.
- **16:45 UTC** - Incident escalated to Database Engineering team after identifying database locks as likely culprit.
- **17:20 UTC** - Root cause identified: race condition in new product filtering feature deployed earlier that day.
- **17:50 UTC** - Emergency rollback of the problematic code deployed to production.
- **18:30 UTC** - Manually killed hanging database connections.
- **18:59 UTC** - Services fully recovered, confirmed by monitoring metrics returning to normal baselines.

## Root Cause and Resolution
The outage was caused by a race condition in our database access layer introduced by a new product filtering feature. The feature implemented concurrent database transactions that could acquire locks on the same database rows but in different orders, creating a classic deadlock scenario. As traffic increased during peak hours, the probability of deadlocks occurring grew exponentially.

When a deadlock was detected, our database would automatically kill one of the transactions, but our application code wasn't properly handling these exceptions. Instead of graceful degradation, the application would retry the same query, exacerbating the problem and eventually consuming all available database connections.

The issue was resolved through:
1. Immediate rollback of the problematic feature
2. Manually terminating all hanging database connections
3. Restarting the connection pool to clear the backlog of requests

## Corrective and Preventative Measures
### Improvements Needed
- Enhanced pre-deployment testing for database-intensive features
- Better deadlock detection and handling in application code
- Improved monitoring for database lock contention
- Proper circuit breaking patterns for database failures

### Specific Tasks
1. Refactor product filtering feature to acquire locks in a consistent order (Due: Jan 22)
2. Implement proper exception handling for database deadlock scenarios (Due: Jan 20)
3. Add automated testing for concurrent database operations (Due: Jan 25)
4. Create dashboard for database lock metrics with appropriate alerting thresholds (Due: Jan 19)
5. Document deadlock troubleshooting procedures for on-call engineers (Due: Jan 18)
6. Schedule knowledge-sharing session on database transaction best practices (Due: Jan 30)
7. Implement circuit breaker pattern in search service to fail gracefully during database issues (Due: Feb 5)
8. Add canary deployment process for database-related changes (Due: Feb 10)

DEFINETELY NOT FOR TOUGH PEOPLE 

# The Great Database Deadlock Disaster of 2025

![Database Deadlock Illustration](https://cdn.pixabay.com/photo/2017/06/10/07/18/database-2389207_1280.png)

## Issue Summary
- **Duration**: 3 hours and 27 minutes of pure chaos (January 15, 2025, 14:32 - 18:59 UTC)
- **Impact**: Search functionality went on an unscheduled vacation for 78% of users. The lucky remaining 22% got to practice the ancient art of patience with 30+ second response times.
- **Root Cause**: A classic case of "two database transactions walk into a bar and neither wants to leave first" - also known as a deadlock from our shiny new feature that introduced a race condition.

## Timeline
- **14:32 UTC** - 🚨 Monitoring alarms scream in digital agony as search latency skyrockets.
- **14:40 UTC** - Engineers stop sipping coffee and start frantically typing. "Must be a search indexing problem," they said, incorrectly.
- **15:05 UTC** - Customer support's Slack channel becomes a wall of "Is search down?" screenshots.
- **15:25 UTC** - Network team: "Not our fault this time!" Load balancer team: "Don't look at us!"
- **15:55 UTC** - Database metrics reveal more locked rows than a maximum security prison.
- **16:10 UTC** - Team goes on wild goose chase investigating a recent CDN change. Spoiler: the goose was elsewhere.
- **16:45 UTC** - Problem gets escalated to Database Engineering team, who collectively sigh and cancel their dinner plans.
- **17:20 UTC** - Root cause identified: that cool new product filtering feature we deployed this morning wasn't so cool after all.
- **17:50 UTC** - Code rollback initiated faster than you can say "transaction isolation level."
- **18:30 UTC** - Database connections that refused to die get the digital equivalent of "turn it off and back on again."
- **18:59 UTC** - Systems return to normal. Engineers return to caffeine intake.

## The Deadlock Dance: What Actually Happened

Our exciting new product filtering feature had a tiny flaw: it was grabbing database locks like a toddler grabs toys - chaotically and without sharing. Here's what happened in excruciating detail:

```
Transaction A: "I'll lock row 1, then row 2!"
Transaction B: "Well, I'll lock row 2, then row 1!"
*Both transactions stare at each other awkwardly, waiting forever*
```

As traffic increased during peak hours, these deadlocks multiplied faster than rabbits. Worse yet, our error handling was basically "if at first you don't succeed, try, try again with exactly the same approach," which is the computational equivalent of banging your head against the same wall repeatedly.

## How We Fixed It (And How We'll Prevent the Sequel)

### Immediate Fixes:
1. Rolled back the problematic code faster than you can say "git revert"
2. Killed zombie database connections with extreme prejudice
3. Performed the sacred ritual of "turning it off and on again" for the connection pool

### Future Proofing Tasks:
1. Refactor the filtering feature to acquire locks in a consistent order, like civilized code (Due: Jan 22)
2. Teach our application the concept of graceful failure (Due: Jan 20)
3. Build automated tests that simulate concurrent users doing concurrent things (Due: Jan 25)
4. Create a fancy dashboard that shows database lock metrics with lots of colorful alerts (Due: Jan 19)
5. Write a "So You've Encountered a Deadlock" guide for bleary-eyed on-call engineers (Due: Jan 18)
6. Host a "Transactions and You: A Love-Hate Relationship" lunch and learn (Due: Jan 30)
7. Implement circuit breakers so failures can be fast and dignified (Due: Feb 5)
8. Add canary deployments so future database disasters affect fewer users (Due: Feb 10)

Remember folks, in the immortal words of database wisdom: "Always lock in order, or your service's availability will be shorter."
