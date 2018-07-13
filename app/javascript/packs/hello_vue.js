import TurbolinksAdapter from 'vue-turbolinks';
import BootstrapVue from 'bootstrap-vue'
import VueResource from 'vue-resource'
import Vue from 'vue/dist/vue.esm'

import BillOfQuantitiesUploader from '../uploadListOfItems/BillOfQuantitiesUploader'
import RatesUploader from '../uploadListOfItems/RatesUploader'
import RatesReviewer from '../uploadListOfItems/RatesReviewer'
import RatesComparer from '../uploadListOfItems/RatesComparer'
import TenderFiguresTable from '../uploadListOfItems/TenderFiguresTable'
import ContractorTenderFigures from '../uploadListOfItems/ContractorTenderFigures'
import ContractorTenderFiguresRow from '../uploadListOfItems/ContractorTenderFiguresRow'
import ProjectDocumentsUploader from '../uploadListOfItems/ProjectDocumentsUploader'
import OtherDocumentsUploader from '../uploadListOfItems/OtherDocumentsUploader'
import RequiredDocumentUploader from '../uploadListOfItems/RequiredDocumentUploader'
import Workbook from '../../javascript/billOfQuantities/Workbook'

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
      BillOfQuantitiesUploader,
      ProjectDocumentsUploader,
      OtherDocumentsUploader,
      RequiredDocumentUploader,
      RatesUploader,
      RatesReviewer,
      TenderFiguresTable,
      ContractorTenderFigures,
      ContractorTenderFiguresRow,
      RatesComparer,
      Workbook
    }
  })
})
