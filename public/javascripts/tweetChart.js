function tweetChart(counts) {
  $(function() {
    chart = new Highcharts.Chart({
      chart: {
        renderTo: 'container',
        defaultSeriesType: 'column'
      },
      title: {
        text: 'Tweet Density',
        align: 'left',
        x: 70
      },
      xAxis: {
        categories: [
          0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23
        ],
        title: {
          text: 'Tweets'
        }
      },
      yAxis: {
        min: 0,
        title: {
          text: ''
        }
      },
      legend: {
        align: 'right',
        verticalAlign: 'top',
        x: 0,
        y: 100,
        borderWidth: 0
      },
      plotOptions: {
        column: {
          pointPadding: 0.2,
          borderWidth: 0
        },
        series: {
          animation: false
        }
      },
      tooltip: {
        enabled: true
      },
      series: [{
        name: 'Tweets',
        data: counts
      }]
    });
  });
}