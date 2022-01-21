import uPlot from 'uplot';
import _css from 'uplot/dist/uPlot.min.css'

export const Chart = {
  mounted() {
    this.handleEvent("points", ({points}) => this.chartPoints(points))
  },

  chartPoints(points) {
    console.log(points)
    let size = this.el.getBoundingClientRect()

    let opts = {
      title: "Weekly Distance",
      width: size.width,
      height: 300,
      series: [
        {},
        {
          // initial toggled state (optional)
          show: true,

          spanGaps: true,

          // in-legend display
          label: "Distance",
          value: (self, rawValue) => rawValue.toFixed(2) + "km",

          // series style
          stroke: "red",
          width: 1,
        }
      ],
    };


    let uplot = new uPlot(opts, points, this.el);
  }
}
