package.path = "/mnt/d/albatross/src/?.lua;" .. package.path

local DORAClassifier = require("dora_classifier")

print("=== DORA Classification Test ===")
print()

local test_incidents = {
    {
        name = "Major: multi-state, high impact",
        clients_affected_pct = 15,
        duration_hours = 36,
        member_states = 3,
        data_loss_pct = 25,
        critical_downtime_hours = 4,
        economic_impact_eur = 500000,
        reputational_impact = "severe",
    },
    {
        name = "Minor: single state, low impact",
        clients_affected_count = 50,
        duration_hours = 3,
        member_states = 1,
        economic_impact_eur = 5000,
        reputational_impact = "minor",
    },
    {
        name = "Significant: critical function down",
        clients_affected_pct = 5,
        duration_hours = 8,
        member_states = 1,
        critical_downtime_hours = 3,
        economic_impact_eur = 50000,
        reputational_impact = "significant",
    },
}

for _, incident in ipairs(test_incidents) do
    local classification, scores = DORAClassifier.classify(incident)
    print(string.format("%s:", incident.name))
    print(string.format("  → %s", classification))
    print()
end

print("=== Complete ===")
