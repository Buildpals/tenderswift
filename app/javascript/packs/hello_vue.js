import TurbolinksAdapter from 'vue-turbolinks';
import BootstrapVue from 'bootstrap-vue'
import VueResource from 'vue-resource'
import Vue from 'vue/dist/vue.esm'

import BillOfQuantitiesUploader from '../uploadListOfItems/BillOfQuantitiesUploader'

import RatesUploader from '../uploadListOfItems/RatesUploader'
import RatesComparer from '../uploadListOfItems/RatesComparer'

import TenderFiguresTable from '../uploadListOfItems/TenderFiguresTable'
import ContractorTenderFigures from '../uploadListOfItems/ContractorTenderFigures'
import ProjectDocumentsUploader from '../uploadListOfItems/ProjectDocumentsUploader'
import OtherDocumentsUploader from '../uploadListOfItems/OtherDocumentsUploader'
import RequiredDocumentUploader from '../uploadListOfItems/RequiredDocumentUploader'

import Workbook from '../../javascript/billOfQuantities/Workbook'
import DisplayTenderFigure
  from '../../javascript/compareBillOfQuantities/DisplayTenderFigure'

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
    components: {
      BillOfQuantitiesUploader,
      ProjectDocumentsUploader,
      OtherDocumentsUploader,
      RequiredDocumentUploader,
      RatesUploader,
      TenderFiguresTable,
      ContractorTenderFigures,
      RatesComparer,
      DisplayTenderFigure,
      Workbook
    }
  })
})
