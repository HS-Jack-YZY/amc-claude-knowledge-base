# How AMC Works

## Access Methods

AMC can be accessed through two interfaces:

1. **AMC Web UI** — a browser-based interface for writing and executing queries, viewing results, and managing workflows
2. **Amazon Ads API** — programmatic access for automation, including instance management, workflow execution, audience creation, and reporting

## Gaining Access

- **Self-service advertisers** — instant access is available for advertisers who use Amazon DSP or Sponsored Ads
- **Multi-advertiser access** — agencies and tool providers can gain access for multiple advertiser accounts by working with their AdTech Account Executive (AE)

## AMC Accounts and Instances

AMC uses a hierarchy of **accounts** and **instances**:

- An **AMC account** represents your organization's access to AMC
- Each account can contain one or more **AMC instances**
- Each instance is associated with a specific **advertiser entity ID** and **marketplace**
- Instances contain the event-level data for that advertiser/marketplace combination

### Instance Types

| Type | Description |
|------|-------------|
| **Standard** | Production instance with real advertiser data. Contains Amazon-owned signals (DSP, Sponsored Ads, conversions) plus any advertiser-uploaded data. |
| **Sandbox** | Test instance for query development. Contains synthetic data that mimics real data structure. No cost for queries. |
| **Collaboration (AWS Clean Rooms)** | Advanced instance type that enables data collaboration between multiple parties using AWS Clean Rooms integration. |

## Data in Instances

### Amazon-Owned Data
- Automatically populated with **13 months of historical data** (backfill) upon instance creation
- Continuously updated with new event data as campaigns run
- Includes: DSP impressions/clicks/views, Sponsored Ads traffic, conversions, and more (see [Table Index](../README.md#table-index))

### Advertiser-Uploaded Data
- Advertisers can upload their own first-party data (e.g., CRM data, offline conversions, website events)
- Uploaded data is matched against Amazon's pseudonymized user identifiers
- Enables cross-channel analysis combining Amazon signals with advertiser-owned signals

### Exception: Amazon Retail Purchases (ARP)
- Contains **60 months** (5 years) of purchase history — significantly more than the standard 13 months
- See [ARP notes](../README.md#amazon-retail-purchases-arp-notes) for caveats when joining with other datasets

## Queries

### AMC SQL
- Queries are written in **AMC SQL**, a SQL dialect with specific functions and limitations
- See the [SQL Reference](../sql_reference/overview.md) for detailed language documentation

### Aggregation Thresholds
- All query results must meet minimum aggregation thresholds before data is returned
- This ensures privacy by preventing identification of individual users
- See [Aggregation Threshold Guide](aggregation_threshold.md) for full details

### Workflow Management
- Queries are managed as **workflows** — reusable query templates with configurable parameters
- Workflows are executed with a specific **time window** (date range)
- Execution is asynchronous: submit a workflow, then poll or wait for results

## Getting Results

Query results can be retrieved in two ways:

1. **Download URL** — a temporary, signed URL to download the result file (CSV format)
2. **S3 Bucket** — results are delivered directly to a configured Amazon S3 bucket

## Privacy Safeguards

- All data within AMC is **pseudonymized** — there are no personally identifiable identifiers
- **Raw user-level data cannot be exported** — only aggregated results that meet threshold requirements
- Aggregation thresholds ensure that results represent a sufficient number of users
- The clean room architecture prevents data from being moved outside the secure environment
