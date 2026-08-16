-- dora_sbom_ingest.lua — Vendor SBOM ingestion pipeline (DORA Art.28)
local DORASBOM = {
    sboms = {},
    components = {},
}

-- Ingest a vendor SBOM (CycloneDX or SPDX JSON)
function DORASBOM.ingest(vendor_name, sbom_json)
    local sbom = {
        vendor = vendor_name,
        ingested_at = os.time(),
        components = {},
    }
    
    -- Parse components (CycloneDX format)
    if sbom_json.components then
        for _, comp in ipairs(sbom_json.components) do
            local component = {
                name = comp.name or "Unknown",
                version = comp.version or "?",
                supplier = comp.supplier and comp.supplier.name or vendor_name,
                licenses = comp.licenses or {},
                hashes = comp.hashes or {},
            }
            table.insert(sbom.components, component)
            table.insert(DORASBOM.components, component)
        end
    end
    
    -- Parse components (SPDX format)
    if sbom_json.packages then
        for _, pkg in ipairs(sbom_json.packages) do
            local component = {
                name = pkg.name or "Unknown",
                version = pkg.versionInfo or "?",
                supplier = pkg.supplier or vendor_name,
                licenses = {pkg.licenseConcluded or "Unknown"},
                hashes = pkg.checksums or {},
            }
            table.insert(sbom.components, component)
            table.insert(DORASBOM.components, component)
        end
    end
    
    table.insert(DORASBOM.sboms, sbom)
    return sbom
end

-- Check if a component is from a known vendor
function DORASBOM.find_component(name)
    local matches = {}
    for _, comp in ipairs(DORASBOM.components) do
        if comp.name:lower():find(name:lower(), 1, true) then
            table.insert(matches, comp)
        end
    end
    return matches
end

-- Generate vendor summary
function DORASBOM.vendor_summary(vendor_name)
    local count = 0
    local licenses = {}
    
    for _, sbom in ipairs(DORASBOM.sboms) do
        if sbom.vendor == vendor_name then
            count = count + #sbom.components
            for _, comp in ipairs(sbom.components) do
                for _, lic in ipairs(comp.licenses) do
                    licenses[lic] = (licenses[lic] or 0) + 1
                end
            end
        end
    end
    
    return {
        vendor = vendor_name,
        component_count = count,
        licenses = licenses,
    }
end

return DORASBOM
