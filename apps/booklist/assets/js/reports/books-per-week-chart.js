import Chartist from 'chartist';
import ctAxisTitle from 'chartist-plugin-axistitle';

function formatChartData(rawData){
    const data = {
        labels: [],
        series: [[]],
    };
    return rawData.reduce((data, entry)=>{
        data.labels.push(entry[0]);
        data.series[0].push(entry[1]);
        return data;
    }, data);
}

export function initializeBooksPerWeekChart(){
    const chartId = 'books_per_week_chart';
    const chartContainer = document.getElementById(chartId);
    if(!chartContainer){
        return;
    }
    const data = formatChartData(window.BOOKLIST_CHART_DATA);
    new Chartist.Line(`#${chartId}`, data, {
        axisY: {
            onlyInteger: true,
        },
        plugins: [
            ctAxisTitle({
                axisX: {
                    axisTitle: 'Week of the year',
                    offset: {
                        x: 0,
                        y: 35
                    },
                    textAnchor: 'middle'
                },
                axisY: {
                    axisTitle: 'Books read',
                    offset: {
                        x: 0,
                        y: 20
                    },
                    flipTitle: true
                } 
            })
        ],
    });
}