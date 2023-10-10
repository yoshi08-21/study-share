(window.webpackJsonp=window.webpackJsonp||[]).push([[16,7,9,10],{575:function(t,e,r){"use strict";e.a={data:function(){return{snackbar:!1,snackbarColor:"primary",flashMessage:""}},mounted:function(){this.$route.query.message&&(this.snackbarColor="primary",this.snackbar=!0,this.flashMessage=this.$route.query.message)}}},576:function(t,e,r){"use strict";e.a={methods:{goToUser:function(t){this.currentUser&&this.currentUser.id===t.id?this.$router.push({path:"/mypage"}):this.$router.push({path:"/users/".concat(t.id)})}}}},578:function(t,e,r){"use strict";r.r(e);var n=r(602),o=r(265),c=r(255),l=r(111),d=r(566),f=r(262),v=r(565),m={props:{showDeleteConfirmation:Boolean,contentTitle:String},data:function(){return{localShowDeleteConfirmation:this.showDeleteConfirmation}},watch:{showDeleteConfirmation:function(t){this.localShowDeleteConfirmation=t}},methods:{deleteContent:function(){this.$emit("deleteContent")},closeDeleteConfirmation:function(){this.$emit("closeDeleteConfirmation")}}},h=r(69),component=Object(h.a)(m,(function(){var t=this,e=t._self._c;return e(f.a,{attrs:{width:"800"},model:{value:t.localShowDeleteConfirmation,callback:function(e){t.localShowDeleteConfirmation=e},expression:"localShowDeleteConfirmation"}},[e(c.a,{attrs:{height:"300"}},[e(v.a,{staticClass:"d-flex justify-center"},[e(d.a,[e(l.d,{staticStyle:{height:"120px"}},[e(n.a,{attrs:{type:"error",dense:"",text:"",prominent:"",border:"left",width:"100%"}},[t._v("\n            削除した"+t._s(t.contentTitle)+"は復元できません!\n          ")])],1),t._v(" "),e(l.c,{staticStyle:{"text-align":"center",height:"90px"}},[e("h1",[t._v("\n            "+t._s(t.contentTitle)+"を削除しますか？\n          ")])]),t._v(" "),e(l.a,[e(v.a,[e(d.a,{staticClass:"d-flex justify-center",attrs:{cols:"6"}},[e(o.a,{attrs:{large:"",width:"300",color:"error",dark:"","data-cy":"delete-confirm-button"},on:{click:t.deleteContent}},[t._v("\n                削除する\n              ")])],1),t._v(" "),e(d.a,{staticClass:"d-flex justify-center",attrs:{cols:"6"}},[e(o.a,{attrs:{large:"",width:"300"},on:{click:t.closeDeleteConfirmation}},[t._v("\n                戻る\n              ")])],1)],1)],1)],1)],1)],1)],1)}),[],!1,null,null,null);e.default=component.exports},583:function(t,e,r){"use strict";e.a={methods:{checkFileSize:function(t){t&&t.size>3145728?(this.errorMessage="添付できるファイルは3MBまでです",this.error=!0):(this.errorMessage="",this.error=!1)}}}},586:function(t,e,r){"use strict";r.r(e);var n=r(265),o=r(566),c=r(164),l=r(565),d={props:{content:String},methods:{previousContent:function(){this.$emit("previousContent")},nextContent:function(){this.$emit("nextContent")}}},f=r(69),component=Object(f.a)(d,(function(){var t=this,e=t._self._c;return e(l.a,{staticClass:"d-flex justify-space-between"},[e(o.a,{staticClass:"d-flex justify-start",attrs:{cols:"6"}},[e(n.a,{attrs:{"x-large":"","data-cy":"previous-content-button"},on:{click:t.previousContent}},[e(c.a,[t._v("mdi-arrow-left-bold")]),t._v("前の"+t._s(t.content))],1)],1),t._v(" "),e(o.a,{staticClass:"d-flex justify-end",attrs:{cols:"6"}},[e(n.a,{attrs:{"x-large":"","data-cy":"next-content-button"},on:{click:t.nextContent}},[t._v("次の"+t._s(t.content)),e(c.a,[t._v("mdi-arrow-right-bold")])],1)],1)],1)}),[],!1,null,null,null);e.default=component.exports},587:function(t,e,r){"use strict";r.r(e);var n=r(265),o=r(164),c=(r(22),{props:{currentUser:Object,user:Object,isFavorite:Boolean,favoriteCount:Number},methods:{addToFavorite:function(){this.$emit("addToFavorite")},removeFromFavorite:function(){this.$emit("removeFromFavorite")}}}),l=r(69),component=Object(l.a)(c,(function(){var t=this,e=t._self._c;return e("div",{attrs:{"data-cy":"favorite-section"}},[t.currentUser&&t.user.id!==t.currentUser.id?[t.isFavorite?[e(n.a,{staticClass:"mx-2",attrs:{fab:"",dark:"",small:"",color:"pink","data-cy":"remove-favorite-button"},on:{click:t.removeFromFavorite}},[e(o.a,{attrs:{dark:""}},[t._v("\n          mdi-heart\n        ")])],1),t._v("\n      ("+t._s(t.favoriteCount)+")\n    ")]:[e(n.a,{staticClass:"mx-2",attrs:{fab:"",dark:"",small:"",color:"pink",outlined:"","data-cy":"add-favorite-button"},on:{click:t.addToFavorite}},[e(o.a,{attrs:{dark:""}},[t._v("\n          mdi-heart-plus-outline\n        ")])],1),t._v("\n      ("+t._s(t.favoriteCount)+")\n    ")]]:[e(o.a,[t._v("mdi-heart-multiple")]),t._v("\n    いいね! ("+t._s(t.favoriteCount)+")\n  ")]],2)}),[],!1,null,null,null);e.default=component.exports},595:function(t,e,r){"use strict";r.r(e);var n=r(265),o=r(255),c=r(111),l=r(566),d=r(262),f=r(209),v=r(565),m={props:{showFullImage:Boolean,image:String},data:function(){return{localShowFullImage:this.showFullImage}},watch:{showFullImage:function(t){this.localShowFullImage=t}}},h=r(69),component=Object(h.a)(m,(function(){var t=this,e=t._self._c;return e(d.a,{model:{value:t.localShowFullImage,callback:function(e){t.localShowFullImage=e},expression:"localShowFullImage"}},[e(o.a,{staticStyle:{padding:"10px"},attrs:{"max-height":"800px"}},[e(v.a,[e(l.a,{staticClass:"d-flex justify-start",attrs:{cols:"6"}},[e(c.d,[t._v("拡大画像")])],1),t._v(" "),e(l.a,{staticClass:"d-flex justify-end align-center",attrs:{cols:"6"}},[e(n.a,{on:{click:function(e){return t.$emit("closeShowFullImage")}}},[t._v("閉じる")])],1)],1),t._v(" "),e("hr"),t._v(" "),e(v.a,{staticStyle:{"margin-top":"10px","margin-bottom":"5px"}},[e(l.a,{staticClass:"d-flex justify-center"},[e(f.a,{attrs:{src:t.image,"max-height":"500","max-width":"500",contain:""}})],1)],1),t._v(" "),e(v.a,[e(l.a,{staticClass:"d-flex justify-center"},[e(n.a,{on:{click:function(e){return t.$emit("closeShowFullImage")}}},[t._v("閉じる")])],1)],1)],1)],1)}),[],!1,null,null,null);e.default=component.exports},623:function(t,e,r){"use strict";var n=r(602),o=r(802),c=r(626),l=r(568),d=r(213),f=r(583),v={props:{content:String},components:{VTextarea:l.a,SubmitButton:d.default},mixins:[f.a],data:function(){return{editedContent:this.content,contentRules:[function(t){return!!t||"本文を入力してください"},function(t){return(t||"").length<=1e3||"最大入力文字数は1000文字です"}],selectedFile:null,errorMessage:"",error:!1}},methods:{submitForm:function(){this.$emit("submitReply",{content:this.editedContent,image:this.selectedFile})}}},m=r(69),component=Object(m.a)(v,(function(){var t=this,e=t._self._c;return e("div",[e("br"),e("br"),t._v(" "),e(c.a,[e(l.a,{attrs:{outlined:"",counter:"",label:"本文",rules:t.contentRules,"data-cy":"edit-content-field"},model:{value:t.editedContent,callback:function(e){t.editedContent=e},expression:"editedContent"}}),t._v("\n    *画像を添付できます(「.jpeg」「.jpg」「.png」のみ添付できます)\n    "),e("br"),t._v("\n    *添付できる画像のファイルサイズは3MBまでです\n    "),e("br"),e("br"),t._v(" "),e(o.a,{staticStyle:{width:"500px"},attrs:{accept:"image/jpeg, image/png","show-size":"","truncate-length":"15",outlined:"",label:"ファイルを選択","prepend-icon":"mdi-image-plus"},on:{change:t.checkFileSize},model:{value:t.selectedFile,callback:function(e){t.selectedFile=e},expression:"selectedFile"}}),t._v(" "),t.errorMessage?[e(n.a,{attrs:{type:"error",dense:"",text:"",border:"left"}},[t._v("\n        "+t._s(t.errorMessage)+"\n      ")])]:t._e(),t._v(" "),e("submit-button",{attrs:{error:t.error,buttonTitle:"編集する"},on:{submitForm:t.submitForm,closeDialog:function(e){return t.$emit("closeDialog")}}})],2)],1)}),[],!1,null,null,null);e.a=component.exports;installComponents(component,{SubmitButton:r(213).default})},831:function(t,e,r){"use strict";r.r(e);var n=r(254),o=r(265),c=r(255),l=r(111),d=r(566),f=r(262),v=r(164),m=r(209),h=r(565),_=r(567),y=r(568),x=(r(35),r(32),r(30)),k=r(26),C=(r(82),r(6),r(49),r(56),r(268),r(623)),w=r(586),F=r(578),S=r(119),j=r(575),R=r(576),U=r(44),D={components:{EditReply:C.a,ContentNavigator:w.default,DeleteConfirmationDialog:F.default},mixins:[S.a,j.a,R.a],asyncData:function(t){return Object(k.a)(regeneratorRuntime.mark((function e(){var r,n,o,c,l,d,f,v;return regeneratorRuntime.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return r=t.params,n=t.store,e.prev=1,o=null,(c=n.getters["auth/getCurrentUser"])&&c.id&&(o=c.id),e.next=7,Promise.all([U.a.get("/books/".concat(r.book_id,"/questions/").concat(r.question_id,"/replies/").concat(r.id),{params:{current_user_id:o}}),U.a.get("/books/".concat(r.book_id,"/questions/").concat(r.question_id,"/replies"))]);case 7:return l=e.sent,d=Object(x.a)(l,2),f=d[0],v=d[1],e.abrupt("return",{book:f.data.book,question:f.data.question,questionUser:f.data.question_user,reply:f.data.reply,replyUser:f.data.reply_user,replies:v.data,params:r});case 14:e.prev=14,e.t0=e.catch(1),console.error("エラーが発生しました:",e.t0);case 17:case"end":return e.stop()}}),e,null,[[1,14]])})))()},data:function(){return{dialog:!1,showDeleteConfirmation:!1,isFavorite:!1,favoriteReplyId:"",showFullImage:!1}},created:function(){var t=this;return Object(k.a)(regeneratorRuntime.mark((function e(){var r,n,o;return regeneratorRuntime.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return e.prev=0,r="",(n=t.$store.getters["auth/getCurrentUser"])&&n.id&&(r=n.id),e.next=6,U.a.get("replies/is_favorite",{params:{current_user_id:r,reply_id:t.$route.params.id}});case 6:o=e.sent,t.isFavorite=o.data.is_favorite,t.favoriteReplyId=o.data.favorite_reply_id,e.next=14;break;case 11:e.prev=11,e.t0=e.catch(0),console.error("エラーが発生しました:",e.t0);case 14:case"end":return e.stop()}}),e,null,[[0,11]])})))()},methods:{editReply:function(data){var t=this;return Object(k.a)(regeneratorRuntime.mark((function e(){var r,n;return regeneratorRuntime.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return(r=new FormData).append("current_user_id",t.currentUser.id),r.append("reply[content]",data.content),data.image&&r.append("reply[image]",data.image),e.prev=4,e.next=7,U.a.patch("/books/".concat(t.book.id,"/questions/").concat(t.question.id,"/replies/").concat(t.reply.id),r);case 7:n=e.sent,t.snackbarColor="primary",t.snackbar=!0,t.flashMessage="返信の編集が完了しました",t.reply.content=n.data.reply.content,n.data.image_url&&(t.reply.image=n.data.image_url),e.next=21;break;case 15:e.prev=15,e.t0=e.catch(4),console.error("エラーが発生しました:",e.t0),t.snackbarColor="red accent-2",t.snackbar=!0,t.flashMessage="返信を編集できませんでした";case 21:t.dialog=!1;case 22:case"end":return e.stop()}}),e,null,[[4,15]])})))()},deleteReply:function(){var t=this;return Object(k.a)(regeneratorRuntime.mark((function e(){return regeneratorRuntime.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return e.prev=0,e.next=3,U.a.delete("/books/".concat(t.book.id,"/questions/").concat(t.question.id,"/replies/").concat(t.reply.id),{params:{current_user_id:t.currentUser.id}});case 3:t.$router.push({path:"/books/".concat(t.book.id,"/questions/").concat(t.question.id),query:{message:"返信を削除しました"}}),e.next=13;break;case 6:e.prev=6,e.t0=e.catch(0),console.error("エラーが発生しました:",e.t0),t.snackbarColor="red accent-2",t.snackbar=!0,t.flashMessage="返信を削除できませんでした",t.dialog=!1;case 13:case"end":return e.stop()}}),e,null,[[0,6]])})))()},addToFavorite:function(){var t=this;return Object(k.a)(regeneratorRuntime.mark((function e(){var r;return regeneratorRuntime.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return e.prev=0,e.next=3,U.a.post("/replies/".concat(t.reply.id,"/favorite_replies"),{current_user_id:t.currentUser.id});case 3:r=e.sent,t.snackbarColor="primary",t.snackbar=!0,t.flashMessage="いいね!しました",t.isFavorite=!0,t.favoriteReplyId=r.data.id,t.reply.favorite_replies_count+=1,e.next=18;break;case 12:e.prev=12,e.t0=e.catch(0),console.error("エラーが発生しました:",e.t0),t.snackbarColor="red accent-2",t.snackbar=!0,t.flashMessage="すでにいいね!されています";case 18:case"end":return e.stop()}}),e,null,[[0,12]])})))()},removeFromFavorite:function(){var t=this;return Object(k.a)(regeneratorRuntime.mark((function e(){return regeneratorRuntime.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return e.prev=0,e.next=3,U.a.delete("/replies/".concat(t.reply.id,"/favorite_replies/").concat(t.favoriteReplyId),{params:{current_user_id:t.currentUser.id}});case 3:t.snackbarColor="primary",t.snackbar=!0,t.flashMessage="いいね!を削除しました",t.isFavorite=!t.isFavorite,t.favoriteReplyId=null,t.reply.favorite_replies_count-=1,e.next=17;break;case 11:e.prev=11,e.t0=e.catch(0),console.error("エラーが発生しました:",e.t0),t.snackbarColor="red accent-2",t.snackbar=!0,t.flashMessage="いいね!されていません";case 17:case"end":return e.stop()}}),e,null,[[0,11]])})))()},nextReply:function(){var t=this,e=this.replies.findIndex((function(e){return e.id===t.reply.id}))+1,r=this.replies[e],n=this.replies[this.replies.length-1];this.reply.id!==n.id?this.$router.push({path:"/books/".concat(this.book.id,"/questions/").concat(this.question.id,"/replies/").concat(r.id)}):(this.snackbar=!0,this.snackbarColor="blue-grey",this.flashMessage="最後の返信です")},previousReply:function(){var t=this,e=this.replies.findIndex((function(e){return e.id===t.reply.id}))-1,r=this.replies[e],n=this.replies[0];this.reply.id!==n.id?this.$router.push({path:"/books/".concat(this.book.id,"/questions/").concat(this.question.id,"/replies/").concat(r.id)}):(this.snackbar=!0,this.snackbarColor="blue-grey",this.flashMessage="最初の返信です")}}},I=r(69),component=Object(I.a)(D,(function(){var t=this,e=t._self._c;return e("div",[t._m(0),t._v(" "),e(c.a,{attrs:{elevation:"8","data-cy":"question-information"}},[e(h.a,[e(d.a,{staticClass:"mt-8",attrs:{cols:"2"}},[e("div",{staticStyle:{cursor:"pointer"},on:{click:function(e){return t.goToUser(t.questionUser)}}},[e(h.a,[e(d.a,{staticClass:"d-flex justify-center align-center text-center"},[e(n.a,{attrs:{size:"100"}},[e(m.a,{attrs:{src:t.questionUser.image,alt:"画像",contain:""}})],1)],1)],1),t._v(" "),e(h.a,[e(d.a,{staticClass:"d-flex justify-center align-center text-center"},[e("span",{staticStyle:{"text-decoration":"underline"}},[t._v(t._s(t.$truncate(t.questionUser.name,10)))])])],1)],1)]),t._v(" "),e(d.a,{attrs:{cols:"7"}},[e(l.d,[e("nuxt-link",{attrs:{to:"/books/".concat(t.question.book_id,"/questions/").concat(t.question.id)}},[t._v(t._s(t.question.title))])],1),t._v(" "),e(l.c,[e(y.a,{staticStyle:{height:"150px"},attrs:{value:t.question.content,readonly:"",filled:"",rounded:"",dense:"","no-resize":"",rows:"4"}})],1),t._v(" "),e(l.a,[e(h.a,{staticClass:"d-flex align-center justify-center"},[e(d.a,{attrs:{cols:"4","data-cy":"question-reply-section"}},[e(v.a,[t._v("mdi-comment-text-outline")]),t._v("\n              返信: "+t._s(t.question.replies_count)+"件\n            ")],1),t._v(" "),e(d.a,{attrs:{cols:"4","data-cy":"question-favorite-section"}},[e(v.a,[t._v("mdi-heart-multiple")]),t._v("\n              いいね! ("+t._s(t.question.favorite_questions_count)+")\n            ")],1)],1),t._v(" "),e("p")],1)],1),t._v(" "),e(d.a,{staticClass:"mt-3",attrs:{cols:"3"}},[e("div",{staticStyle:{height:"250px"}},[e(h.a,{staticStyle:{"flex-direction":"column",height:"150px",width:"220px"}},[e(d.a,{staticClass:"d-flex justify-center align-center"},[e(m.a,{attrs:{src:t.book.image,alt:"画像",contain:"",height:"150",width:"220"}})],1)],1),t._v(" "),e(h.a,[e(d.a,{staticClass:"d-flex justify-center align-center mt-2"},[e("nuxt-link",{attrs:{to:"/books/".concat(t.question.book_id,"}")}},[t._v(t._s(t.$truncate(t.book.name,25)))])],1)],1)],1)])],1)],1),t._v(" "),e("br"),e("br"),e("br"),t._v(" "),e("div",{staticClass:"d-flex justify-space-between",staticStyle:{"margin-top":"50px","margin-bottom":"10px"}},[e("h2",[t._v("返信詳細")]),t._v(" "),e("nuxt-link",{attrs:{to:"/books/".concat(t.question.book_id,"/questions/").concat(t.question.id)}},[t._v("質問詳細に戻る")])],1),t._v(" "),e(c.a,{staticStyle:{"padding-bottom":"1px"},attrs:{elevation:"8","data-cy":"reply-detail"}},[e(h.a,[e(d.a,{staticClass:"mt-8",attrs:{cols:"2"}},[e("div",{staticStyle:{cursor:"pointer"},on:{click:function(e){return t.goToUser(t.replyUser)}}},[e(h.a,[e(d.a,{staticClass:"d-flex justify-center align-center text-center"},[e(n.a,{attrs:{size:"100"}},[e(m.a,{attrs:{src:t.replyUser.image,alt:"画像",contain:""}})],1)],1)],1),t._v(" "),e(h.a,[e(d.a,{staticClass:"d-flex justify-center align-center text-center"},[e("span",{staticStyle:{"text-decoration":"underline"}},[t._v(t._s(t.$truncate(t.replyUser.name,10)))])])],1)],1)]),t._v(" "),e(d.a,{staticClass:"mt-n2",attrs:{cols:"8"}},[e(l.d,[e(y.a,{attrs:{value:t.reply.content,readonly:"",outlined:"",rounded:"",dense:"","auto-grow":""}})],1),t._v(" "),t.reply.image?[e(h.a,[e(d.a,{staticClass:"d-flex justify-center"},[e(m.a,{staticStyle:{cursor:"pointer"},attrs:{src:t.reply.image,alt:"画像",contain:"","max-height":"250","max-width":"250"},on:{click:function(e){t.showFullImage=!0}}})],1)],1),t._v(" "),e(h.a,[e(d.a,{staticClass:"d-flex justify-center"},[t._v("\n              *画像をクリックすると拡大できます\n            ")])],1)]:t._e(),t._v(" "),e("br"),t._v(" "),e(l.a,[e(h.a,{staticClass:"d-flex align-center justify-center"},[e(d.a,{attrs:{cols:"4"}},[e("favorite-button",{attrs:{currentUser:t.currentUser,user:t.replyUser,isFavorite:t.isFavorite,favoriteCount:t.reply.favorite_replies_count},on:{addToFavorite:t.addToFavorite,removeFromFavorite:t.removeFromFavorite}})],1),t._v(" "),e(d.a,{attrs:{cols:"4"}},[e(v.a,[t._v("mdi-calendar-clock")]),t._v("\n              "+t._s(t.reply.created_at)+"\n            ")],1)],1)],1)],2),t._v(" "),e(d.a,{staticClass:"d-flex flex-column",staticStyle:{padding:"20px"},attrs:{cols:"2"}},[t.currentUser&&t.replyUser.id==t.currentUser.id?[e(o.a,{staticStyle:{"margin-bottom":"10px"},on:{click:function(e){t.dialog=!0}}},[t._v("編集する")]),t._v(" "),e(o.a,{on:{click:function(e){t.showDeleteConfirmation=!0}}},[t._v("削除する")])]:t._e()],2)],1)],1),t._v(" "),e("br"),e("br"),t._v(" "),e("content-navigator",{attrs:{content:"返信"},on:{previousContent:t.previousReply,nextContent:t.nextReply}}),t._v(" "),e(f.a,{model:{value:t.dialog,callback:function(e){t.dialog=e},expression:"dialog"}},[e(c.a,[e(l.d,{staticStyle:{"justify-content":"center"}},[e("h2",[t._v("返信を編集する")])]),t._v(" "),e(l.c,[e("edit-reply",{attrs:{content:t.reply.content},on:{submitReply:t.editReply,closeDialog:function(e){t.dialog=!1}}})],1)],1)],1),t._v(" "),e("delete-confirmation-dialog",{attrs:{showDeleteConfirmation:t.showDeleteConfirmation,contentTitle:"返信"},on:{deleteContent:t.deleteReply,closeDeleteConfirmation:function(e){t.showDeleteConfirmation=!1}}}),t._v(" "),e("show-full-image-dialog",{attrs:{showFullImage:t.showFullImage,image:t.reply.image},on:{closeShowFullImage:function(e){t.showFullImage=!1}}}),t._v(" "),e("br"),t._v(" "),e(_.a,{attrs:{timeout:3e3,color:t.snackbarColor},model:{value:t.snackbar,callback:function(e){t.snackbar=e},expression:"snackbar"}},[t._v(t._s(t.flashMessage))])],1)}),[function(){var t=this._self._c;return t("div",{staticStyle:{"margin-bottom":"10px"}},[t("h3",[this._v("質問情報")])])}],!1,null,null,null);e.default=component.exports;installComponents(component,{FavoriteButton:r(587).default,ContentNavigator:r(586).default,DeleteConfirmationDialog:r(578).default,ShowFullImageDialog:r(595).default})}}]);