local DORAClassifier = {
    thresholds = {
        clients_affected_pct = 10,
        clients_affected_count = 100000,
        duration_hours = 24,
        critical_downtime_hours = 2,
        member_states = 2,
        economic_impact_eur = 100000,
    },
}

function DORAClassifier.classify(incident)
    local scores = {
        clients_affected = 0,
        duration = 0,
        geographic = 0,
        data_loss = 0,
        critical_impact = 0,
        economic = 0,
        reputational = 0,
    }
    
    if incident.clients_affected_pct and incident.clients_affected_pct > DORAClassifier.thresholds.clients_affected_pct then
        scores.clients_affected = 3
    elseif incident.clients_affected_count and incident.clients_affected_count > 1000 then
        scores.clients_affected = 2
    elseif incident.clients_affected_count and incident.clients_affected_count > 0 then
        scores.clients_affected = 1
    end
    
    if incident.duration_hours and incident.duration_hours > DORAClassifier.thresholds.duration_hours then
        scores.duration = 3
    elseif incident.duration_hours and incident.duration_hours > 6 then
        scores.duration = 2
    elseif incident.duration_hours and incident.duration_hours > 2 then
        scores.duration = 1
    end
    
    if incident.member_states and incident.member_states >= DORAClassifier.thresholds.member_states then
        scores.geographic = 3
    elseif incident.member_states and incident.member_states == 1 then
        scores.geographic = 1
    end
    
    if incident.data_loss_pct then
        if incident.data_loss_pct > 30 then scores.data_loss = 3
        elseif incident.data_loss_pct > 10 then scores.data_loss = 2
        elseif incident.data_loss_pct > 0 then scores.data_loss = 1 end
    end
    
    if incident.critical_downtime_hours and incident.critical_downtime_hours > DORAClassifier.thresholds.critical_downtime_hours then
        scores.critical_impact = 3
    elseif incident.critical_function_affected then
        scores.critical_impact = 2
    end
    
    if incident.economic_impact_eur and incident.economic_impact_eur > DORAClassifier.thresholds.economic_impact_eur then
        scores.economic = 3
    elseif incident.economic_impact_eur and incident.economic_impact_eur > 10000 then
        scores.economic = 2
    elseif incident.economic_impact_eur and incident.economic_impact_eur > 0 then
        scores.economic = 1
    end
    
    if incident.reputational_impact == "severe" then scores.reputational = 3
    elseif incident.reputational_impact == "significant" then scores.reputational = 2
    elseif incident.reputational_impact == "minor" then scores.reputational = 1 end
    
    local total = 0
    for _, score in pairs(scores) do total = total + score end
    
    if total >= 12 then return "MAJOR", scores
    elseif total >= 7 then return "SIGNIFICANT", scores
    elseif total >= 3 then return "MINOR", scores
    else return "NON_REPORTABLE", scores end
end

return DORAClassifier
