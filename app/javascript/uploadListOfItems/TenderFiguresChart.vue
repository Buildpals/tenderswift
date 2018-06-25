z<template>
  <div class="graph">
    <canvas ref="chart" class="mb-2"></canvas>
  </div>
</template>

<script>
  import TenderSwiftMixins from '../TenderSwiftMixins'
  import ContextMenu from 'vue-context-menu'

  import Chart from 'chart.js'

  const newMenuData = () => ({tender: null})

  const BACKGROUND_COLORS = [
    'rgba(62, 149, 205, 0.5)',
    'rgba(142, 94, 162, 0.5)',
    'rgba(60, 186, 159, 0.5)',
    'rgba(232, 195, 185, 0.5)',
    'rgba(196, 88, 80, 0.5)',
    'rgba(233, 150, 122, 0.5)',
    'rgba(255, 255, 0, 0.5)',
    'rgba(128, 128, 0, 0.5)',
    'rgba(0, 128, 128, 0.5)',
    'rgba(255, 0, 255, 0.5)',
    'rgba(240, 128, 128, 0.5)'
  ]

  export default {
    mixins: [TenderSwiftMixins],

    components: {ContextMenu},

    props: [
      'tender_id',
      'list_of_items',
      'tenders'
    ],

    data () {
      return {
        menuData: newMenuData(),
        baseTenderFigure: this.tenderFigure(this.tenders[0]),
        chart: false,
        data: this.tenders.map(tender => this.tenderFigure(tender)),
        labels: this.tenders.map(tender => tender.contractor.company_name)
      }
    },

    mounted () {
      this.setupHorizontalBarPlugin()
      this.initChart()
    },

    beforeDestroy () {
      this.chart.destroy()
    },

    watch: {
      'tenders': 'updateChart'
    },

    methods: {
      tenderFigure (tender) {
        return Object.keys(tender.list_of_rates.rates).reduce((accumulator, rateKey) => {
          return accumulator +
            this.list_of_items.items[rateKey].quantity * tender.list_of_rates.rates[rateKey]
        }, 0)
      },

      onCtxOpen (locals) {
        console.log('open', locals)
        this.menuData = locals
      },
      onCtxClose (locals) {
        console.log('close', locals)
      },
      resetCtxLocals () {
        this.menuData = newMenuData()
      },


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
            labels: this.labels,
            datasets: [
              {
                label: 'Tender Figure',
                backgroundColor: BACKGROUND_COLORS,
                data: this.data
              }
            ]
          },
          options: {
            legend: {display: false},
            lineAtIndex: this.baseTenderFigure,
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
        this.chart.data.labels = this.labels
        this.chart.data.datasets = [
          {
            label: 'Tender Figure',
            backgroundColor: BACKGROUND_COLORS,
            data: this.data
          }
        ]
        this.chart.update();
      }
    }
  }
</script>