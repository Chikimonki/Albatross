-- dora_evidence.lua — DORA evidence bundle generator (D4)
local DORAEvidence = {
    bundles = {},
}

-- Create an evidence bundle for a critical function
function DORAEvidence.create_bundle(critical_function)
    local bundle = {
        function_name = critical_function.name or "Unknown",
        created_at = os.time(),
        evidence = {},
    }
    
    -- Add evidence items
    if critical_function.ict_systems then
        for _, system in ipairs(critical_function.ict_systems) do
            table.insert(bundle.evidence, {
                type = "ICT_SYSTEM",
                value = system,
            })
        end
    end
    
    if critical_function.third_parties then
        for _, party in ipairs(critical_function.third_parties) do
            table.insert(bundle.evidence, {
                type = "THIRD_PARTY",
                value = party,
            })
        end
    end
    
    if critical_function.binary_hashes then
        for _, hash in ipairs(critical_function.binary_hashes) do
            table.insert(bundle.evidence, {
                type = "BINARY_HASH",
                value = hash,
            })
        end
    end
    
    table.insert(DORAEvidence.bundles, bundle)
    return bundle
end

-- Export evidence bundle as JSON
function DORAEvidence.export(bundle)
    return {
        bundle_id = bundle.function_name,
        created_at = os.date("%Y-%m-%dT%H:%M:%S", bundle.created_at),
        evidence_count = #bundle.evidence,
        evidence = bundle.evidence,
        attestation = "Ed25519 signature would be added here",
    }
end

return DORAEvidence
