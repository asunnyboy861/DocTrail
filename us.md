# DocTrail - iOS Development Guide

## Executive Summary

DocTrail is a simple version control app designed for small business teams (2-10 people) who are drowning in "Final_v3_USE_THIS_ONE" file chaos. Unlike SharePoint (too complex) or Dropbox (too basic), DocTrail sits in the sweet spot: simple enough for non-technical users, powerful enough for real team collaboration.

**Product Vision**: Eliminate version confusion for small teams by providing an intuitive, native iOS/macOS document version control system with iCloud sync, conflict resolution, and audit trails.

**Target Audience**: US-based B2B small business teams (2-10 people) — office managers, project coordinators, legal assistants, accountants who share documents daily.

**Key Differentiators**:
- Native Apple experience (not a web wrapper)
- Simple enough for non-technical users (no Git knowledge required)
- Built-in conflict resolution (not just "last write wins")
- Audit trail for compliance (who changed what, when)
- Offline-first with iCloud sync

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| SharePoint/OneDrive | Enterprise-grade, deep Microsoft integration | Overwhelming complexity, steep learning curve, poor iOS experience | Simple, native iOS, no training needed |
| Google Drive | Universal, real-time collaboration | Limited version history (100 versions max), no approval workflow, requires internet | Offline-first, unlimited versions, audit trail |
| Simul Docs | Excellent Word version control | Word-only, no native iOS app, expensive ($15-40/user/mo) | All file types, native iOS, affordable |
| Dropbox | Simple file sharing, widespread adoption | Version history only 30 days (free), poor conflict resolution, no audit trail | Full version history, smart conflict resolution, built-in audit |
| Working Copy | Powerful Git client, 4.9 rating | Developer-focused, non-technical users cannot use it | Non-technical user friendly, no Git knowledge needed |
| Versions (macOS) | Clean macOS version tracking | macOS only, no collaboration, no iOS version | Cross-platform Apple, team collaboration, iCloud sync |

## Apple Design Guidelines Compliance

- **Navigation**: Tab-based navigation with sidebar adaptability on iPad, following HIG Navigation patterns
- **Color System**: Using Apple system colors (Blue, Purple, Green, Orange, Red) for semantic meaning
- **Typography**: SF Pro system font with Dynamic Type support
- **Haptics**: UIImpactFeedbackGenerator for version actions, UINotificationFeedbackGenerator for alerts
- **Dark Mode**: Full support with OLED-friendly pure black background
- **Privacy**: All data stored locally first, iCloud sync opt-in, no third-party analytics
- **Accessibility**: VoiceOver labels on all interactive elements, minimum 44pt touch targets

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), @Observable macro for state management
- **Data**: SwiftData for document metadata, FileManager for version file storage
- **Sync**: CloudKit (private + shared database) for team collaboration
- **Security**: CryptoKit for file hashing, Data Protection for local storage
- **Search**: NSUserActivity + Core Spotlight for system-level search
- **Networking**: URLSession for feedback submission
- **Monetization**: StoreKit 2 for subscriptions

## Module Structure

```
DocTrail/
├── DocTrailApp.swift
├── Core/
│   ├── VersionEngine/
│   │   ├── VersionStore.swift
│   │   ├── DocVersion.swift
│   │   ├── ChangeItem.swift
│   │   └── DiffEngine.swift
│   ├── SyncEngine/
│   │   ├── CloudKitSync.swift
│   │   ├── ConflictResolver.swift
│   │   └── SyncStatus.swift
│   ├── DocumentEngine/
│   │   ├── DocumentManager.swift
│   │   ├── FileWatcher.swift
│   │   └── MetadataExtractor.swift
│   └── CollaborationEngine/
│       ├── TeamManager.swift
│       ├── PermissionManager.swift
│       └── ActivityFeed.swift
├── Features/
│   ├── DocumentList/
│   │   ├── DocumentListView.swift
│   │   └── DocumentListViewModel.swift
│   ├── VersionHistory/
│   │   ├── VersionTimelineView.swift
│   │   └── VersionHistoryViewModel.swift
│   ├── DiffViewer/
│   │   ├── DiffViewerView.swift
│   │   └── DiffViewerViewModel.swift
│   ├── TeamSharing/
│   │   ├── TeamSharingView.swift
│   │   └── TeamSharingViewModel.swift
│   ├── SearchAndTag/
│   │   ├── SearchView.swift
│   │   └── SearchViewModel.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   └── ContactSupportView.swift
│   └── Paywall/
│       ├── PaywallView.swift
│       └── PurchaseManager.swift
├── UI/
│   ├── Components/
│   │   ├── VersionBadge.swift
│   │   ├── SyncIndicator.swift
│   │   └── EmptyStateView.swift
│   ├── Theme/
│   │   └── AppTheme.swift
│   └── Extensions/
│       ├── Color+App.swift
│       └── Date+Relative.swift
└── Resources/
    └── Assets.xcassets/
```

## Implementation Flow

1. Set up SwiftData models (DocVersion, ChangeItem, DocumentRecord)
2. Build VersionEngine core (create, restore, diff versions)
3. Build DocumentManager (import, organize, metadata)
4. Build DocumentListView (main screen with search and tags)
5. Build VersionTimelineView (version history with timeline UI)
6. Build DiffViewerView (side-by-side comparison)
7. Build SettingsView with policy links and contact support
8. Build PaywallView with StoreKit 2 integration
9. Implement CloudKit sync engine
10. Implement Spotlight search integration
11. Add haptic feedback and animations
12. Test on iPhone and iPad simulators

## UI/UX Design Specifications

- **Color Scheme**: Apple system colors — Blue (#007AFF) primary, Purple (#5856D6) for versions, Green (#34C759) for latest, Orange (#FF9500) for warnings, Red (#FF3B30) for errors
- **Typography**: SF Pro, headline for titles, body for content, caption for metadata
- **Layout**: Card-based document list, timeline for version history, split view for diff comparison
- **iPad Layout**: Sidebar navigation with content area, max width 720pt for content, full-width diff viewer
- **Animations**: Spring transitions (damping 0.85) for navigation, easeOut for list items, easeInOut for diff highlights
- **Dark Mode**: Pure black (#000000) background, secondary background (#1C1C1E) for cards, OLED-friendly

## Code Generation Rules

- Use SwiftUI with @Observable macro (iOS 17+)
- MVVM pattern: View + ViewModel per feature
- SwiftData for persistence with proper @Model classes
- All SwiftData attributes must be optional or have default values
- All relationships must have inverse relationships
- Actor-based concurrency for engine classes
- No force unwraps, no implicitly unwrapped optionals
- No comments in code unless explicitly requested
- Use CryptoKit SHA256 for file hashing
- Use StoreKit 2 for all IAP operations
- Use CloudKit async/await APIs

## Build & Deployment Checklist

1. Verify Bundle ID: com.zzoutuo.DocTrail
2. Verify Deployment Target: iOS 17.0
3. Configure iCloud capability in Xcode
4. Configure CloudKit container
5. Add StoreKit Configuration file for testing
6. Generate app icon using Wanxiang API
7. Build and test on iPhone simulator
8. Build and test on iPad simulator
9. Push to GitHub repository
10. Deploy policy pages to GitHub Pages
11. Prepare App Store Connect metadata
12. Generate App Store screenshots
