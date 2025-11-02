---
title: Runbook: [Operation/Service Name]
linear_id: LIN-XXX
type: runbook
status: [Active | Deprecated | Under Review]
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: [Your Name]
related: []
on_call: [Team/Person responsible]
severity_levels: [P0, P1, P2, P3]
---

# Runbook: [Operation/Service Name]

## Quick Reference

| Property | Value |
|----------|-------|
| **Service Name** | [Name] |
| **Service Type** | [API/Database/Queue/Service] |
| **Owner** | [Team/Person] |
| **On-Call** | [Rotation/Contact] |
| **SLA** | [99.9% uptime, <100ms p95 latency] |
| **Dependencies** | [List critical dependencies] |
| **Monitoring** | [Dashboard URL] |
| **Logs** | [Log aggregation URL] |

---

## Service Overview

### Purpose
What this service does and why it exists. Keep it to 2-3 sentences.

### Architecture
High-level architecture diagram or description:
- Components involved
- Data flow
- Integration points

### Key Metrics
- **Uptime**: Target 99.9%
- **Latency**: p50 <50ms, p95 <100ms, p99 <200ms
- **Throughput**: X requests/second
- **Error Rate**: <0.1%

---

## Common Operations

### Operation 1: [Name]

**When to use**: Describe the scenario

**Prerequisites**:
- [ ] Requirement 1
- [ ] Requirement 2

**Steps**:
```bash
# Step 1: Description
command --option value

# Step 2: Description
command --option value

# Step 3: Verify
command --check
```

**Expected Output**:
```
Sample expected output
```

**Verification**:
- [ ] Check 1: How to verify
- [ ] Check 2: How to verify

**Rollback** (if needed):
```bash
# Rollback command
command --undo
```

---

### Operation 2: [Name]

**When to use**: Describe the scenario

**Prerequisites**:
- [ ] Requirement 1
- [ ] Requirement 2

**Steps**:
```bash
# Step 1
command

# Step 2
command
```

**Expected Output**:
```
Sample output
```

**Verification**:
- [ ] Check 1
- [ ] Check 2

---

## Troubleshooting Guide

### Issue 1: [Symptom]

**Symptoms**:
- Observable symptom 1
- Observable symptom 2
- Alert: [Alert name if applicable]

**Severity**: [P0 | P1 | P2 | P3]

**Diagnosis**:
```bash
# Check 1: Description
command --status

# Check 2: Description
command --logs | grep ERROR

# Check 3: Description
command --health-check
```

**Root Causes** (most common first):
1. **Cause 1**: Description
   - **Fix**: Steps to resolve
   - **Prevention**: How to prevent in future

2. **Cause 2**: Description
   - **Fix**: Steps to resolve
   - **Prevention**: How to prevent in future

**Resolution Steps**:
```bash
# Step 1: Stop the affected service
systemctl stop service-name

# Step 2: Clear problematic state
rm -rf /path/to/cache/*

# Step 3: Restart service
systemctl start service-name

# Step 4: Verify resolution
curl http://localhost:8080/health
```

**Escalation**:
If issue persists after 30 minutes:
- Contact: [Name/Team]
- Slack channel: #channel-name
- On-call rotation: [PagerDuty/link]

---

### Issue 2: [Symptom]

**Symptoms**:
- Observable symptom 1
- Observable symptom 2

**Severity**: [P0 | P1 | P2 | P3]

**Diagnosis**:
```bash
# Commands to diagnose
```

**Root Causes**:
1. **Cause 1**: Description
   - **Fix**: Steps
   - **Prevention**: Steps

**Resolution Steps**:
```bash
# Commands to resolve
```

**Escalation**:
- Contact: [Name/Team]

---

## Emergency Procedures

### Emergency 1: Complete Service Outage

**When**: Service is completely down, no requests succeeding

**Severity**: P0

**Immediate Actions** (within 5 minutes):
1. **Alert stakeholders**: Post in #incidents channel
2. **Check status**: Run health checks on all components
3. **Initial assessment**: Identify failed component

**Steps**:
```bash
# 1. Check all service components
kubectl get pods -n production

# 2. Check recent deployments
kubectl rollout history deployment/service-name

# 3. Check resource usage
kubectl top pods -n production

# 4. Review recent logs
kubectl logs -n production deployment/service-name --tail=100
```

**Common Causes & Fixes**:

