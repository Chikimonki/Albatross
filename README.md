# Albatross — DORA Compliance Workflow

![Zig](https://img.shields.io/badge/Zig-1.0.0-orange?style=for-the-badge) ![LuaJIT](https://img.shields.io/badge/LuaJIT-2.1-green?style=for-the-badge)

Open-source DORA (Digital Operational Resilience Act) compliance support for financial institutions.

## What It Does

| Component | Description | Status |
|-----------|-------------|--------|
| Classification Engine | 7-criteria incident classification (RTS 2024/1772) | ✅ |
| 3-Phase Timeline | Article 19 reporting: 4h / 72h / 30d | ✅ |
| Register of Information | ITS 2024/2956 xBRL-CSV generator | ✅ |
| Vendor SBOM Ingestion | Third-party component tracking (Art.28) | ✅ |
| Evidence Bundle | Audit-ready documentation generator | ✅ |

## Quick Start

```bash
# Test the classifier
luajit test_classifier.lua

# Test the timeline
luajit test_timeline.lua

# Test the full suite
luajit test_albatross_full.lua
```

Use Case: Built for the post-digitisation financial system. When Euroclear digitised the €15T Eurobond market in March 2025, millions of parties needed automated regulatory compliance. Albatross provides the DORA workflow layer.

License: MIT

## Footer

[](https://github.com)© 2026 GitHub, Inc.