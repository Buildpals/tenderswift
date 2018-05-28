import TurbolinksAdapter from 'vue-turbolinks';
import BootstrapVue from 'bootstrap-vue'
import VueResource from 'vue-resource'
import Vue from 'vue/dist/vue.esm'

import UploadBoq from '../uploadBoq/uploadBoq'
import UploadListOfItems from '../uploadListOfItems/UploadListOfItems'
import ProjectDocumentsUploader from '../uploadListOfItems/ProjectDocumentsUploader'
import RateFillingBoq from '../rateFillingBoq/rateFillingBoq'
import ViewBidBoq from '../viewBidBoq/viewBidBoq'
import ComparisonBoq from '../comparisonBoq/comparisonBoq'
import BidsTable from '../bidsTable/bidsTable'

Vue.use(TurbolinksAdapter)
Vue.use(BootstrapVue);
Vue.use(VueResource);

document.addEventListener('turbolinks:load', () => {
  if ($('#hello').length === 0) return

  Vue.http.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"').getAttribute('content')

  const app = new Vue({
    el: '#hello',
    data: {
      message: "Can you say hello?"
    },
    components: {
      UploadBoq,
      UploadListOfItems,
      RateFillingBoq,
      ViewBidBoq,
      ComparisonBoq,
      BidsTable,
      ProjectDocumentsUploader
    }
  })
})
