<template>
  <div class="graph mb-5">
    <canvas ref="chart" class="mb-2"></canvas>
  </div>
</template>

<script>
  import Chart from 'chart.js'

  export default {
    props: [
      'participants',
      'currency',
      'qsContractSum',
      'qsCompanyName'
    ],
    mounted () {
      this.setupHorizontalBarPlugin()
      this.initChart()
    },
    beforeDestroy () {
      this.chart.destroy()
    },
    watch: {
      'participants': 'updateChart'
    },
    data () {
      return {
        chart: false
      }
    },
    computed: {
      sheetData () {
        return process_wb(this.workbook, this.sheetIndex)
      }
    },
    methods: {
      setupHorizontalBarPlugin () {
        //Create horizontalBar plug-in for ChartJS
        var originalLineDraw = Chart.controllers.horizontalBar.prototype.draw;
        Chart.helpers.extend(Chart.controllers.horizontalBar.prototype, {

          draw: function () {
            originalLineDraw.apply(this, arguments);

            var chart = this.chart;
            var ctx = chart.chart.ctx;

            var index = chart.config.options.lineAtIndex;
            if (index) {

              var xaxis = chart.scales['x-axis-0'];
              var yaxis = chart.scales['y-axis-0'];

              var x1 = xaxis.getPixelForValue(index);
              var y1 = 0;

              var x2 = xaxis.getPixelForValue(index);
              var y2 = yaxis.height + 50;

              ctx.save();
              ctx.beginPath();
              ctx.moveTo(x1, y1);
              ctx.strokeStyle = 'red';
              ctx.lineTo(x2, y2);
              ctx.stroke();

              ctx.restore();
            }
          }
        });
      },
      initChart () {
        let ctx = this.$refs.chart.getContext('2d')
        this.chart = new Chart(ctx, {
          type: 'horizontalBar',
          data: {
            labels: [this.qsCompanyName, ...this.participants.map(participant => participant.company_name)],
            datasets: [
              {
                label: 'Contract Sum',
                backgroundColor: ['rgba(62, 149, 205, 0.5)', 'rgba(142, 94, 162, 0.5)', 'rgba(60, 186, 159, 0.5)', 'rgba(232, 195, 185, 0.5)', 'rgba(196, 88, 80, 0.5)',
                  'rgba(233, 150, 122, 0.5)', 'rgba(255, 255, 0, 0.5)', 'rgba(128, 128, 0, 0.5)', 'rgba(0, 128, 128, 0.5)', 'rgba(255, 0, 255, 0.5)', 'rgba(240, 128, 128, 0.5)'],
                data: [this.qsContractSum, ...this.participants.map(participant => participant.contract_sum)]
              }
            ]
          },
          options: {
            legend: {display: false},
            lineAtIndex: this.qsContractSum,
            title: {
              display: true,
              text: 'Summary'
            },
            scales: {
              xAxes: [{
                ticks: {
                  beginAtZero: true
                }
              }],
              yAxes: [{
                ticks: {
                  mirror: true,
                  beginAtZero: true
                }
              }]
            }
          }
        })
      },
      updateChart () {
        this.chart.data.labels = this.participants.map(participant => participant.company_name)
        this.chart.data.datasets = [
          {
            label: 'Contract Sum',
            backgroundColor: ['rgba(62, 149, 205, 0.5)', 'rgba(142, 94, 162, 0.5)', 'rgba(60, 186, 159, 0.5)', 'rgba(232, 195, 185, 0.5)', 'rgba(196, 88, 80, 0.5)',
              'rgba(233, 150, 122, 0.5)', 'rgba(255, 255, 0, 0.5)', 'rgba(128, 128, 0, 0.5)', 'rgba(0, 128, 128, 0.5)', 'rgba(255, 0, 255, 0.5)', 'rgba(240, 128, 128, 0.5)'],
            data: this.participants.map(participant => participant.contract_sum)
          }
        ]
        this.chart.update();
      }
    }
  }
</script>

<style>
</style>