import React from 'react';

const EnvironmentReading = ({ environmentReadings }) => (
    <table className="table" data-testid="environmentReadingsTable">
        <thead>
            <tr>
                <th>Time</th>
                <th>ID</th>
                <th>Temperature</th>
                <th>Humidity</th>
            </tr>
        </thead>
        <tbody data-testid="readingsTableRows">
            {
                environmentReadings.map(reading => (
                    <tr key={reading.id} data-testid="environmentReadingRow">
                        <td>{reading.created_at}</td>
                        <td>{reading.id}</td>
                        <td>{reading.temperature}</td>
                        <td>{reading.humidity}</td>
                        <td>{reading.message}</td>
                    </tr>
                ))
            }
        </tbody>
    </table>
);

export default EnvironmentReading;