1. **Recent deployment failed**:
   ```bash
   # Rollback to previous version
   kubectl rollout undo deployment/service-name

   # Verify rollback
   kubectl rollout status deployment/service-name
   ```

2. **Database connection pool exhausted**:
   ```bash
   # Restart service to reset connections
   kubectl rollout restart deployment/service-name
   ```

3. **Dependency service down**:
   ```bash
   # Check dependency status
   curl http://dependency-service/health

   # Enable circuit breaker if available
   kubectl set env deployment/service-name CIRCUIT_BREAKER=true
   ```

**Recovery Verification**:
- [ ] Health check returns 200 OK
- [ ] Metrics show normal traffic
- [ ] Error rate below 0.1%
- [ ] Latency within SLA

**Post-Incident**:
- [ ] Update #incidents with resolution
- [ ] Schedule postmortem meeting
- [ ] Create Linear issue for root cause fix
- [ ] Update this runbook if needed

---

### Emergency 2: Performance Degradation

**When**: Service responding slowly but not down

**Severity**: P1

**Immediate Actions**:
1. **Check metrics**: CPU, memory, disk, network
2. **Identify bottleneck**: Database, external API, resource limit
3. **Apply temporary fix**: Scale up, enable caching, rate limiting

**Steps**:
```bash
# Check resource usage
kubectl top pods -n production

# Scale up if needed (temporary)
kubectl scale deployment/service-name --replicas=10

# Check database performance
psql -c "SELECT * FROM pg_stat_activity WHERE state = 'active';"

# Enable aggressive caching (if available)
redis-cli CONFIG SET maxmemory-policy allkeys-lru
```

**Recovery Verification**:
- [ ] Latency back to normal (<100ms p95)
- [ ] CPU/Memory usage stable
- [ ] No queuing/backlog

---

## Monitoring & Alerts

### Key Dashboards

1. **Main Service Dashboard**: [URL]
   - Request rate, latency, error rate
   - Resource usage (CPU, memory, disk)
   - Dependency health

2. **Database Dashboard**: [URL]
   - Query performance
   - Connection pool status
   - Slow queries

3. **Infrastructure Dashboard**: [URL]
   - Node health
   - Network metrics
   - Storage usage

### Alert Definitions

| Alert | Condition | Severity | Action |
|-------|-----------|----------|--------|
| Service Down | Health check fails for 2 minutes | P0 | Follow "Complete Service Outage" |
| High Error Rate | Error rate > 1% for 5 minutes | P1 | Check logs, recent deploys |
| High Latency | p95 > 200ms for 10 minutes | P1 | Follow "Performance Degradation" |
| High Memory | Memory > 90% for 15 minutes | P2 | Investigate memory leak |
| Disk Space Low | Disk > 80% full | P2 | Clean up logs, expand disk |

### Where to Look

**Logs**:
```bash
# Application logs
kubectl logs -n production deployment/service-name -f

# Specific time range
kubectl logs -n production deployment/service-name --since=1h

# Previous container (after crash)
kubectl logs -n production pod-name --previous
```

**Metrics**:
```bash
# Prometheus queries
rate(http_requests_total[5m])
histogram_quantile(0.95, http_request_duration_seconds)

# CloudWatch (if using AWS)
aws cloudwatch get-metric-statistics --namespace "Service/Name" \
  --metric-name Latency --statistics Average --period 300
```

**Tracing**:
- Jaeger/Zipkin: [URL]
- Find slow requests by trace ID
- Identify bottleneck spans

---

## Deployment Procedures

### Standard Deployment

**Prerequisites**:
- [ ] All tests passing in CI
- [ ] Code review approved
- [ ] Staging deployment successful
- [ ] Change request approved (if required)

**Deployment Steps**:
```bash
# 1. Announce deployment
# Post in #deployments channel

# 2. Create deployment branch
git checkout -b deploy/YYYY-MM-DD-service-name

# 3. Tag release
git tag -a v1.2.3 -m "Release v1.2.3"
git push origin v1.2.3

# 4. Deploy to production
./scripts/deploy.sh production v1.2.3

# 5. Monitor deployment
kubectl rollout status deployment/service-name -n production

# 6. Verify health
./scripts/health-check.sh production

# 7. Monitor metrics for 15 minutes
# Watch dashboard: [URL]
```

**Verification**:
- [ ] Deployment completed successfully
- [ ] Health checks passing
- [ ] Metrics stable (latency, errors, traffic)
- [ ] No new errors in logs
- [ ] Smoke tests passing

