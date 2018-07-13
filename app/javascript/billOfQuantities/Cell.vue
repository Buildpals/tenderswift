<template>
  <td class="cell" v-bind:class="{ formula: cell && cell.f }">
    <div contenteditable="true"
         @click="showCellContents"
         @input="update">
      {{ cell && cell.w }}
    </div>
  </td>
</template>

<script>
  export default {
    props: [
      'cell'
    ],

    // computed: {
    //   content () {
    //     function keys(o) {
    //       var ks = Object.keys(o), o2 = [];
    //       for(var i = 0; i < ks.length; ++i) if(o.hasOwnProperty(ks[i])) o2.push(ks[i]);
    //       return o2;
    //     }
    //
    //     function evert(obj) {
    //       var o = ([]), K = keys(obj);
    //       for(var i = 0; i !== K.length; ++i) o[obj[K[i]]] = K[i];
    //       return o;
    //     }
    //
    //     var encodings = {
    //       '&quot;': '"',
    //       '&apos;': "'",
    //       '&gt;': '>',
    //       '&lt;': '<',
    //       '&amp;': '&'
    //     };
    //     var rencoding = evert(encodings);
    //
    //
    //     var decregex=/[&<>'"]/g, charegex = /[\u0000-\u0008\u000b-\u001f]/g;
    //
    //     function escapexml(text){
    //       var s = text + '';
    //       return s.replace(decregex, function(y) { return rencoding[y]; }).replace(charegex,function(s) { return "_x" + ("000"+s.charCodeAt(0).toString(16)).slice(-4) + "_";});
    //     }
    //
    //
    //     var basedate = new Date(1899, 11, 30, 0, 0, 0); // 2209161600000
    //     var dnthresh = basedate.getTime() + (new Date().getTimezoneOffset() - basedate.getTimezoneOffset()) * 60000;
    //     function datenum(v, date1904) {
    //       var epoch = v.getTime();
    //       if(date1904) epoch -= 1462*24*60*60*1000;
    //       return (epoch - dnthresh) / (24 * 60 * 60 * 1000);
    //     }
    //
    //     function safe_format_cell(cell, v) {
    //       var q = (cell.t == 'd' && v instanceof Date);
    //       if(cell.z != null) try { return (cell.w = SSF.format(cell.z, q ? datenum(v) : v)); } catch(e) { }
    //       try { return (cell.w = SSF.format((cell.XF||{}).numFmtId||(q ? 14 : 0),  q ? datenum(v) : v)); } catch(e) { return ''+v; }
    //     }
    //
    //     function format_cell(cell, v, o) {
    //       if(cell == null || cell.t == null || cell.t == 'z') return "";
    //       if(cell.w !== undefined) return cell.w;
    //       if(cell.t == 'd' && !cell.z && o && o.dateNF) cell.z = o.dateNF;
    //       if(v == undefined) return safe_format_cell(cell, cell.v);
    //       return safe_format_cell(cell, v);
    //     }
    //
    //
    //     let cell = this.cell
    //     let editable = true
    //
    //     var nullcell = "<td>" + (editable ? '<span contenteditable="true"></span>' : "" ) + "</td>";
    //
    //     if(!cell || cell.v == null) { return nullcell }
    //
    //     var w = cell.h || escapexml(cell.w || (format_cell(cell), cell.w) || "");
    //
    //
    //     let RS = 1
    //     let CS = 1
    //     var sp = {};
    //     if(RS > 1) sp.rowspan = RS;
    //     if(CS > 1) sp.colspan = CS;
    //     sp.t = cell.t;
    //
    //     if(editable) w = '<span contenteditable="true">' + w + '</span>';
    //     // sp.id = "sjs-" + coord;
    //     // return writextag('td', w, sp);
    //     return w
    //   }
    // },

    methods: {
      showCellContents () {
        if (this.cell && this.cell.f) {
          this.$emit('show-cell-contents', this.cell.f)
        } else if (this.cell && this.cell.w) {
          this.$emit('show-cell-contents', this.cell.w)
        } else {
          this.$emit('show-cell-contents', '')
        }
      },
      update (event) {
        let newValue = event.target.innerText
        console.log(newValue)
        // TODO: process the cell properties based on the newValue
      }
    }
  }
</script>

<style lang="scss">
  .formula {
    background: beige;
  }

  .cell {
    padding: 0rem !important;
  }
</style>