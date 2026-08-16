# ICM: Albatross — DORA Compliance Workflow

## Context
DORA (Digital Operational Resilience Act) Article 19 requires financial institutions to report incidents in 3 phases: 4h, 72h, 30d.

## Components
- `dora_classifier.lua` — 7-criteria classification (RTS 2024/1772)
- `dora_timeline.lua` — 3-phase timeline engine
- `dora_register.lua` — Register of Information (ITS 2024/2956)
- `dora_sbom_ingest.lua` — Vendor SBOM ingestion (Art.28)
- `dora_evidence.lua` — Evidence bundle generator

## Usage
luajit test_classifier.lua
luajit test_timeline.lua
luajit test_albatross_full.lua


## Regulatory References
- DORA Article 19: Incident reporting
- RTS 2024/1772: Classification criteria
- ITS 2024/2956: Register of Information
