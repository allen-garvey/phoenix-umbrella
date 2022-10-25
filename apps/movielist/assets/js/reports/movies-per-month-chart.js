import { LineChart } from 'chartist';
import ctAxisTitle from 'chartist-plugin-axistitle';

function formatChartData(rawData){
    const totalData = {
        labels: [],
        series: [[]],
    };
    return rawData.reduce((totalData, [label, value])=>{
        totalData.labels.push(label);
        totalData.series[0].push(value);
        return totalData;
    }, totalData);
}

export function initializeMoviesPerMonthChart(){
    const chartId = 'movies_per_month_chart';
    const chartContainer = document.getElementById(chartId);
    if(!chartContainer){
        return;
    }
    const data = formatChartData(window.MOVIELIST_CHART_DATA);
    new LineChart(`#${chartId}`, data, {
        axisY: {
            onlyInteger: true,
            low: 0,
        },
        showArea: true,
        plugins: [
            ctAxisTitle({
                axisX: {
                    axisTitle: 'Month of the year',
                    offset: {
                        x: 0,
                        y: 50
                    },
                    textAnchor: 'middle'
                },
                axisY: {
                    axisTitle: 'Movies watched',
                    offset: {
                        x: 0,
                        y: -5
                    },
                    flipTitle: true
                } 
            })
        ],
    });
}