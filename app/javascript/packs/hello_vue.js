import TurbolinksAdapter from 'vue-turbolinks';
import BootstrapVue from 'bootstrap-vue'
import VueResource from 'vue-resource'
import Vue from 'vue/dist/vue.esm'

import UploadListOfItems from '../uploadListOfItems/UploadListOfItems'
import RatesUploader from '../uploadListOfItems/RatesUploader'
import RatesReviewer from '../uploadListOfItems/RatesReviewer'
import RatesComparer from '../uploadListOfItems/RatesComparer'
import TenderFiguresTable from '../uploadListOfItems/TenderFiguresTable'
import ContractorTenderFigures from '../uploadListOfItems/ContractorTenderFigures'
import ContractorTenderFiguresRow from '../uploadListOfItems/ContractorTenderFiguresRow'
import FileUploader from '../uploadListOfItems/FileUploader'
import ProjectDocumentsUploader from '../uploadListOfItems/ProjectDocumentsUploader'

Vue.use(TurbolinksAdapter)
Vue.use(BootstrapVue);
Vue.use(VueResource);

document.addEventListener('turbolinks:load', () => {
  if ($('.hello').length === 0) return

  let csrfTokenMetaTag = document.querySelector('meta[name="csrf-token"')
  if (csrfTokenMetaTag) {
    Vue.http.headers.common['X-CSRF-Token'] = csrfTokenMetaTag.getAttribute('content')
  }

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
      ContractorTenderFigures,
      ContractorTenderFiguresRow,
      RatesComparer
    }
  })
})
