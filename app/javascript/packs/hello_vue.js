import TurbolinksAdapter from 'vue-turbolinks';
import BootstrapVue from 'bootstrap-vue'
import VueResource from 'vue-resource'
import Vue from 'vue/dist/vue.esm'

import UploadListOfItems from '../uploadListOfItems/UploadListOfItems'
import RatesUploader from '../uploadListOfItems/RatesUploader'
import RatesReviewer from '../uploadListOfItems/RatesReviewer'
import RatesComparer from '../uploadListOfItems/RatesComparer'
import TenderFiguresTable from '../uploadListOfItems/TenderFiguresTable'
import ProjectDocumentsUploader from '../uploadListOfItems/ProjectDocumentsUploader'

Vue.use(TurbolinksAdapter)
Vue.use(BootstrapVue);
Vue.use(VueResource);

document.addEventListener('turbolinks:load', () => {
  if ($('.hello').length === 0) return

  Vue.http.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"').getAttribute('content')

  const app = new Vue({
    el: '.hello',
    data: {
      message: "Can you say hello?"
    },
    components: {
      UploadListOfItems,
      ProjectDocumentsUploader,
      RatesUploader,
      RatesReviewer,
      TenderFiguresTable,
      RatesComparer
    }
  })
})
