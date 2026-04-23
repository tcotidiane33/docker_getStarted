# ADR 001: Choice of AWS as Cloud Provider

## Status
Accepted

## Context
We need a scalable, reliable, and globally available cloud provider to host our application infrastructure. The team has prior experience with AWS.

## Decision
We have decided to use **Amazon Web Services (AWS)** as our primary cloud provider.

## Consequences
### Positive
- Extensive service offering (EKS, RDS, etc.) matches our needs.
- Team familiarity reduces learning curve.
- Mature ecosystem for IaC tools (Terraform provider is very stable).

### Negative
- Vendor lock-in risk (mitigated by using Terraform and Kubernetes).
- Cost management can be complex.
