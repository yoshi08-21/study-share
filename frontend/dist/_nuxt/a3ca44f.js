(window.webpackJsonp=window.webpackJsonp||[]).push([[29],{574:function(t,e,n){"use strict";e.a={methods:{goToUser:function(t){this.currentUser&&this.currentUser.id===t.id?this.$router.push({path:"/mypage"}):this.$router.push({path:"/users/".concat(t.id)})}}}},579:function(t,e,n){n(9)({target:"Number",stat:!0,nonConfigurable:!0,nonWritable:!0},{MAX_SAFE_INTEGER:9007199254740991})},580:function(t,e,n){var content=n(581);content.__esModule&&(content=content.default),"string"==typeof content&&(content=[[t.i,content,""]]),content.locals&&(t.exports=content.locals);(0,n(18).default)("7f6d4ad6",content,!0,{sourceMap:!1})},581:function(t,e,n){var r=n(17)(!1);r.push([t.i,".theme--light.v-pagination .v-pagination__item{background:#fff;color:rgba(0,0,0,.87)}.theme--light.v-pagination .v-pagination__item--active{color:#fff}.theme--light.v-pagination .v-pagination__navigation{background:#fff}.theme--dark.v-pagination .v-pagination__item{background:#1e1e1e;color:#fff}.theme--dark.v-pagination .v-pagination__item--active{color:#fff}.theme--dark.v-pagination .v-pagination__navigation{background:#1e1e1e}.v-pagination{align-items:center;display:inline-flex;list-style-type:none;justify-content:center;margin:0;max-width:100%;width:100%}.v-pagination.v-pagination{padding-left:0}.v-pagination>li{align-items:center;display:flex}.v-pagination--circle .v-pagination__item,.v-pagination--circle .v-pagination__more,.v-pagination--circle .v-pagination__navigation{border-radius:50%}.v-pagination--disabled{pointer-events:none;opacity:.6}.v-pagination__item{background:transparent;border-radius:4px;font-size:1rem;height:34px;margin:.3rem;min-width:34px;padding:0 5px;text-decoration:none;transition:.3s cubic-bezier(0,0,.2,1);width:auto;box-shadow:0 3px 1px -2px rgba(0,0,0,.2),0 2px 2px 0 rgba(0,0,0,.14),0 1px 5px 0 rgba(0,0,0,.12)}.v-pagination__item--active{box-shadow:0 2px 4px -1px rgba(0,0,0,.2),0 4px 5px 0 rgba(0,0,0,.14),0 1px 10px 0 rgba(0,0,0,.12)}.v-pagination__navigation{box-shadow:0 3px 1px -2px rgba(0,0,0,.2),0 2px 2px 0 rgba(0,0,0,.14),0 1px 5px 0 rgba(0,0,0,.12);border-radius:4px;display:inline-flex;justify-content:center;align-items:center;text-decoration:none;height:32px;width:32px;margin:.3rem 10px}.v-pagination__navigation .v-icon{transition:.2s cubic-bezier(.4,0,.6,1);vertical-align:middle}.v-pagination__navigation--disabled{opacity:.6;pointer-events:none}.v-pagination__more{margin:.3rem;display:inline-flex;align-items:flex-end;justify-content:center;height:32px;width:32px}",""]),t.exports=r},596:function(t,e,n){"use strict";n(11),n(13),n(14),n(15),n(12),n(16);var r=n(60),o=n(2),c=(n(22),n(579),n(32),n(48),n(6),n(47),n(76),n(580),n(89)),l=n(121),h=n(24),v=n(267),d=n(20),f=n(7);function m(t,e){var n=Object.keys(t);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(t);e&&(r=r.filter((function(e){return Object.getOwnPropertyDescriptor(t,e).enumerable}))),n.push.apply(n,r)}return n}e.a=Object(f.a)(h.a,Object(v.a)({onVisible:["init"]}),d.a).extend({name:"v-pagination",directives:{Resize:l.a},props:{circle:Boolean,disabled:Boolean,length:{type:Number,default:0,validator:function(t){return t%1==0}},nextIcon:{type:String,default:"$next"},prevIcon:{type:String,default:"$prev"},totalVisible:[Number,String],value:{type:Number,default:0},pageAriaLabel:{type:String,default:"$vuetify.pagination.ariaLabel.page"},currentPageAriaLabel:{type:String,default:"$vuetify.pagination.ariaLabel.currentPage"},previousAriaLabel:{type:String,default:"$vuetify.pagination.ariaLabel.previous"},nextAriaLabel:{type:String,default:"$vuetify.pagination.ariaLabel.next"},wrapperAriaLabel:{type:String,default:"$vuetify.pagination.ariaLabel.wrapper"}},data:function(){return{maxButtons:0,selected:null}},computed:{classes:function(){return function(t){for(var e=1;e<arguments.length;e++){var n=null!=arguments[e]?arguments[e]:{};e%2?m(Object(n),!0).forEach((function(e){Object(o.a)(t,e,n[e])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(n)):m(Object(n)).forEach((function(e){Object.defineProperty(t,e,Object.getOwnPropertyDescriptor(n,e))}))}return t}({"v-pagination":!0,"v-pagination--circle":this.circle,"v-pagination--disabled":this.disabled},this.themeClasses)},items:function(){var t=parseInt(this.totalVisible,10);if(0===t||isNaN(this.length)||this.length>Number.MAX_SAFE_INTEGER)return[];var e=Math.min(Math.max(0,t)||this.length,Math.max(0,this.maxButtons)||this.length,this.length);if(this.length<=e)return this.range(1,this.length);var n=e%2==0?1:0,o=Math.floor(e/2),c=this.length-o+1+n;if(this.value>o&&this.value<c){var l=this.length,h=this.value-o+2,v=this.value+o-2-n,d=v+1===l-1?v+1:"...";return[1,h-1==2?2:"..."].concat(Object(r.a)(this.range(h,v)),[d,this.length])}if(this.value===o){var f=this.value+o-1-n;return[].concat(Object(r.a)(this.range(1,f)),["...",this.length])}if(this.value===c){var m=this.value-o+1;return[1,"..."].concat(Object(r.a)(this.range(m,this.length)))}return[].concat(Object(r.a)(this.range(1,o)),["..."],Object(r.a)(this.range(c,this.length)))}},watch:{value:function(){this.init()}},beforeMount:function(){this.init()},methods:{init:function(){var t=this;this.selected=null,this.onResize(),this.$nextTick(this.onResize),setTimeout((function(){return t.selected=t.value}),100)},onResize:function(){var t=this.$el&&this.$el.parentElement?this.$el.parentElement.clientWidth:window.innerWidth;this.maxButtons=Math.floor((t-96)/42)},next:function(t){t.preventDefault(),this.$emit("input",this.value+1),this.$emit("next")},previous:function(t){t.preventDefault(),this.$emit("input",this.value-1),this.$emit("previous")},range:function(t,e){for(var n=[],i=t=t>0?t:1;i<=e;i++)n.push(i);return n},genIcon:function(t,e,n,r,label){return t("li",[t("button",{staticClass:"v-pagination__navigation",class:{"v-pagination__navigation--disabled":n},attrs:{disabled:n,type:"button","aria-label":label},on:n?{}:{click:r}},[t(c.a,[e])])])},genItem:function(t,i){var e=this,n=i===this.value&&(this.color||"primary"),r=i===this.value,o=r?this.currentPageAriaLabel:this.pageAriaLabel;return t("button",this.setBackgroundColor(n,{staticClass:"v-pagination__item",class:{"v-pagination__item--active":i===this.value},attrs:{type:"button","aria-current":r,"aria-label":this.$vuetify.lang.t(o,i)},on:{click:function(){return e.$emit("input",i)}}}),[i.toString()])},genItems:function(t){var e=this;return this.items.map((function(i,n){return t("li",{key:n},[isNaN(Number(i))?t("span",{class:"v-pagination__more"},[i.toString()]):e.genItem(t,i)])}))},genList:function(t,e){return t("ul",{directives:[{modifiers:{quiet:!0},name:"resize",value:this.onResize}],class:this.classes},e)}},render:function(t){var e=[this.genIcon(t,this.$vuetify.rtl?this.nextIcon:this.prevIcon,this.value<=1,this.previous,this.$vuetify.lang.t(this.previousAriaLabel)),this.genItems(t),this.genIcon(t,this.$vuetify.rtl?this.prevIcon:this.nextIcon,this.value>=this.length,this.next,this.$vuetify.lang.t(this.nextAriaLabel))];return t("nav",{attrs:{role:"navigation","aria-label":this.$vuetify.lang.t(this.wrapperAriaLabel)}},[this.genList(t,e)])}})},599:function(t,e,n){"use strict";var r=n(254),o=n(255),c=n(111),l=n(565),h=n(164),v=n(209),d=n(564),f=n(567),m=(n(35),n(32),n(119)),_=n(574),x={props:{questions:[]},mixins:[m.a,_.a]},y=n(69),component=Object(y.a)(x,(function(){var t=this,e=t._self._c;return e("div",t._l(t.questions,(function(n,m){return e(d.a,{key:"question_"+m,staticClass:"justify-center",attrs:{"mb-5":"","data-cy":"each-questions"}},[e(l.a,{attrs:{cols:"10"}},[e(o.a,{attrs:{elevation:"8",height:"250"}},[e(d.a,[e(l.a,{staticClass:"mt-8",attrs:{cols:"2"}},[e("div",{staticStyle:{cursor:"pointer"},on:{click:function(e){return t.goToUser(n.user)}}},[e(d.a,[e(l.a,{staticClass:"d-flex justify-center align-center text-center"},[e(r.a,{attrs:{size:"100"}},[e(v.a,{attrs:{src:n.user.image,alt:"画像",contain:""}})],1)],1)],1),t._v(" "),e(d.a,[e(l.a,{staticClass:"d-flex justify-center align-center text-center"},[e("span",{staticStyle:{"text-decoration":"underline"}},[t._v(t._s(t.$truncate(n.user.name,10)))])])],1)],1)]),t._v(" "),e(l.a,{staticClass:"mt-n2",attrs:{cols:"7"}},[e(c.d,[e("nuxt-link",{attrs:{to:"/books/".concat(n.book_id,"/questions/").concat(n.id)}},[t._v(t._s(t.$truncate(n.title,20)))])],1),t._v(" "),e(c.c,[e(f.a,{staticStyle:{height:"125px"},attrs:{value:n.content,readonly:"",filled:"",rounded:"",dense:"","no-resize":"",rows:"4"}})],1),t._v(" "),e(c.a,[e(d.a,{staticClass:"d-flex align-center justify-center"},[e(l.a,{attrs:{cols:"4"}},[e(h.a,[t._v("mdi-comment-text-outline")]),t._v("\n                  返信: "+t._s(n.replies_count)+"件\n                ")],1),t._v(" "),e(l.a,{attrs:{cols:"4"}},[e(h.a,[t._v("mdi-heart-multiple")]),t._v("\n                  いいね! ("+t._s(n.favorite_questions_count)+")\n                ")],1),t._v(" "),e(l.a,{attrs:{cols:"4"}},[e(h.a,[t._v("mdi-calendar-clock")]),t._v("\n                  "+t._s(n.created_at)+"\n                ")],1)],1),t._v(" "),e("p")],1)],1),t._v(" "),e(l.a,{staticClass:"mt-3",attrs:{cols:"3"}},[e("div",{staticStyle:{height:"250px"}},[e(d.a,{staticStyle:{"flex-direction":"column",height:"150px",width:"220px"}},[e(l.a,{staticClass:"d-flex justify-center align-center"},[e(v.a,{attrs:{src:n.book.image,alt:"画像",contain:"",height:"150",width:"220"}})],1)],1),t._v(" "),e(d.a,[e(l.a,{staticClass:"d-flex justify-center align-center mt-2"},[e("nuxt-link",{attrs:{to:"/books/".concat(n.book_id,"}")}},[t._v(t._s(t.$truncate(n.book.name,25)))])],1)],1)],1)])],1)],1)],1)],1)})),1)}),[],!1,null,null,null);e.a=component.exports},825:function(t,e,n){"use strict";n.r(e);var r=n(265),o=n(255),c=n(111),l=n(565),h=n(596),v=n(564),d=n(162),f=n(26),m=(n(55),n(82),n(599)),_=n(44),x={components:{EachQuestions:m.a},asyncData:function(t){return Object(f.a)(regeneratorRuntime.mark((function e(){var n,r;return regeneratorRuntime.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return n=t.route,e.prev=1,e.next=4,_.a.get("/questions/search_questions",{params:{searchQuestionsKeyword:n.query.searchQuestionsKeyword}});case 4:return r=e.sent,console.log(r.data),e.abrupt("return",{searchQuestionsResult:r.data.questions,totalCount:r.data.questions_count,searchQuestionsKeyword:n.query.searchQuestionsKeyword});case 9:throw e.prev=9,e.t0=e.catch(1),console.log(e.t0),e.t0;case 13:case"end":return e.stop()}}),e,null,[[1,9]])})))()},watch:{"$route.query.searchQuestionsKeyword":function(t,e){var n=this;t!==e&&this.updateSearchResult(t).then((function(t){n.searchQuestionsResult=t.questions,n.totalCount=t.questions_count})).catch((function(t){console.log(t)}))}},data:function(){return{newKeyword:"",perPage:10,page:1}},computed:{questionsChunk:function(){var t=(this.page-1)*this.perPage,e=t+this.perPage;return this.searchQuestionsResult.slice(t,e)},totalPages:function(){return Math.ceil(this.searchQuestionsResult.length/this.perPage)}},methods:{updateQueryParams:function(t){this.$router.push({query:{searchQuestionsKeyword:t}}),this.newKeyword=""},updateSearchResult:function(t){var e=this;return Object(f.a)(regeneratorRuntime.mark((function n(){var r;return regeneratorRuntime.wrap((function(n){for(;;)switch(n.prev=n.next){case 0:return n.prev=0,n.next=3,_.a.get("/questions/search_questions",{params:{searchQuestionsKeyword:t}});case 3:return r=n.sent,console.log(r.data),e.searchQuestionsKeyword=t,e.page=1,n.abrupt("return",r.data);case 10:n.prev=10,n.t0=n.catch(0),console.log(n.t0);case 13:case"end":return n.stop()}}),n,null,[[0,10]])})))()}}},y=n(69),component=Object(y.a)(x,(function(){var t=this,e=t._self._c;return e("div",[e("br"),e("br"),t._v(" "),e(v.a,[e(l.a,{staticClass:"d-flex justify-center",attrs:{cols:"12"}},[e(o.a,{attrs:{height:"130px",width:"85%"}},[e(c.d,{staticStyle:{height:"100%","align-items":"center"}},[e(v.a,[e(l.a,{attrs:{cols:"11"}},[e(d.a,{attrs:{filled:"",outlined:"",dense:"",label:"質問を再検索"},model:{value:t.newKeyword,callback:function(e){t.newKeyword=e},expression:"newKeyword"}})],1),t._v(" "),e(l.a,{attrs:{cols:"1"}},[e(r.a,{on:{click:function(e){return t.updateQueryParams(t.newKeyword)}}},[t._v("検索")])],1)],1)],1)],1)],1)],1),t._v(" "),e("br"),t._v(" "),e(v.a,[e(l.a,{staticClass:"d-flex justify-center"},[e("h2",[t._v("「"+t._s(t.searchQuestionsKeyword)+"」の検索結果"+t._s(t.totalCount)+"件 ")])])],1),t._v(" "),e("br"),e("br"),t._v(" "),t.searchQuestionsResult&&t.searchQuestionsResult.length>0?e("div",[e(h.a,{attrs:{length:t.totalPages},model:{value:t.page,callback:function(e){t.page=e},expression:"page"}}),t._v(" "),e("br"),t._v(" "),e("each-questions",{attrs:{questions:t.questionsChunk}}),t._v(" "),e(h.a,{attrs:{length:t.totalPages},model:{value:t.page,callback:function(e){t.page=e},expression:"page"}})],1):e("div",[e("p",[t._v("検索結果はありません")])])],1)}),[],!1,null,null,null);e.default=component.exports}}]);