<%@ Page Language="VB" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>
<html>
<head>
    <title>Manager Dashboard - Inventory Forecasting</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .forecast-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .forecast-table th, .forecast-table td { border: 1px solid #ccc; padding: 12px; text-align: left; }
        .forecast-table th { background: #583937; color: white; }
        .card { border: 1px solid #ddd; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .highlight { color: #d32f2f; font-weight: bold; }
    </style>
</head>
<body>
    <div style="background-color: #583937; color: white; padding: 20px; text-align: center;">
        <h1>PVFC Manager Dashboard</h1>
        <p>Lab 11: Inventory Forecasting & Demand Analysis (BI)</p>
    </div>
    
    <div class="card">
        <h2>Demand Forecasting</h2>
        <p>Forecasting demand for secondary items based on primary item sales trends (Market Basket Analysis - Self Join).</p>
        
        <div id="forecastResults">
            <table class="forecast-table">
                <thead>
                    <tr>
                        <th>Primary Item (Higher Sales)</th>
                        <th>Secondary Item (Predicted Demand)</th>
                        <th>Correlation Strength (Order Frequency)</th>
                        <th>Recommended Action</th>
                    </tr>
                </thead>
                <tbody id="forecastBody">
                    <!-- Data will be loaded via API -->
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Fetch forecasting data from the separate Blazor API
        fetch('http://localhost:5170/api/recommendation/forecast')
            .then(response => response.json())
            .then(data => {
                const tbody = document.getElementById('forecastBody');
                tbody.innerHTML = '';
                data.forEach(item => {
                    const tr = document.createElement('tr');
                    tr.innerHTML = `
                        <td>${item.primary}</td>
                        <td class="highlight">${item.secondary}</td>
                        <td>${item.count} orders</td>
                        <td>Increase stock for <i>${item.secondary}</i></td>
                    `;
                    tbody.appendChild(tr);
                });
            })
            .catch(err => console.error('Forecasting API Error:', err));
    </script>

    
    <p><a href="index.html">Back to Lab 11 Menu</a></p>
</body>
</html>
