

# CASE STUDY: BrightTV (Viewership Analytics)

## Overview
BrightTV is a subscription-based streaming service aiming to grow its subscriber base and overall content consumption this financial year. 
The CEO tasked the CVM (Customer Value Management) team to identify insights that can drive growth and retention.
This case study analyzes user profile and session-level viewing data to understand trends, drivers of consumption, and opportunities to increase engagement and subscriptions.

## Case Study Objective
The goal of this analysis is to support BrightTV’s CVM team by:
1. **Understanding user and usage trends** across the platform
2. **Identifying key factors that influence content consumption**
3. **Recommending content strategies** to boost engagement on low-consumption days
4. **Proposing initiatives** to grow BrightTV’s user base and reduce churn

The final output was a 20-minute presentation backed by interactive dashboards.

## Dataset Notes
The dataset provided contains:
- **User Profiles**: Demographics, subscription type, device, location, signup date
- **Viewer Transactions**: Session-level data including user_id, start_time, end_time, content_id, content_type, duration

Important notes:
- **Time**: All timestamps were supplied in UTC and converted to South Africa Time (UTC+2)
- **Granularity**: 1 record = 1 viewing session per subscriber
- **Data Quality**: Duplicates removed, null session durations handled, outliers in session length capped
- **Enrichment**: Joined with content metadata and public holiday calendar for context

## Tools and Technologies Used
- **Excel**
- **PowerBI**
- **Google Data Studio**
- **Databricks**
- **Lovable**
  

## Key Insights
### 1. User and Usage Trends
- Peak viewing occurs between **18:00 - 21:00 SAST** on weekdays and **14:00 - 22:00** on weekends
- **Smart TV** users: Longest session duration. **Mobile** users: Highest frequency, shortest sessions
- Top 20% of subscribers account for ~60% of total watch time

### 2. Factors Influencing Consumption
- **Time of Day**: Evening primetime drives 3x more consumption than 06:00-12:00
- **Content Type**: Local dramas, live sports, and reality shows have highest completion rates
- **Day of Week**: Tue/Wed show a 18-22% dip in sessions vs Fri-Sun
- **Device + Internet**: Mobile consumption drops during load shedding hours

### 3. Content Recommendations for Low Consumption Days
- Drop **new episodes of local series** every Tuesday to create a mid-week habit
- Schedule **family/kids content blocks** 15:00-17:00 on weekdays
- Push **sports replays + highlights** on Wed evenings to recover traffic

### 4. Initiatives to Grow User Base 
- **Referral Program**: "Invite a friend, both get 1 month free" - tracked via dashboard
- **Personalized Home Screen**: Use viewing history to recommend similar content
- **Data-Free Bundles**: Partner with mobile networks for zero-rated streaming
- **Churn Win-back**: Automated email/SMS with "We miss you + new shows for you"



https://brighttv-pulse.lovable.app


