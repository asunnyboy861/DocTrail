# Pricing Configuration

## Monetization Model: Subscription (IAP)

## Subscription Group
- **Group Name**: DocTrail Premium
- **Group ID**: DocTrail_Premium

## Subscription Tiers

### 1. Monthly Subscription
- **Reference Name**: Monthly Pro
- **Product ID**: `com.zzoutuo.DocTrail.monthly`
- **Price**: $4.99 per month
- **Display Name**: DocTrail Pro Monthly
- **Description**: Full version control for your team
- **Localization**: English (US)

### 2. Yearly Subscription
- **Reference Name**: Yearly Pro
- **Product ID**: `com.zzoutuo.DocTrail.yearly`
- **Price**: $39.99 per year (33% savings vs monthly)
- **Display Name**: DocTrail Pro Yearly
- **Description**: Best value for team version control
- **Localization**: English (US)

### 3. Team Monthly Subscription
- **Reference Name**: Team Monthly
- **Product ID**: `com.zzoutuo.DocTrail.teamMonthly`
- **Price**: $9.99 per month
- **Display Name**: DocTrail Team Monthly
- **Description**: Team collaboration with shared docs
- **Localization**: English (US)

### 4. Team Yearly Subscription
- **Reference Name**: Team Yearly
- **Product ID**: `com.zzoutuo.DocTrail.teamYearly`
- **Price**: $79.99 per year (33% savings vs monthly)
- **Display Name**: DocTrail Team Yearly
- **Description**: Best value for team collaboration
- **Localization**: English (US)

### 5. Lifetime Purchase
- **Reference Name**: Lifetime Access
- **Product ID**: `com.zzoutuo.DocTrail.lifetime`
- **Price**: $99.99 one-time
- **Display Name**: DocTrail Lifetime
- **Description**: Own it forever, no subscription
- **Localization**: English (US)

## Free Trial
- **Duration**: 7 days
- **Type**: Free trial (auto-converts to paid)
- **Applies to**: Monthly and Yearly Pro subscriptions

## Free Tier Features
- Track up to 5 documents
- Up to 10 versions per document
- Local storage only
- Basic search

## Pro Tier Features (Monthly/Yearly)
- Unlimited documents
- Unlimited version history
- iCloud sync across devices
- Advanced diff comparison
- Tags and smart search
- Version restore

## Team Tier Features (Team Monthly/Yearly)
- Everything in Pro
- Team sharing (up to 10 members)
- CloudKit shared database
- Document locking
- Activity feed
- Permission management
- Push notifications

## Policy Pages Required
- Support Page: ✅ (Must include subscription management info)
- Privacy Policy: ✅
- Terms of Use: ✅ (REQUIRED for subscription apps)

## Apple IAP Compliance Checklist
- [ ] Auto-renewal terms included in Terms
- [ ] Cancellation instructions included
- [ ] Pricing clearly stated
- [ ] Free trial terms included
- [ ] Restore purchases functionality implemented