**Rollback** (if issues detected):
```bash
# Immediate rollback
kubectl rollout undo deployment/service-name -n production

# Or rollback to specific version
./scripts/deploy.sh production v1.2.2

# Verify rollback
kubectl rollout status deployment/service-name -n production
```

---

### Hotfix Deployment

**When**: Critical bug in production requiring immediate fix

**Severity**: P0/P1

**Prerequisites**:
- [ ] Bug confirmed and reproduced
- [ ] Fix developed and tested
- [ ] On-call engineer notified

**Fast-Track Steps**:
```bash
# 1. Create hotfix branch from production tag
git checkout v1.2.3
git checkout -b hotfix/critical-bug-fix

# 2. Apply fix and commit
git add .
git commit -m "hotfix(LIN-XXX): fix critical bug"

# 3. Tag hotfix
git tag -a v1.2.4 -m "Hotfix: critical bug"
git push origin v1.2.4

# 4. Deploy immediately
./scripts/deploy.sh production v1.2.4 --fast-track

# 5. Monitor closely
# Watch for 30 minutes
```

**Verification**:
- [ ] Bug no longer reproduces
- [ ] No new errors introduced
- [ ] Metrics stable

**Follow-up**:
- [ ] Merge hotfix to main branch
- [ ] Create postmortem
- [ ] Update tests to catch this bug
- [ ] Schedule preventive measures

---

## Maintenance Procedures

### Routine Maintenance

**Weekly**:
- [ ] Review error logs for patterns
- [ ] Check disk space usage
- [ ] Verify backup integrity
- [ ] Review slow queries

**Monthly**:
- [ ] Security patches applied
- [ ] Dependency updates reviewed
- [ ] Performance baseline reassessed
- [ ] Runbook accuracy verified

**Quarterly**:
- [ ] Disaster recovery drill executed
- [ ] Capacity planning review
- [ ] SLA compliance review
- [ ] Documentation audit

---

### Database Maintenance

**Backup Verification**:
```bash
# Check latest backup
./scripts/check-backup.sh

# Test restore (in non-prod)
./scripts/restore-backup.sh staging latest
```

**Performance Tuning**:
```sql
-- Find slow queries
SELECT query, mean_exec_time, calls
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;

-- Vacuum and analyze
VACUUM ANALYZE;

-- Reindex if needed
REINDEX DATABASE dbname;
```

---

## Capacity Planning

### Current Capacity
- **Max RPS**: X requests/second
- **Max Concurrent Users**: Y users
- **Database Connections**: Z connections
- **Storage**: W GB used of X GB total

### Scaling Thresholds
- **Scale up horizontally**: When CPU > 70% for 10 minutes
- **Scale up database**: When connections > 80% of pool
- **Add storage**: When disk > 75% full

### Scaling Procedures

**Horizontal Scaling**:
```bash
# Increase replicas
kubectl scale deployment/service-name --replicas=15 -n production

# Verify scaling
kubectl get pods -n production -l app=service-name
```

**Vertical Scaling**:
```bash
# Update resource limits
kubectl set resources deployment/service-name \
  --limits=cpu=2000m,memory=4Gi \
  -n production

# Rolling update will apply changes
kubectl rollout status deployment/service-name -n production
```

---

## Security Procedures

### Credential Rotation

**Database Credentials**:
```bash
# 1. Generate new credentials
./scripts/generate-db-creds.sh

# 2. Update in secrets manager
aws secretsmanager update-secret --secret-id db-creds \
  --secret-string "$(cat new-creds.json)"

# 3. Restart services to pick up new creds
kubectl rollout restart deployment/service-name -n production

# 4. Revoke old credentials after 24h
```

**API Keys**:
```bash
# 1. Generate new API key
./scripts/generate-api-key.sh

# 2. Update dependent services
./scripts/update-api-key.sh

# 3. Monitor for errors
# Watch logs for auth failures

# 4. Revoke old key after verification
```

---

### Security Incident Response

**If security breach suspected**:

1. **Isolate** (within 15 minutes):
   ```bash
   # Disable external access
   kubectl scale deployment/service-name --replicas=0 -n production

   # Or block at load balancer
   ./scripts/block-external-access.sh
   ```

2. **Preserve Evidence**:
   ```bash
   # Capture logs
   kubectl logs -n production deployment/service-name --all-containers > incident-logs.txt

   # Snapshot volumes
   ./scripts/snapshot-volumes.sh
   ```

