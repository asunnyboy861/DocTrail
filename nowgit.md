# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | DocTrail |
| **Git URL** | git@github.com:asunnyboy861/DocTrail.git |
| **Repo URL** | https://github.com/asunnyboy861/DocTrail |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/DocTrail/ | ✅ Active |
| Support | https://asunnyboy861.github.io/DocTrail/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/DocTrail/privacy.html | ✅ Active |
| Terms of Use | https://asunnyboy861.github.io/DocTrail/terms.html | ✅ Active |

**Note**: Terms of Use required for IAP subscription apps.

## Repository Structure

### Main App Repository
```
DocTrail/
├── DocTrail/                            # iOS App Source Code
│   ├── DocTrail.xcodeproj/              # Xcode Project
│   ├── DocTrail/                        # Swift Source Files
│   │   ├── Core/
│   │   │   ├── VersionEngine/
│   │   │   └── DocumentEngine/
│   │   ├── Features/
│   │   │   ├── MainTabView.swift
│   │   │   ├── DocumentList/
│   │   │   ├── VersionHistory/
│   │   │   ├── DiffViewer/
│   │   │   ├── Paywall/
│   │   │   ├── Activity/
│   │   │   └── Settings/
│   │   └── UI/
│   │       └── Extensions/
│   └── ...
├── docs/                                # Policy Pages (GitHub Pages)
│   ├── index.html
│   ├── support.html
│   ├── privacy.html
│   └── terms.html
├── us.md                                # English Development Guide
├── keytext.md                           # App Store Metadata
├── capabilities.md                      # Capabilities Configuration
├── icon.md                              # App Icon Details
├── price.md                             # Pricing Configuration
└── nowgit.md                            # This File
```
