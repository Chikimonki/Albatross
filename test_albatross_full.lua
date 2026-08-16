package.path = "/mnt/d/albatross/src/?.lua;" .. package.path

local DORARegister = require("dora_register")
local DORASBOM = require("dora_sbom_ingest")
local DORAEvidence = require("dora_evidence")
local DORAClassifier = require("dora_classifier")
local DORATimeline = require("dora_timeline")

print("=== Albatross Full Test ===\n")

-- Test Register
print("1. Register of Information:")
DORARegister.add_provider({
    name = "CloudProvider XYZ",
    function_type = "Cloud Hosting",
    criticality = "CRITICAL",
    data_locations = {"EU", "US"},
    sub_outsourcing = true,
})
local summary = DORARegister.summary()
print(string.format("   ✓ %d providers (%d critical)", summary.total_providers, summary.critical_providers))
print()

-- Test SBOM ingestion
print("2. Vendor SBOM Ingestion:")
local sbom = DORASBOM.ingest("Vendor ABC", {
    components = {
        {name = "payment-gateway", version = "2.1.0", licenses = {"Apache-2.0"}},
        {name = "auth-module", version = "1.0.5", licenses = {"MIT"}},
    },
})
print(string.format("   ✓ Ingested %d components", #sbom.components))
print()

-- Test Evidence bundle
print("3. Evidence Bundle:")
local bundle = DORAEvidence.create_bundle({
    name = "Payment Processing",
    ict_systems = {"mainframe-pay", "api-gateway"},
    third_parties = {"Vendor ABC", "CloudProvider XYZ"},
})
print(string.format("   ✓ Bundle created with %d evidence items", #bundle.evidence))
print()

print("=== Albatross Complete ===")