3. **Notify**:
   - Security team: security@company.com
   - Incident commander: [Name]
   - Legal (if customer data): legal@company.com

4. **Investigate**: Follow security incident playbook

5. **Recover**: Only after security team approval

---

## Disaster Recovery

### Backup Strategy
- **Frequency**: Hourly incremental, daily full
- **Retention**: 30 days
- **Location**: S3 bucket in separate region
- **Encryption**: AES-256

### Recovery Time Objectives (RTO)
- **Database**: 1 hour
- **Application**: 30 minutes
- **Full system**: 2 hours

### Recovery Point Objectives (RPO)
- **Database**: 1 hour (last backup)
- **Logs**: 5 minutes (near real-time)

### Disaster Recovery Steps

**Complete Region Failure**:
```bash
# 1. Activate disaster recovery plan
./scripts/activate-dr.sh --region us-west-2

# 2. Restore database from backup
./scripts/restore-db.sh --backup latest --region us-west-2

# 3. Deploy application to DR region
./scripts/deploy.sh production latest --region us-west-2

# 4. Update DNS to point to DR region
./scripts/update-dns.sh --region us-west-2

# 5. Verify all services operational
./scripts/health-check.sh --region us-west-2
```

**Recovery Verification**:
- [ ] All services responding
- [ ] Database queries working
- [ ] Metrics flowing
- [ ] Users can access system
- [ ] Data integrity verified

---

## Dependencies

### Internal Dependencies
| Service | Purpose | Contact | Runbook |
|---------|---------|---------|---------|
| Service A | Authentication | Team A | [Link] |
| Service B | Data storage | Team B | [Link] |

### External Dependencies
| Service | Purpose | SLA | Support |
|---------|---------|-----|---------|
| AWS | Infrastructure | 99.99% | support@aws.com |
| Stripe | Payments | 99.9% | support@stripe.com |

### Dependency Health Checks
```bash
# Check all dependencies
./scripts/check-dependencies.sh

# Individual checks
curl https://service-a.internal/health
curl https://api.stripe.com/v1/health
```

---

## Contacts & Escalation

### Primary Contacts
- **On-Call Engineer**: [PagerDuty rotation]
- **Team Lead**: [Name] - [Email/Slack]
- **Product Owner**: [Name] - [Email/Slack]

### Escalation Path

**P0 - Critical Outage**:
1. On-Call Engineer (immediate)
2. Team Lead (after 15 minutes)
3. Engineering Manager (after 30 minutes)
4. CTO (after 1 hour)

**P1 - Major Issue**:
1. On-Call Engineer (immediate)
2. Team Lead (after 30 minutes)
3. Engineering Manager (after 2 hours)

**P2/P3 - Minor Issues**:
1. On-Call Engineer
2. Handle during business hours

### Communication Channels
- **Incidents**: #incidents (Slack)
- **Deployments**: #deployments (Slack)
- **Team**: #team-name (Slack)
- **Status Page**: [URL]

---

## Related Documents

### Specifications
- [LIN-XXX: Feature Spec](/docs/specs/LIN-XXX-feature.md)

### ADRs
- [ADR-XXX: Architecture Decision](/docs/adrs/XXX-decision.md)

### Other Runbooks
- [Runbook: Related Service](/docs/runbooks/related-service.md)

### External Documentation
- [Service documentation]
- [API documentation]
- [Infrastructure documentation]

---

## Changelog

| Date | Author | Changes |
|------|--------|---------|
| YYYY-MM-DD | [Name] | Initial runbook |
| YYYY-MM-DD | [Name] | Added new troubleshooting section |
| YYYY-MM-DD | [Name] | Updated scaling procedures |

---

## Appendix

### Useful Commands Reference
```bash
# Quick health check
curl http://localhost:8080/health

# Tail logs
kubectl logs -f deployment/service-name -n production

# Check resource usage
kubectl top pods -n production

# Describe pod for events
kubectl describe pod pod-name -n production

# Execute command in pod
kubectl exec -it pod-name -n production -- /bin/bash
```

### Configuration Files
- **Location**: `/etc/service-name/config.yaml`
- **Environment Variables**: See `.env.example`
- **Secrets**: Stored in AWS Secrets Manager

### Testing Procedures
```bash
# Run smoke tests
./scripts/smoke-tests.sh production

# Load testing
./scripts/load-test.sh --rps 1000 --duration 5m

# Chaos testing
./scripts/chaos-test.sh --kill-random-pod
```
