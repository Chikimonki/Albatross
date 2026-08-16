package.path = "/mnt/d/albatross/src/?.lua;" .. package.path

local DORATimeline = require("dora_timeline")
local DORAClassifier = require("dora_classifier")

print("=== DORA 3-Phase Timeline Test ===")
print()

-- Create a major incident
local incident = {
    name = "Payment system outage",
    clients_affected_pct = 15,
    duration_hours = 36,
    member_states = 3,
    critical_downtime_hours = 4,
    economic_impact_eur = 500000,
    reputational_impact = "severe",
}

-- Create timeline
local timeline = DORATimeline.create(incident)

-- Classify
local classification, scores = DORAClassifier.classify(incident)
DORATimeline.classify(timeline, classification, scores)

-- Show the report
print(DORATimeline.report(timeline))
print()

-- Demonstrate the 24h outer cap
print("=== Clock Subtlety ===")
print("DORA Rule: If classification takes 20h, initial is due in 4h (not 24h from classification).")
print("Because the 24h awareness cap burns first.")
print()

-- Submit initial
print("Submitting initial notification...")
DORATimeline.submit(timeline, "initial")
print(DORATimeline.report(timeline))
print()

print("=== Timeline Test Complete ===")
