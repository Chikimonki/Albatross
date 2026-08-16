-- dora_timeline.lua — DORA Article 19 3-phase reporting timeline
-- Initial (4h) → Intermediate (72h) → Final (1 month)

local DORATimeline = {
    phases = {
        initial = { hours = 4, label = "Initial Notification" },
        intermediate = { hours = 72, label = "Intermediate Report" },
        final = { hours = 720, label = "Final Report" }, -- 30 days = 720 hours
    },
}

-- Create a new incident timeline
function DORATimeline.create(incident)
    local now = os.time()
    
    return {
        incident = incident,
        created_at = now,
        classification_time = nil,
        phases = {
            initial = { due = now + DORATimeline.phases.initial.hours * 3600, submitted = nil },
            intermediate = { due = now + DORATimeline.phases.intermediate.hours * 3600, submitted = nil },
            final = { due = now + DORATimeline.phases.final.hours * 3600, submitted = nil },
        },
    }
end

-- Classify the incident (starts the 24h outer cap for initial)
function DORATimeline.classify(timeline, classification, scores)
    timeline.classification = classification
    timeline.classification_time = os.time()
    timeline.scores = scores
    
    -- DORA Rule: Initial notification due max 24h from awareness,
    -- but if classification is slow, the 24h cap burns first.
    local awareness_time = timeline.created_at
    local outer_cap = awareness_time + 24 * 3600
    local inner_due = timeline.classification_time + DORATimeline.phases.initial.hours * 3600
    
    timeline.phases.initial.due = math.min(outer_cap, inner_due)
    
    return timeline
end

-- Submit a phase
function DORATimeline.submit(timeline, phase_name)
    if timeline.phases[phase_name] then
        timeline.phases[phase_name].submitted = os.time()
        return true
    end
    return false
end

-- Check if a phase is overdue
function DORATimeline.is_overdue(timeline, phase_name)
    local phase = timeline.phases[phase_name]
    if not phase then return false end
    return not phase.submitted and os.time() > phase.due
end

-- Get remaining time for a phase
function DORATimeline.remaining(timeline, phase_name)
    local phase = timeline.phases[phase_name]
    if not phase then return nil end
    
    if phase.submitted then return 0 end
    
    local remaining = phase.due - os.time()
    return math.max(0, remaining)
end

-- Format remaining time as human readable
function DORATimeline.format_remaining(seconds)
    if seconds <= 0 then return "OVERDUE" end
    
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    
    if hours > 24 then
        local days = math.floor(hours / 24)
        return string.format("%dd %dh", days, hours % 24)
    elseif hours > 0 then
        return string.format("%dh %dm", hours, minutes)
    else
        return string.format("%dm", minutes)
    end
end

-- Get full timeline report
function DORATimeline.report(timeline)
    local lines = {}
    
    table.insert(lines, "=== DORA Article 19 Timeline ===")
    table.insert(lines, string.format("Incident: %s", timeline.incident.name or "Unknown"))
    table.insert(lines, string.format("Awareness: %s", os.date("%Y-%m-%d %H:%M:%S", timeline.created_at)))
    
    if timeline.classification then
        table.insert(lines, string.format("Classification: %s", timeline.classification))
        table.insert(lines, string.format("Classified at: %s", os.date("%Y-%m-%d %H:%M:%S", timeline.classification_time)))
    end
    
    table.insert(lines, "")
    
    for name, phase in pairs(timeline.phases) do
        local status = "PENDING"
        if phase.submitted then
            status = string.format("SUBMITTED at %s", os.date("%H:%M:%S", phase.submitted))
        elseif DORATimeline.is_overdue(timeline, name) then
            status = "OVERDUE"
        else
            status = string.format("DUE in %s", DORATimeline.format_remaining(DORATimeline.remaining(timeline, name)))
        end
        
        table.insert(lines, string.format("  %-20s: %s", DORATimeline.phases[name].label, status))
    end
    
    return table.concat(lines, "\n")
end

return DORATimeline
