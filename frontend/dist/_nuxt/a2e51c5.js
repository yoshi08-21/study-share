(window.webpackJsonp=window.webpackJsonp||[]).push([[18],{574:function(e,t,n){"use strict";t.a={methods:{goToUser:function(e){this.currentUser&&this.currentUser.id===e.id?this.$router.push({path:"/mypage"}):this.$router.push({path:"/users/".concat(e.id)})}}}},576:function(e,t,n){"use strict";t.a={data:function(){return{snackbar:!1,snackbarColor:"primary",flashMessage:""}},mounted:function(){this.$route.query.message&&(this.snackbarColor="primary",this.snackbar=!0,this.flashMessage=this.$route.query.message)}}},577:function(e,t,n){"use strict";n.r(t);var o=n(601),r=n(265),l=n(255),c=n(111),d=n(565),v=n(262),h=n(564),f={props:{showDeleteConfirmation:Boolean,contentTitle:String},data:function(){return{localShowDeleteConfirmation:this.showDeleteConfirmation}},watch:{showDeleteConfirmation:function(e){this.localShowDeleteConfirmation=e}},methods:{deleteContent:function(){this.$emit("deleteContent")},closeDeleteConfirmation:function(){this.$emit("closeDeleteConfirmation")}}},m=n(69),component=Object(m.a)(f,(function(){var e=this,t=e._self._c;return t(v.a,{attrs:{width:"800"},model:{value:e.localShowDeleteConfirmation,callback:function(t){e.localShowDeleteConfirmation=t},expression:"localShowDeleteConfirmation"}},[t(l.a,{attrs:{height:"300"}},[t(h.a,{staticClass:"d-flex justify-center"},[t(d.a,[t(c.d,{staticStyle:{height:"120px"}},[t(o.a,{attrs:{type:"error",dense:"",text:"",prominent:"",border:"left",width:"100%"}},[e._v("\n            削除した"+e._s(e.contentTitle)+"は復元できません!\n          ")])],1),e._v(" "),t(c.c,{staticStyle:{"text-align":"center",height:"90px"}},[t("h1",[e._v("\n            "+e._s(e.contentTitle)+"を削除しますか？\n          ")])]),e._v(" "),t(c.a,[t(h.a,[t(d.a,{staticClass:"d-flex justify-center",attrs:{cols:"6"}},[t(r.a,{attrs:{large:"",width:"300",color:"error",dark:"","data-cy":"delete-confirm-button"},on:{click:e.deleteContent}},[e._v("\n                削除する\n              ")])],1),e._v(" "),t(d.a,{staticClass:"d-flex justify-center",attrs:{cols:"6"}},[t(r.a,{attrs:{large:"",width:"300"},on:{click:e.closeDeleteConfirmation}},[e._v("\n                戻る\n              ")])],1)],1)],1)],1)],1)],1)],1)}),[],!1,null,null,null);t.default=component.exports},582:function(e,t,n){"use strict";t.a={methods:{checkFileSize:function(e){console.log(e);e&&e.size>3145728?(this.errorMessage="添付できるファイルは3MBまでです",this.error=!0):(this.errorMessage="",this.error=!1)}}}},583:function(e,t,n){var content=n(584);content.__esModule&&(content=content.default),"string"==typeof content&&(content=[[e.i,content,""]]),content.locals&&(e.exports=content.locals);(0,n(18).default)("5939d713",content,!0,{sourceMap:!1})},584:function(e,t,n){var o=n(17)(!1);o.push([e.i,".v-rating{max-width:100%;white-space:nowrap}.v-rating .v-icon{padding:.5rem;border-radius:50%;-webkit-user-select:none;-moz-user-select:none;user-select:none;outline:none}.v-rating .v-icon:after{display:none}.v-application--is-ltr .v-rating .v-icon{transform:scaleX(1)}.v-application--is-rtl .v-rating .v-icon{transform:scaleX(-1)}.v-rating--readonly .v-icon{pointer-events:none}.v-rating--dense .v-icon{padding:.1rem}",""]),e.exports=o},598:function(e,t,n){"use strict";n(22),n(266),n(76),n(583);var o=n(89),r=n(24),l=n(122),c=n(171),d=n(578),v=n(20),h=n(1),f=n(7);t.a=Object(f.a)(r.a,l.a,d.a,c.a,v.a).extend({name:"v-rating",props:{backgroundColor:{type:String,default:"accent"},color:{type:String,default:"primary"},clearable:Boolean,dense:Boolean,emptyIcon:{type:String,default:"$ratingEmpty"},fullIcon:{type:String,default:"$ratingFull"},halfIcon:{type:String,default:"$ratingHalf"},halfIncrements:Boolean,hover:Boolean,length:{type:[Number,String],default:5},readonly:Boolean,size:[Number,String],value:{type:Number,default:0},iconLabel:{type:String,default:"$vuetify.rating.ariaLabel.icon"}},data:function(){return{hoverIndex:-1,internalValue:this.value}},computed:{directives:function(){return this.readonly||!this.ripple?[]:[{name:"ripple",value:{circle:!0}}]},iconProps:function(){var e=this.$props,t=e.dark,n=e.large,o=e.light,r=e.medium,small=e.small;return{dark:t,large:n,light:o,medium:r,size:e.size,small:small,xLarge:e.xLarge,xSmall:e.xSmall}},isHovering:function(){return this.hover&&this.hoverIndex>=0}},watch:{internalValue:function(e){e!==this.value&&this.$emit("input",e)},value:function(e){this.internalValue=e}},methods:{createClickFn:function(i){var e=this;return function(t){if(!e.readonly){var n=e.genHoverIndex(t,i);e.clearable&&e.internalValue===n?e.internalValue=0:e.internalValue=n}}},createProps:function(i){var e={index:i,value:this.internalValue,click:this.createClickFn(i),isFilled:Math.floor(this.internalValue)>i,isHovered:Math.floor(this.hoverIndex)>i};return this.halfIncrements&&(e.isHalfHovered=!e.isHovered&&(this.hoverIndex-i)%1>0,e.isHalfFilled=!e.isFilled&&(this.internalValue-i)%1>0),e},genHoverIndex:function(e,i){var t=this.isHalfEvent(e);return this.halfIncrements&&this.$vuetify.rtl&&(t=!t),i+(t?.5:1)},getIconName:function(e){var t=this.isHovering?e.isHovered:e.isFilled,n=this.isHovering?e.isHalfHovered:e.isHalfFilled;return t?this.fullIcon:n?this.halfIcon:this.emptyIcon},getColor:function(e){if(this.isHovering){if(e.isHovered||e.isHalfHovered)return this.color}else if(e.isFilled||e.isHalfFilled)return this.color;return this.backgroundColor},isHalfEvent:function(e){if(this.halfIncrements){var rect=e.target&&e.target.getBoundingClientRect();if(rect&&e.pageX-rect.left<rect.width/2)return!0}return!1},onMouseEnter:function(e,i){var t=this;this.runDelay("open",(function(){t.hoverIndex=t.genHoverIndex(e,i)}))},onMouseLeave:function(){var e=this;this.runDelay("close",(function(){return e.hoverIndex=-1}))},genItem:function(i){var e=this,t=this.createProps(i);if(this.$scopedSlots.item)return this.$scopedSlots.item(t);var n={click:t.click};return this.hover&&(n.mouseenter=function(t){return e.onMouseEnter(t,i)},n.mouseleave=this.onMouseLeave,this.halfIncrements&&(n.mousemove=function(t){return e.onMouseEnter(t,i)})),this.$createElement(o.a,this.setTextColor(this.getColor(t),{attrs:{"aria-label":this.$vuetify.lang.t(this.iconLabel,i+1,Number(this.length))},directives:this.directives,props:this.iconProps,on:n}),[this.getIconName(t)])}},render:function(e){var t=this,n=Object(h.h)(Number(this.length)).map((function(i){return t.genItem(i)}));return e("div",{staticClass:"v-rating",class:{"v-rating--readonly":this.readonly,"v-rating--dense":this.dense}},n)}})},806:function(e,t,n){"use strict";n.r(t);var o=n(601),r=n(265),l=n(255),c=n(111),d=n(565),v=n(262),h=n(550),f=n(164),m=n(209),_=n(596),k=n(598),x=n(564),y=n(566),w=n(800),C=n(831),D=n(567),j=(n(35),n(13),n(83),n(30)),S=n(26),F=(n(82),n(6),n(49),n(56),n(55),n(32),n(625)),R=n(162),B=n(213),$={components:{VTextField:R.a,VTextarea:D.a,VRating:k.a,SubmitButton:B.default},data:function(){return{rating:1,title:"",content:"",titleRules:[function(e){return!!e||"タイトルを入力してください"},function(e){return(e||"").length<=60||"最大入力文字数は60文字です"}],contentRules:[function(e){return!!e||"本文を入力してください"},function(e){return(e||"").length<=1e3||"最大入力文字数は1000文字です"}]}},methods:{submitForm:function(){this.$emit("submitReview",{title:this.title,content:this.content,rating:this.rating})}}},M=n(69),component=Object(M.a)($,(function(){var e=this,t=e._self._c;return t("div",[t("br"),e._v(" "),t(F.a,[t(k.a,{attrs:{"background-color":"orange lighten-3",color:"orange",large:""},model:{value:e.rating,callback:function(t){e.rating=t},expression:"rating"}}),e._v(" "),t(R.a,{attrs:{counter:"",label:"タイトル",rules:e.titleRules,"data-cy":"review-title-form"},model:{value:e.title,callback:function(t){e.title=t},expression:"title"}}),e._v(" "),t(D.a,{attrs:{outlined:"",counter:"",label:"本文",rules:e.contentRules,"data-cy":"review-content-form"},model:{value:e.content,callback:function(t){e.content=t},expression:"content"}}),e._v(" "),t("submit-button",{attrs:{buttonTitle:"投稿する"},on:{submitForm:e.submitForm,closeDialog:function(t){return e.$emit("closeDialog")}}})],1)],1)}),[],!1,null,null,null),I=component.exports;installComponents(component,{SubmitButton:n(213).default});var T=n(801),H=n(582),P={components:{VTextField:R.a,VTextarea:D.a,SubmitButton:B.default},mixins:[H.a],data:function(){return{title:"",content:"",titleRules:[function(e){return!!e||"タイトルを入力してください"},function(e){return(e||"").length<=60||"最大入力文字数は60文字です"}],contentRules:[function(e){return!!e||"本文を入力してください"},function(e){return(e||"").length<=1e3||"最大入力文字数は1000文字です"}],selectedFile:null,errorMessage:"",error:!1}},methods:{submitForm:function(){this.$emit("submitQuestion",{title:this.title,content:this.content,image:this.selectedFile})}}},O=Object(M.a)(P,(function(){var e=this,t=e._self._c;return t("div",[t("br"),e._v(" "),t(F.a,[t(R.a,{attrs:{counter:"",label:"タイトル",rules:e.titleRules,"data-cy":"question-title-form"},model:{value:e.title,callback:function(t){e.title=t},expression:"title"}}),e._v(" "),t(D.a,{attrs:{outlined:"",counter:"",label:"本文",rules:e.contentRules,"data-cy":"question-content-form"},model:{value:e.content,callback:function(t){e.content=t},expression:"content"}}),e._v("\n    *画像を添付できます(「.jpeg」「.jpg」「.png」のみ添付できます)\n    "),t("br"),e._v("\n    *添付できる画像のファイルサイズは3MBまでです\n    "),t("br"),t("br"),e._v(" "),t(T.a,{staticStyle:{width:"500px"},attrs:{accept:"image/jpeg, image/png","show-size":"","truncate-length":"15",outlined:"",label:"ファイルを選択","prepend-icon":"mdi-image-plus"},on:{change:e.checkFileSize},model:{value:e.selectedFile,callback:function(t){e.selectedFile=t},expression:"selectedFile"}}),e._v(" "),e.errorMessage?[t(o.a,{attrs:{type:"error",dense:"",text:"",border:"left"}},[e._v("\n        "+e._s(e.errorMessage)+"\n      ")])]:e._e(),e._v(" "),t("submit-button",{attrs:{error:e.error,buttonTitle:"投稿する"},on:{submitForm:e.submitForm,closeDialog:function(t){return e.$emit("closeDialog")}}})],2)],1)}),[],!1,null,null,null),U=O.exports;installComponents(O,{SubmitButton:n(213).default});var V=n(254),z=n(119),N=n(574),E={props:{reviews:[]},mixins:[z.a,N.a]},Q=Object(M.a)(E,(function(){var e=this,t=e._self._c;return t("div",e._l(e.reviews,(function(n,o){return t(x.a,{key:"review_"+o,staticClass:"justify-center",attrs:{"mb-5":""}},[t(d.a,{attrs:{cols:"10"}},[t(l.a,{attrs:{elevation:"8",height:"260"}},[t(x.a,[t(d.a,{staticClass:"mt-8",attrs:{cols:"2"}},[t("div",{staticStyle:{cursor:"pointer"},on:{click:function(t){return e.goToUser(n.user)}}},[t(x.a,[t(d.a,{staticClass:"d-flex justify-center align-center text-center"},[t(V.a,{attrs:{size:"100"}},[t(m.a,{attrs:{src:n.user.image,alt:"画像",contain:""}})],1)],1)],1),e._v(" "),t(x.a,[t(d.a,{staticClass:"d-flex justify-center align-center text-center"},[t("span",{staticStyle:{"text-decoration":"underline"}},[e._v(e._s(e.$truncate(n.user.name,10)))])])],1)],1)]),e._v(" "),t(d.a,{staticClass:"mt-n2",attrs:{cols:"9"}},[t(c.d,[t("nuxt-link",{attrs:{to:"/books/".concat(n.book_id,"/reviews/").concat(n.id)}},[e._v(e._s(e.$truncate(n.title,30)))])],1),e._v(" "),t(c.b,{staticStyle:{"margin-top":"-20px"}},[t(x.a,{staticClass:"d-flex align-center"},[t(d.a,{attrs:{cols:"3"}},[t(k.a,{attrs:{readonly:!0,"background-color":"orange lighten-3",color:"orange",dense:""},model:{value:n.rating,callback:function(t){e.$set(n,"rating",t)},expression:"review.rating"}})],1),e._v(" "),t(d.a,{attrs:{cols:"2"}},[t("h2",[e._v("\n                        ("+e._s(n.rating)+")\n                      ")])])],1)],1),e._v(" "),t(c.c,[t(D.a,{staticStyle:{height:"125px"},attrs:{value:n.content,readonly:"",filled:"",rounded:"",dense:"","no-resize":"",rows:"4"}})],1),e._v(" "),t(c.a,{staticStyle:{"margin-top":"-20px"}},[t(x.a,{staticClass:"d-flex align-center justify-center"},[t(d.a,{attrs:{cols:"4"}},[t(f.a,[e._v("mdi-heart-multiple")]),e._v("\n                    いいね! ("+e._s(n.favorite_reviews_count)+")\n                  ")],1),e._v(" "),t(d.a,{attrs:{cols:"4"}},[t(f.a,[e._v("mdi-calendar-clock")]),e._v("\n                    "+e._s(n.created_at)+"\n                  ")],1)],1),e._v(" "),t("p")],1)],1)],1)],1)],1)],1)})),1)}),[],!1,null,null,null).exports,L={props:{questions:[]},mixins:[z.a,N.a]},A=Object(M.a)(L,(function(){var e=this,t=e._self._c;return t("div",e._l(e.questions,(function(n,o){return t(x.a,{key:"question_"+o,staticClass:"justify-center",attrs:{"mb-5":""}},[t(d.a,{attrs:{cols:"10"}},[t(l.a,{attrs:{elevation:"8",height:"250"}},[t(x.a,[t(d.a,{staticClass:"mt-8",attrs:{cols:"2"}},[t("div",{staticStyle:{cursor:"pointer"},on:{click:function(t){return e.goToUser(n.user)}}},[t(x.a,[t(d.a,{staticClass:"d-flex justify-center align-center text-center"},[t(V.a,{attrs:{size:"100"}},[t(m.a,{attrs:{src:n.user.image,alt:"画像",contain:""}})],1)],1)],1),e._v(" "),t(x.a,[t(d.a,{staticClass:"d-flex justify-center align-center text-center"},[t("span",{staticStyle:{"text-decoration":"underline"}},[e._v(e._s(e.$truncate(n.user.name,10)))])])],1)],1)]),e._v(" "),t(d.a,{staticClass:"mt-n2",attrs:{cols:"9"}},[t(c.d,[t("nuxt-link",{attrs:{to:"/books/".concat(n.book_id,"/questions/").concat(n.id)}},[e._v(e._s(e.$truncate(n.title,30)))])],1),e._v(" "),t(c.c,[t(D.a,{staticStyle:{height:"125px"},attrs:{value:n.content,readonly:"",filled:"",rounded:"",dense:"","no-resize":"",rows:"4"}})],1),e._v(" "),t(c.a,[t(x.a,{staticClass:"d-flex align-center justify-center"},[t(d.a,{attrs:{cols:"4"}},[t(f.a,[e._v("mdi-comment-text-outline")]),e._v("\n                  返信: "+e._s(n.replies_count)+"件\n                ")],1),e._v(" "),t(d.a,{attrs:{cols:"4"}},[t(f.a,[e._v("mdi-heart-multiple")]),e._v("\n                  いいね!: "+e._s(n.favorite_questions_count)+"\n                ")],1),e._v(" "),t(d.a,{attrs:{cols:"4"}},[t(f.a,[e._v("mdi-calendar-clock")]),e._v("\n                  "+e._s(n.created_at)+"\n                ")],1)],1),e._v(" "),t("p")],1)],1)],1)],1)],1)],1)})),1)}),[],!1,null,null,null).exports,X=n(803),J=n(802),G=n(777),K={props:{name:String,author:String,publisher:String,subject:String,description:String},components:{VTextField:R.a,SubmitButton:B.default},mixins:[H.a],data:function(){return{editedName:this.name,editedAuthor:this.author,editedPublisher:this.publisher,editedSubject:this.subject,editedDescription:this.description,titleRules:[function(e){return!!e||"タイトルを入力してください"},function(e){return(e||"").length<=50||"最大入力文字数は50文字です"}],authorRules:[function(e){return!!e||"著者を入力してください"},function(e){return(e||"").length<=25||"最大入力文字数は25文字です"}],publisherRules:[function(e){return(e||"").length<=25||"最大入力文字数は25文字です"}],descriptionRules:[function(e){return(e||"").length<=1e3||"最大入力文字数は1000文字です"}],selectSubjectDialog:!1,categories:[{name:"国語",subcategories:["現代文","古文","漢文"]},{name:"社会",subcategories:["日本史","世界史","地理","倫理・政治経済"]},{name:"数学",subcategories:["数学I・A","数学Ⅱ・B","数学Ⅲ・C"]},{name:"英語",subcategories:["英文法","英文読解","英作文","英単語","リスニング"]},{name:"理科",subcategories:["物理","生物","化学","地学"]},{name:"その他",subcategories:["過去問","小論文","その他科目"]}],selectedFile:null,errorMessage:"",error:!1}},methods:{submitForm:function(){this.$emit("submitBook",{name:this.editedName,author:this.editedAuthor,publisher:this.editedPublisher,subject:this.editedSubject,image:this.selectedFile,description:this.editedDescription})}}},W=Object(M.a)(K,(function(){var e=this,t=e._self._c;return t("div",[t("br"),e._v(" "),t(F.a,[t(d.a,{staticClass:"d-flex",attrs:{cols:"12",sm:"6"}},[t(r.a,{on:{click:function(t){e.selectSubjectDialog=!0}}},[e._v("科目を選択する(必須)")])],1),e._v(" "),e.editedSubject?t("h3",[e._v("選択された科目:"+e._s(e.editedSubject))]):e._e(),e._v(" "),t("br"),t("br"),e._v(" "),t(T.a,{staticStyle:{width:"500px"},attrs:{accept:"image/jpeg, image/png","show-size":"","truncate-length":"15",outlined:"",label:"参考書の画像を登録してください","prepend-icon":"mdi-image-plus"},on:{change:e.checkFileSize},model:{value:e.selectedFile,callback:function(t){e.selectedFile=t},expression:"selectedFile"}}),e._v("\n    *画像は「.jpeg」「.jpg」「.png」のみ登録できます\n    "),t("br"),e._v("\n    *登録できる画像のファイルサイズは3MBまでです\n\n    "),t("br"),t("br"),e._v(" "),t(R.a,{attrs:{counter:"",label:"タイトル",rules:e.titleRules,"data-cy":"edit-name-field"},model:{value:e.editedName,callback:function(t){e.editedName=t},expression:"editedName"}}),e._v(" "),t(R.a,{attrs:{counter:"",label:"著者",rules:e.authorRules,"data-cy":"edit-author-field"},model:{value:e.editedAuthor,callback:function(t){e.editedAuthor=t},expression:"editedAuthor"}}),e._v(" "),t(R.a,{attrs:{counter:"",label:"出版社",rules:e.publisherRules,"data-cy":"edit-publisher-field"},model:{value:e.editedPublisher,callback:function(t){e.editedPublisher=t},expression:"editedPublisher"}}),e._v(" "),t(D.a,{attrs:{counter:"",outlined:"",label:"参考書の説明",rules:e.descriptionRules,"data-cy":"edit-description-field"},model:{value:e.editedDescription,callback:function(t){e.editedDescription=t},expression:"editedDescription"}}),e._v(" "),e.errorMessage?[t(o.a,{attrs:{type:"error",dense:"",text:"",border:"left"}},[e._v("\n        "+e._s(e.errorMessage)+"\n      ")])]:e._e(),e._v(" "),t("submit-button",{attrs:{error:e.error,buttonTitle:"編集する"},on:{submitForm:e.submitForm,closeDialog:function(t){return e.$emit("closeDialog")}}})],2),e._v(" "),t(v.a,{attrs:{"max-width":"500px"},model:{value:e.selectSubjectDialog,callback:function(t){e.selectSubjectDialog=t},expression:"selectSubjectDialog"}},[t(l.a,[t(c.d,{staticClass:"headline"},[e._v("科目選択")]),e._v(" "),t(c.c,[t(J.a,{attrs:{"data-cy":"select-subject-group"},model:{value:e.editedSubject,callback:function(t){e.editedSubject=t},expression:"editedSubject"}},[e._l(e.categories,(function(n){return[t("p",{key:n.name},[e._v(e._s(n.name))]),e._v(" "),e._l(n.subcategories,(function(e){return t(X.a,{key:e,attrs:{label:e,value:e}})}))]}))],2)],1),e._v(" "),t("h3",[e._v("選択された科目:"+e._s(e.editededitedSubject))]),e._v(" "),t(c.a,[t(G.a),e._v(" "),t(r.a,{attrs:{color:"primary",block:"","data-cy":"close-select-subject-dialog"},on:{click:function(t){e.selectSubjectDialog=!1}}},[e._v("閉じる")])],1)],1)],1)],1)}),[],!1,null,null,null),Y=W.exports;installComponents(W,{SubmitButton:n(213).default});var Z=n(577),ee=n(576),te=n(44),ae={components:{ReviewForm:I,QuestionForm:U,VDialog:v.a,VDivider:h.a,BookReviews:Q,BookQuestions:A,EditBook:Y,DeleteConfirmationDialog:Z.default},mixins:[z.a,ee.a],asyncData:function(e){return Object(S.a)(regeneratorRuntime.mark((function t(){var n,o,r,l,c,d,v,h,f,m,_,k;return regeneratorRuntime.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return n=e.params,o=e.store,t.prev=1,r=null,(l=o.getters["auth/getCurrentUser"])&&l.id&&(r=l.id),t.next=7,Promise.all([te.a.get("/books/".concat(n.id),{params:{current_user_id:r}}),te.a.get("/books/".concat(n.id,"/reviews")),te.a.get("/books/".concat(n.id,"/questions"))]);case 7:return c=t.sent,d=Object(j.a)(c,3),v=d[0],h=d[1],f=d[2],m=v.data,_=h.data,k=f.data,console.log(m),console.log(_),console.log(k),t.abrupt("return",{book:m,reviews:_,questions:k,params:n});case 21:throw t.prev=21,t.t0=t.catch(1),console.log(t.t0),t.t0;case 25:case"end":return t.stop()}}),t,null,[[1,21]])})))()},data:function(){return{book:null,isFavorite:!1,favoriteBookId:"",reviewDialog:!1,reviews:[],perPage:10,page:1,questionDialog:!1,editBookDialog:!1,showDeleteConfirmation:!1,tab:0,tabs:[{label:"レビュー"},{label:"質問"}]}},computed:{reviewsChunk:function(){var e=(this.page-1)*this.perPage,t=e+this.perPage;return this.reviews.slice(e,t)},questionsChunk:function(){var e=(this.page-1)*this.perPage,t=e+this.perPage;return this.questions.slice(e,t)},reviewsTotalPages:function(){return Math.ceil(this.reviews.length/this.perPage)},questionsTotalPages:function(){return Math.ceil(this.questions.length/this.perPage)}},created:function(){var e=this;return Object(S.a)(regeneratorRuntime.mark((function t(){var n,o,r;return regeneratorRuntime.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return t.prev=0,n="",(o=e.$store.getters["auth/getCurrentUser"])&&o.id&&(n=o.id),t.next=6,te.a.get("books/is_favorite",{params:{current_user_id:n,book_id:e.$route.params.id}});case 6:r=t.sent,console.log(r),e.isFavorite=r.data.is_favorite,e.favoriteBookId=r.data.favorite_book_id,t.next=15;break;case 12:t.prev=12,t.t0=t.catch(0),console.log(t.t0);case 15:case"end":return t.stop()}}),t,null,[[0,12]])})))()},methods:{addToFavorites:function(){var e=this;return Object(S.a)(regeneratorRuntime.mark((function t(){var n;return regeneratorRuntime.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:if(!e.currentUser){t.next=21;break}return t.prev=1,t.next=4,te.a.post("/books/".concat(e.book.id,"/favorite_books"),{current_user_id:e.currentUser.id});case 4:n=t.sent,console.log(n.data),e.isFavorite=!e.isFavorite,e.favoriteBookId=n.data.favorite_book_id,e.snackbar=!0,e.flashMessage="お気に入りに追加しました",e.book.favorite_books_count+=1,t.next=19;break;case 13:t.prev=13,t.t0=t.catch(1),console.log(t.t0),e.snackbarColor="red accent-2",e.snackbar=!0,e.flashMessage="すでにお気に入りに追加されています";case 19:t.next=22;break;case 21:e.$router.push({path:"/auth/login",query:{message:"ログインが必要です"}});case 22:case"end":return t.stop()}}),t,null,[[1,13]])})))()},removeFromFavorite:function(){var e=this;return Object(S.a)(regeneratorRuntime.mark((function t(){var n;return regeneratorRuntime.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return t.prev=0,t.next=3,te.a.delete("/books/".concat(e.book.id,"/favorite_books/").concat(e.favoriteBookId),{params:{current_user_id:e.currentUser.id}});case 3:n=t.sent,console.log(n),e.isFavorite=!e.isFavorite,e.snackbar=!0,e.flashMessage="お気に入りから削除しました",e.book.favorite_books_count-=1,t.next=17;break;case 11:t.prev=11,t.t0=t.catch(0),console.log(t.t0),e.snackbarColor="red accent-2",e.snackbar=!0,e.flashMessage="お気に入りに登録されていません";case 17:case"end":return t.stop()}}),t,null,[[0,11]])})))()},submitReview:function(data){var e=this;return Object(S.a)(regeneratorRuntime.mark((function t(){var n;return regeneratorRuntime.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return t.prev=0,t.next=3,te.a.post("/books/".concat(e.book.id,"/reviews"),{review:{title:data.title,content:data.content,rating:data.rating},current_user_id:e.currentUser.id});case 3:n=t.sent,console.log(n),e.$router.push({path:"/books/".concat(e.book.id,"/reviews/").concat(n.data.id),query:{message:"レビューの投稿が完了しました"}}),t.next=14;break;case 8:t.prev=8,t.t0=t.catch(0),console.log(t.t0),e.snackbarColor="red accent-2",e.snackbar=!0,e.flashMessage="レビューを投稿できませんでした";case 14:e.dialog=!1;case 15:case"end":return t.stop()}}),t,null,[[0,8]])})))()},submitQuestion:function(data){var e=this;return Object(S.a)(regeneratorRuntime.mark((function t(){var n,o;return regeneratorRuntime.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return(n=new FormData).append("current_user_id",e.currentUser.id),n.append("question[book_id]",e.book.id),n.append("question[title]",data.title),n.append("question[content]",data.content),n.append("question[subject]",e.book.subject),data.image&&n.append("question[image]",data.image),t.prev=7,t.next=10,te.a.post("/books/".concat(e.book.id,"/questions"),n);case 10:o=t.sent,console.log(o),e.$router.push({path:"/books/".concat(e.book.id,"/questions/").concat(o.data.id),query:{message:"質問の投稿が完了しました"}}),t.next=21;break;case 15:t.prev=15,t.t0=t.catch(7),console.log(t.t0),e.snackbarColor="red accent-2",e.snackbar=!0,e.flashMessage="質問を投稿できませんでした";case 21:e.questionDialog=!1;case 22:case"end":return t.stop()}}),t,null,[[7,15]])})))()},openReviewDialog:function(){this.currentUser?this.reviewDialog=!0:this.$router.push({path:"/auth/login",query:{message:"ログインが必要です"}})},openQuestionDialog:function(){this.currentUser?this.questionDialog=!0:this.$router.push({path:"/auth/login",query:{message:"ログインが必要です"}})},editBook:function(data){var e=this;return Object(S.a)(regeneratorRuntime.mark((function t(){var n,o;return regeneratorRuntime.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return(n=new FormData).append("current_user_id",e.currentUser.id),n.append("book[name]",data.name),n.append("book[author]",data.author),n.append("book[publisher]",data.publisher),n.append("book[subject]",data.subject),n.append("book[description]",data.description),data.image&&n.append("book[image]",data.image),t.prev=8,t.next=11,te.a.patch("/books/".concat(e.book.id),n);case 11:o=t.sent,console.log(o.data),e.snackbarColor="primary",e.snackbar=!0,e.flashMessage="参考書の編集が完了しました",e.book.name=o.data.book.name,e.book.author=o.data.book.author,e.book.publisher=o.data.book.publisher,e.book.subject=o.data.book.subject,e.book.description=o.data.book.description,o.data.image_url&&(e.book.image=o.data.image_url),t.next=30;break;case 24:t.prev=24,t.t0=t.catch(8),console.log(t.t0),e.snackbarColor="red accent-2",e.snackbar=!0,e.flashMessage="参考書を編集できませんでした";case 30:e.editBookDialog=!1;case 31:case"end":return t.stop()}}),t,null,[[8,24]])})))()},deleteBook:function(){var e=this;return Object(S.a)(regeneratorRuntime.mark((function t(){var n;return regeneratorRuntime.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return t.prev=0,t.next=3,te.a.delete("/books/".concat(e.book.id),{params:{current_user_id:e.currentUser.id}});case 3:n=t.sent,console.log(n),e.$router.push({path:"/books/allBooks",query:{message:"参考書を削除しました"}}),t.next=15;break;case 8:t.prev=8,t.t0=t.catch(0),console.log(t.t0),e.snackbarColor="red accent-2",e.snackbar=!0,e.flashMessage="参考書を削除できませんでした",e.showDeleteConfirmation=!1;case 15:case"end":return t.stop()}}),t,null,[[0,8]])})))()}}},ne=Object(M.a)(ae,(function(){var e=this,t=e._self._c;return t("div",[t("div",{staticClass:"d-flex justify-space-between",staticStyle:{"margin-top":"50px","margin-bottom":"10px"}},[t("h2",[e._v("参考書詳細")]),e._v(" "),t("nuxt-link",{attrs:{to:"/books/allBooks"}},[e._v("参考書一覧に戻る")])],1),e._v(" "),t(l.a,{attrs:{"min-height":"350"}},[t(x.a,[t(d.a,{staticClass:"d-flex justify-center",attrs:{cols:"3"}},[e.book.image?t("div",[t(m.a,{attrs:{src:e.book.image,alt:"画像",contain:"",haight:"230",width:"210"}})],1):e._e()]),e._v(" "),t(d.a,{attrs:{cols:"7"}},[t(c.d,[t("h3",[e._v(" "+e._s(e.book.name))])]),e._v(" "),t(c.b,{staticStyle:{"margin-top":"-20px"}},[t(x.a,{staticClass:"d-flex align-center"},[t(d.a,{attrs:{cols:"4"}},[t(k.a,{attrs:{readonly:!0,"background-color":"orange lighten-3",color:"orange",dense:"",large:""},model:{value:e.book.average_rating,callback:function(t){e.$set(e.book,"average_rating",t)},expression:"book.average_rating"}})],1),e._v(" "),t(d.a,{attrs:{cols:"3"}},[t("h2",[e._v("\n                ("+e._s(e.book.average_rating)+")\n              ")])])],1)],1),e._v(" "),t(c.c,[t("h2",{staticStyle:{"margin-bottom":"5px"}},[e._v("科目: "+e._s(e.book.subject))]),e._v(" "),t("br"),e._v(" "),t("h4",[e._v("作者: "+e._s(e.book.author))]),e._v(" "),t("h4",[e._v("出版社: "+e._s(e.book.publisher))]),e._v(" "),t("br"),e._v(" "),e.book.description?[t("h4",[e._v("説明")]),e._v(" "),t(D.a,{attrs:{value:e.book.description,readonly:"",outlined:"",rounded:"",dense:"","auto-grow":""}})]:e._e()],2),e._v(" "),t("br"),t("br"),e._v(" "),t(c.a,[t(x.a,{staticClass:"d-flex align-center"},[t(d.a,{attrs:{cols:"3","data-cy":"book-review-section"}},[t(f.a,[e._v("mdi-comment-text-outline")]),e._v("\n              レビュー: "+e._s(e.book.reviews_count)+"件\n            ")],1),e._v(" "),t(d.a,{attrs:{cols:"3","data-cy":"book-question-section"}},[t(f.a,[e._v("mdi-comment-question-outline")]),e._v("\n              質問: "+e._s(e.book.questions_count)+"件\n            ")],1),e._v(" "),t(d.a,{attrs:{cols:"3","data-cy":"book-favorite-section"}},[t(f.a,[e._v("mdi-heart-multiple")]),e._v("\n              お気に入り ("+e._s(e.book.favorite_books_count)+")\n            ")],1),e._v(" "),t(d.a,{attrs:{cols:"3"}},[e.isFavorite?t("div",[t(r.a,{on:{click:e.removeFromFavorite}},[e._v("お気に入りから削除する")])],1):t("div",[t(r.a,{attrs:{color:"primary"},on:{click:e.addToFavorites}},[e._v("お気に入りに追加する")])],1)])],1)],1)],1),e._v(" "),t(d.a,{staticClass:"d-flex flex-column",staticStyle:{padding:"20px"},attrs:{cols:"2"}},[e.currentUser&&e.book.user_id==e.currentUser.id?[t(r.a,{staticStyle:{"margin-bottom":"10px"},attrs:{"data-cy":"edit-book-button"},on:{click:function(t){e.editBookDialog=!0}}},[e._v("編集する")]),e._v(" "),t(r.a,{attrs:{"data-cy":"delete-book-button"},on:{click:function(t){e.showDeleteConfirmation=!0}}},[e._v("削除する")])]:e._e()],2)],1)],1),e._v(" "),t("br"),t("br"),t("br"),t("br"),e._v(" "),t(l.a,{attrs:{height:"100px"}},[t(x.a,{staticStyle:{height:"100%"}},[t(d.a,{staticClass:"d-flex justify-center align-center",attrs:{cols:"6"}},[t(r.a,{attrs:{"x-large":"",color:"success",width:"400","data-cy":"review-dialog-button"},on:{click:e.openReviewDialog}},[e._v("\n        新規レビューを投稿する\n      ")])],1),e._v(" "),t(d.a,{staticClass:"d-flex justify-center align-center",attrs:{cols:"6"}},[t(r.a,{attrs:{"x-large":"",color:"success",width:"400","data-cy":"question-dialog-button"},on:{click:e.openQuestionDialog}},[e._v("\n          新規質問を投稿する\n        ")])],1)],1)],1),e._v(" "),t(v.a,{model:{value:e.editBookDialog,callback:function(t){e.editBookDialog=t},expression:"editBookDialog"}},[t(l.a,[t(c.d,{staticStyle:{"justify-content":"center"}},[t("h2",[e._v("参考書を編集する")])]),e._v(" "),t(c.c,[t("edit-book",{attrs:{name:e.book.name,author:e.book.author,publisher:e.book.publisher,subject:e.book.subject,description:e.book.description},on:{submitBook:e.editBook,closeDialog:function(t){e.editBookDialog=!1}}})],1)],1)],1),e._v(" "),t("delete-confirmation-dialog",{attrs:{showDeleteConfirmation:e.showDeleteConfirmation,contentTitle:"参考書"},on:{deleteContent:e.deleteBook,closeDeleteConfirmation:function(t){e.showDeleteConfirmation=!1}}}),e._v(" "),t(v.a,{model:{value:e.reviewDialog,callback:function(t){e.reviewDialog=t},expression:"reviewDialog"}},[t(l.a,[t(c.d,{staticStyle:{"justify-content":"center"}},[t("h2",[e._v("レビューを投稿する")])]),e._v(" "),t(c.c,[t("review-form",{on:{submitReview:e.submitReview,closeDialog:function(t){e.reviewDialog=!1}}})],1)],1)],1),e._v(" "),t(v.a,{model:{value:e.questionDialog,callback:function(t){e.questionDialog=t},expression:"questionDialog"}},[t(l.a,[t(c.d,{staticStyle:{"justify-content":"center"}},[t("h2",[e._v("質問を投稿する")])]),e._v(" "),t(c.c,[t("question-form",{on:{submitQuestion:e.submitQuestion,closeDialog:function(t){e.questionDialog=!1}}})],1)],1)],1),e._v(" "),t("br"),e._v(" "),t(h.a,{attrs:{height:"50"}}),e._v(" "),t("br"),e._v(" "),t(C.a,{attrs:{centered:"",grow:"",height:"60"},model:{value:e.tab,callback:function(t){e.tab=t},expression:"tab"}},e._l(e.tabs,(function(n,o){return t(w.a,{key:o,on:{click:function(t){e.page=1}}},[e._v("\n        "+e._s(n.label)+"\n    ")])})),1),e._v(" "),t("br"),e._v(" "),0===e.tab?[e.reviewsChunk.length>0?[t(_.a,{attrs:{length:e.reviewsTotalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}}),e._v(" "),t("br"),t("br"),e._v(" "),t("book-reviews",{attrs:{reviews:e.reviewsChunk}}),e._v(" "),t("br"),e._v(" "),t(_.a,{attrs:{length:e.reviewsTotalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}})]:[t("br"),e._v(" "),t(x.a,[t(d.a,{staticClass:"d-flex justify-center"},[t(o.a,{attrs:{type:"info"}},[e._v("\n          レビューは投稿されていません\n          ")])],1)],1)]]:1===e.tab?[e.questionsChunk.length>0?[t(_.a,{attrs:{length:e.questionsTotalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}}),e._v(" "),t("br"),t("br"),e._v(" "),t("book-questions",{attrs:{questions:e.questionsChunk}}),e._v(" "),t("br"),e._v(" "),t(_.a,{attrs:{length:e.questionsTotalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}})]:[t("br"),e._v(" "),t(x.a,[t(d.a,{staticClass:"d-flex justify-center"},[t(o.a,{attrs:{type:"info"}},[e._v("\n          質問は投稿されていません\n          ")])],1)],1)]]:e._e(),e._v(" "),t("br"),e._v(" "),t(y.a,{attrs:{timeout:3e3,color:e.snackbarColor},model:{value:e.snackbar,callback:function(t){e.snackbar=t},expression:"snackbar"}},[e._v(e._s(e.flashMessage))])],2)}),[],!1,null,null,null);t.default=ne.exports;installComponents(ne,{DeleteConfirmationDialog:n(577).default})}}]);