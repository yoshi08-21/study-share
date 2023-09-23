(window.webpackJsonp=window.webpackJsonp||[]).push([[20],{820:function(e,t,o){"use strict";o.r(t);var n=o(265),r=o(255),c=o(111),l=o(565),d=o(262),f=o(209),v=o(596),h=o(803),m=o(802),k=o(564),_=o(566),y=o(777),x=o(162),w=(o(35),o(13),o(83),o(47),o(70),o(90),o(26)),j=(o(82),o(55),o(6),o(49),o(56),o(367),o(40),o(61),o(33),o(71),o(119)),C=o(44);function D(e,t){var o="undefined"!=typeof Symbol&&e[Symbol.iterator]||e["@@iterator"];if(!o){if(Array.isArray(e)||(o=function(e,t){if(!e)return;if("string"==typeof e)return S(e,t);var o=Object.prototype.toString.call(e).slice(8,-1);"Object"===o&&e.constructor&&(o=e.constructor.name);if("Map"===o||"Set"===o)return Array.from(e);if("Arguments"===o||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(o))return S(e,t)}(e))||t&&e&&"number"==typeof e.length){o&&(e=o);var i=0,n=function(){};return{s:n,n:function(){return i>=e.length?{done:!0}:{done:!1,value:e[i++]}},e:function(e){throw e},f:n}}throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}var r,c=!0,l=!1;return{s:function(){o=o.call(e)},n:function(){var e=o.next();return c=e.done,e},e:function(e){l=!0,r=e},f:function(){try{c||null==o.return||o.return()}finally{if(l)throw r}}}}function S(e,t){(null==t||t>e.length)&&(t=e.length);for(var i=0,o=new Array(t);i<t;i++)o[i]=e[i];return o}var B={mixins:[j.a],data:function(){return{keyword:"",searchResults:[],bookDialog:!1,book:{},items:["英語","数学","国語","社会","理科"],subject:"",perPage:10,page:1,cleanedErrorMessage:"",selectSubjectDialog:!1,categories:[{name:"国語",subcategories:["現代文","古文","漢文"]},{name:"社会",subcategories:["日本史","世界史","地理","倫理・政治経済"]},{name:"数学",subcategories:["数学I・A","数学Ⅱ・B","数学Ⅲ・C"]},{name:"英語",subcategories:["英文法","英文読解","英作文","英単語","リスニング"]},{name:"理科",subcategories:["物理","生物","化学","地学"]},{name:"その他",subcategories:["過去問","小論文","その他科目"]}],isInputBeingConverted:!1}},computed:{booksChunk:function(){var e=(this.page-1)*this.perPage,t=e+this.perPage;return this.searchResults.slice(e,t)},totalPages:function(){return Math.ceil(this.searchResults.length/this.perPage)}},methods:{searchBooks:function(){var e=this;return Object(w.a)(regeneratorRuntime.mark((function t(){var o,n,r,data,c,l,d,f,v,h,m,k;return regeneratorRuntime.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:if(t.prev=0,!1!==e.isInputBeingConverted){t.next=17;break}return e.searchResults=[],"https://www.googleapis.com/books/v1/volumes?",o={q:"intitle:".concat(e.keyword),maxResults:40},n=new URLSearchParams(o),t.next=8,fetch("https://www.googleapis.com/books/v1/volumes?"+n);case 8:return r=t.sent,t.next=11,r.json();case 11:data=t.sent,console.log(data),console.log(r),c=D(data.items);try{for(c.s();!(l=c.n()).done;)d=l.value,f=d.volumeInfo.title,v=d.volumeInfo.author,h=d.volumeInfo.publisher,m=d.volumeInfo.imageLinks,k=d.volumeInfo.description,e.searchResults.push({name:f||"不明",author:v||"不明",publisher:h||"不明",imageUrl:m?m.thumbnail:"",description:k?k.slice(0,40):"",fullDescription:k?k.slice(0,1e3):""})}catch(e){c.e(e)}finally{c.f()}e.page=1;case 17:t.next=23;break;case 19:throw t.prev=19,t.t0=t.catch(0),console.log(t.t0),t.t0;case 23:case"end":return t.stop()}}),t,null,[[0,19]])})))()},openBookDialog:function(e){this.book=e,this.subject="",this.bookDialog=!0},downloadImageFromUrl:function(e){return Object(w.a)(regeneratorRuntime.mark((function t(){var o,n;return regeneratorRuntime.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return t.next=2,fetch(e);case 2:return o=t.sent,t.next=5,o.blob();case 5:return n=t.sent,t.abrupt("return",new File([n],"downloaded-image.jpg",{type:n.type}));case 7:case"end":return t.stop()}}),t)})))()},submitBook:function(e){var t=this;return Object(w.a)(regeneratorRuntime.mark((function o(){var n,r,c,l,d,f,v,h,m;return regeneratorRuntime.wrap((function(o){for(;;)switch(o.prev=o.next){case 0:if((n=new FormData).append("current_user_id",t.currentUser.id),n.append("book[name]",e.name),n.append("book[author]",e.author),n.append("book[publisher]",e.publisher),n.append("book[subject]",t.subject),n.append("book[description]",e.fullDescription),!e.imageUrl){o.next=15;break}return r=encodeURIComponent(e.imageUrl),o.next=11,C.a.get("/books/download_book_image?image_url=".concat(r),{responseType:"blob"});case 11:c=o.sent,console.log(c),l=new Blob([c.data],{type:c.headers["content-type"]}),n.append("book[image]",l,"downloaded-image.jpg");case 15:return o.prev=15,o.next=18,C.a.post("/books",n);case 18:d=o.sent,console.log(d),t.$router.push({path:"/books/".concat(d.data.id),query:{message:"参考書の登録が完了しました"}}),o.next=26;break;case 23:if(o.prev=23,o.t0=o.catch(15),o.t0.response&&o.t0.response.data){console.log(o.t0),console.log(o.t0.response),console.log(o.t0.response.data),f=o.t0.response.data.errors,v=D(f);try{for(v.s();!(h=v.n()).done;)(m=h.value).includes("Name")&&(t.cleanedErrorMessage=m.replace("Name ",""))}catch(e){v.e(e)}finally{v.f()}console.log(t.cleanedErrorMessage),t.snackbarColor="red accent-2",t.snackbar=!0,t.flashMessage=t.cleanedErrorMessage}else console.log("リクエストエラー:",o.t0);case 26:t.bookDialog=!1;case 27:case"end":return o.stop()}}),o,null,[[15,23]])})))()},closeBookDialog:function(){this.bookDialog=!1,this.subject=""}}},I=o(69),component=Object(I.a)(B,(function(){var e=this,t=e._self._c;return t("div",[t("br"),t("br"),e._v(" "),t(k.a,[t(l.a,{staticClass:"d-flex justify-center",attrs:{cols:"12"}},[t(r.a,{attrs:{height:"130px",width:"85%"}},[t(c.d,{staticStyle:{height:"100%","align-items":"center"}},[t(k.a,[t(l.a,{attrs:{cols:"11"}},[t(x.a,{attrs:{filled:"",outlined:"",dense:"",label:"参考書を検索","data-cy":"google-books-api-search-books"},on:{keydown:function(t){return!t.type.indexOf("key")&&e._k(t.keyCode,"enter",13,t.key,"Enter")?null:e.searchBooks.apply(null,arguments)},compositionstart:function(t){e.isInputBeingConverted=!0},compositionend:function(t){e.isInputBeingConverted=!1}},model:{value:e.keyword,callback:function(t){e.keyword=t},expression:"keyword"}})],1),e._v(" "),t(l.a,{attrs:{cols:"1"}},[t(n.a,{attrs:{"data-cy":"google-books-api-search-button"},on:{click:e.searchBooks}},[e._v("検索")])],1)],1)],1)],1)],1)],1),e._v(" "),t("br"),t("br"),e._v(" "),0!==e.searchResults.length?[t(v.a,{attrs:{length:e.totalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}}),e._v(" "),t("br"),e._v(" "),e._l(e.booksChunk,(function(o,d){return t(k.a,{key:d,staticClass:"justify-center",attrs:{"mb-5":"","data-cy":"searched-books"}},[t(l.a,{attrs:{cols:"10"}},[t(r.a,{staticStyle:{"margin-bottom":"5px"},attrs:{elevation:"2","max-height":"300"}},[t(k.a,[t(l.a,{staticClass:"d-flex justify-center",attrs:{cols:"3"}},[o.imageUrl?t("div",{staticClass:"d-flex justify-center",staticStyle:{height:"210px"}},[t(f.a,{attrs:{src:o.imageUrl,alt:"画像",contain:"","max-height":"200","max-width":"180"}})],1):e._e()]),e._v(" "),t(l.a,{staticClass:"mt-n4",attrs:{cols:"9"}},[t("div",[t(c.d,[e._v("\n                  "+e._s(e.$truncate(o.name,100))+"\n                ")])],1),e._v(" "),t(c.c,[t("h4",[e._v("出版社: "+e._s(o.publisher))]),e._v(" "),t("h4",[e._v("著者: "+e._s(o.author))]),e._v(" "),t("br"),e._v(" "),t("p",[e._v("\n                  "+e._s(o.description)+"\n                ")])]),e._v(" "),t(c.a,[t(k.a,{staticClass:"d-flex align-center justify-center"},[t(l.a,{attrs:{cols:"4"}},[t(n.a,{attrs:{large:"","data-cy":"add-book"},on:{click:function(t){return e.openBookDialog(o)}}},[e._v("参考書を登録する")])],1)],1)],1)],1)],1)],1)],1)],1)})),e._v(" "),t("br"),e._v(" "),t(v.a,{attrs:{length:e.totalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}})]:e._e(),e._v(" "),t(d.a,{attrs:{"max-width":"1000px"},model:{value:e.bookDialog,callback:function(t){e.bookDialog=t},expression:"bookDialog"}},[t(k.a,[t(l.a,{attrs:{cols:"12"}},[e.book?t(r.a,[t(c.d,{staticStyle:{"justify-content":"center"}},[t("h2",[e._v("参考書を登録する")])]),e._v(" "),t(r.a,[t(k.a,[t(l.a,{attrs:{cols:"2"}},[e.book.imageUrl?t("div",{staticClass:"d-flex justify-center",staticStyle:{height:"210px"}},[t(f.a,{attrs:{src:e.book.imageUrl,alt:"画像",contain:"","max-height":"250","max-width":"230"}})],1):e._e()]),e._v(" "),t(l.a,{attrs:{cols:"10"}},[t(c.d,[e._v("\n                  タイトル: "+e._s(e.book.name)+"\n                ")]),e._v(" "),t(c.c,[t("p",[e._v("著者: "+e._s(e.book.author))]),e._v(" "),t("p",[e._v("出版社: "+e._s(e.book.publisher))]),e._v(" "),t("p",[e._v("説明文: "+e._s(e.book.fullDescription))])])],1)],1),e._v(" "),t("br"),e._v(" "),t(c.a,[t(k.a,{staticClass:"d-flex justify-center"},[t(l.a,{staticClass:"d-flex justify-center",attrs:{cols:"8"}},[t(r.a,{staticStyle:{padding:"10px"},attrs:{height:"100",width:"500",elevation:"0"}},[t(k.a,[t(l.a,{staticClass:"d-flex justify-center"},[t(n.a,{attrs:{block:""},on:{click:function(t){e.selectSubjectDialog=!0}}},[e._v("科目を選択する(必須)")])],1)],1),e._v(" "),t(k.a,[t(l.a,{staticClass:"d-flex justify-center"},[e.subject?t("h3",[e._v("選択された科目："+e._s(e.subject))]):e._e()])],1)],1)],1)],1)],1),e._v(" "),t("br"),e._v(" "),t(k.a,{staticClass:"d-flex justify-space-around"},[t(l.a,{staticClass:"d-flex justify-center",attrs:{cols:"6"}},[""==e.subject?[t(n.a,{attrs:{color:"primary",disabled:"",width:"400",large:""},on:{click:function(t){return e.submitBook(e.book)}}},[e._v("\n                    登録する\n                  ")])]:[t(n.a,{attrs:{color:"primary",width:"400",large:"","data-cy":"submit-book"},on:{click:function(t){return e.submitBook(e.book)}}},[e._v("\n                    登録する\n                  ")])]],2),e._v(" "),t(l.a,{staticClass:"d-flex justify-center",attrs:{cols:"6"}},[t(n.a,{attrs:{large:"",width:"400"},on:{click:e.closeBookDialog}},[e._v("\n                  戻る\n                ")])],1)],1)],1)],1):e._e()],1)],1)],1),e._v(" "),t(d.a,{attrs:{"max-width":"500px"},model:{value:e.selectSubjectDialog,callback:function(t){e.selectSubjectDialog=t},expression:"selectSubjectDialog"}},[t(r.a,[t(c.d,{staticClass:"headline"},[e._v("科目選択")]),e._v(" "),t(c.c,[t(m.a,{attrs:{"data-cy":"select-subject-group"},model:{value:e.subject,callback:function(t){e.subject=t},expression:"subject"}},[e._l(e.categories,(function(o){return[t("p",{key:o.name},[e._v(e._s(o.name))]),e._v(" "),e._l(o.subcategories,(function(e){return t(h.a,{key:e,attrs:{label:e,value:e}})}))]}))],2)],1),e._v(" "),t("h3",[e._v("選択された科目:"+e._s(e.subject))]),e._v(" "),t(c.a,[t(y.a),e._v(" "),t(n.a,{attrs:{color:"primary",block:"","data-cy":"close-select-subject-dialog"},on:{click:function(t){e.selectSubjectDialog=!1}}},[e._v("閉じる")])],1)],1)],1),e._v(" "),t("br"),e._v(" "),t(_.a,{attrs:{timeout:3e3,color:e.snackbarColor},model:{value:e.snackbar,callback:function(t){e.snackbar=t},expression:"snackbar"}},[e._v(e._s(e.flashMessage))])],2)}),[],!1,null,null,null);t.default=component.exports}}]);