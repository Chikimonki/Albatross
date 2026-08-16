-- dora_register.lua — Register of Information generator (ITS 2024/2956)
local DORARegister = {
    entries = {},
}

-- Add an ICT third-party provider to the register
function DORARegister.add_provider(provider)
    table.insert(DORARegister.entries, {
        provider_name = provider.name or "Unknown",
        function_type = provider.function_type or "ICT",
        criticality = provider.criticality or "LOW",
        contract_start = provider.contract_start or os.date("%Y-%m-%d"),
        contract_end = provider.contract_end or "Indefinite",
        subcontractors = provider.subcontractors or {},
        data_locations = provider.data_locations or {"EU"},
        exit_strategy = provider.exit_strategy or "None documented",
        last_audit = provider.last_audit or "Never",
        sub_outsourcing = provider.sub_outsourcing or false,
    })
end

-- Generate the Register of Information (xBRL-CSV format)
function DORARegister.generate()
    local lines = {}
    
    -- Header row
    table.insert(lines, "provider_name,function_type,criticality,contract_start,contract_end,data_locations,exit_strategy,last_audit,sub_outsourcing")
    
    -- Data rows
    for _, entry in ipairs(DORARegister.entries) do
        local row = string.format("%s,%s,%s,%s,%s,%s,%s,%s,%s",
            entry.provider_name,
            entry.function_type,
            entry.criticality,
            entry.contract_start,
            entry.contract_end,
            table.concat(entry.data_locations, ";"),
            entry.exit_strategy,
            entry.last_audit,
            tostring(entry.sub_outsourcing)
        )
        table.insert(lines, row)
    end
    
    return table.concat(lines, "\n")
end

-- Generate summary for reporting
function DORARegister.summary()
    local total = #DORARegister.entries
    local critical = 0
    local high = 0
    
    for _, entry in ipairs(DORARegister.entries) do
        if entry.criticality == "CRITICAL" then critical = critical + 1
        elseif entry.criticality == "HIGH" then high = high + 1 end
    end
    
    return {
        total_providers = total,
        critical_providers = critical,
        high_risk_providers = high,
        submission_due = "30 April annually",
    }
end

return DORARegister
