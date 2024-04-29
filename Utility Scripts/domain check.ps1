# Function to scrape DNS records from a DNS lookup website
function Get-DNSRecords {
    param (
        [string]$domain
    )

    $url = "https://dnschecker.org/all-dns-records-of-domain.php?query=$domain"
    
    try {
        $response = Invoke-WebRequest -Uri $url
        if ($response.StatusCode -eq 200) {
            $dnsRecords = $response.AllElements | Where-Object { $_.tagName -eq "table" -and $_.class -eq "table" } | Select-Object -ExpandProperty innerText
            return $dnsRecords
        } else {
            Write-Output "Error: Unable to retrieve DNS records."
            return $null
        }
    } catch {
        Write-Output "Error occurred while querying DNS records: $_"
        return $null
    }
}

# Function to scrape WHOIS information from a WHOIS lookup service's website
function Get-WhoisInfo {
    param (
        [string]$domain
    )

    $url = "https://www.whois.com/whois/$domain"
    
    try {
        $response = Invoke-WebRequest -Uri $url
        if ($response.StatusCode -eq 200) {
            $whoisInfo = $response.AllElements | Where-Object { $_.tagName -eq "pre" } | Select-Object -ExpandProperty innerText
            return $whoisInfo
        } else {
            Write-Output "Error: Unable to retrieve WHOIS information."
            return $null
        }
    } catch {
        Write-Output "Error occurred while querying WHOIS information: $_"
        return $null
    }
}

# Main function to retrieve DNS records and WHOIS information for a domain
function Get-DomainInfo {
    param (
        [string]$domain
    )

    try {
        Write-Output "Retrieving DNS records for $domain..."
        $dnsRecords = Get-DNSRecords -domain $domain
        Write-Output "DNS Records:"
        $dnsRecords

        Write-Output ""

        Write-Output "Retrieving WHOIS information for $domain..."
        $whoisInfo = Get-WhoisInfo -domain $domain
        Write-Output "WHOIS Information:"
        $whoisInfo
    } catch {
        Write-Output "Error occurred while retrieving domain information for $domain: $_"
        return $null
    }
}

# Main script
$domain = Read-Host "Enter domain name (e.g., example.com):"
Get-DomainInfo -domain $domain