(window.webpackJsonp=window.webpackJsonp||[]).push([[25],{574:function(e,t,r){"use strict";t.a={methods:{goToUser:function(e){this.currentUser&&this.currentUser.id===e.id?this.$router.push({path:"/mypage"}):this.$router.push({path:"/users/".concat(e.id)})}}}},576:function(e,t,r){"use strict";t.a={data:function(){return{snackbar:!1,snackbarColor:"primary",flashMessage:""}},mounted:function(){this.$route.query.message&&(this.snackbarColor="primary",this.snackbar=!0,this.flashMessage=this.$route.query.message)}}},764:function(e,t,r){var content=r(797);content.__esModule&&(content=content.default),"string"==typeof content&&(content=[[e.i,content,""]]),content.locals&&(e.exports=content.locals);(0,r(18).default)("74df864f",content,!0,{sourceMap:!1})},796:function(e,t,r){"use strict";r(764)},797:function(e,t,r){var o=r(17)(!1);o.push([e.i,".comment-highlight{border:1px solid;background-color:#fff3e0;padding:10px;margin:5px 0}",""]),e.exports=o},816:function(e,t,r){"use strict";r.r(t);var o=r(254),n=r(255),c=r(111),l=r(565),_=r(164),h=r(209),v=r(598),d=r(564),f=r(46),k=r(623),m=r(833),x=r(566),y=r(567),w=(r(32),r(35),r(30)),S=r(26),C=(r(82),r(6),r(49),r(56),{props:{books:[]}}),U=r(69),$=Object(U.a)(C,(function(){var e=this,t=e._self._c;return t(f.a,{staticClass:"mx-auto"},[t(k.b,{staticStyle:{"background-color":"#edebe8"},attrs:{"center-active":"","show-arrows":""}},e._l(e.books,(function(r){return t(m.a,{key:r.id,scopedSlots:e._u([{key:"default",fn:function(o){var f=o.toggle;return[t(n.a,{staticClass:"ma-4 pa-4",attrs:{height:"430",width:"370",outlined:"",raised:"",shaped:""},on:{click:f}},[r.image?t("div",{staticClass:"d-flex justify-center",staticStyle:{height:"150px"}},[t(h.a,{attrs:{src:r.image,alt:"画像",contain:"","max-height":"150","max-width":"150"}})],1):e._e(),e._v(" "),t("br"),e._v(" "),t(c.d,{staticStyle:{height:"90px"}},[t("nuxt-link",{attrs:{to:"/books/".concat(r.id)}},[e._v(e._s(e.$truncate(r.name,25)))])],1),e._v(" "),t("div",[t("div",[t(d.a,{staticClass:"d-flex align-center"},[t(l.a,{attrs:{cols:"3"}},[t("h4",[e._v("平均評価")])]),e._v(" "),t(l.a,{attrs:{cols:"7"}},[t(v.a,{attrs:{readonly:!0,"background-color":"orange lighten-3",color:"orange",dense:"",large:"","half-increments":""},model:{value:r.average_rating,callback:function(t){e.$set(r,"average_rating",t)},expression:"book.average_rating"}})],1),e._v(" "),t(l.a,{attrs:{cols:"2"}},[e._v("\n                ("+e._s(r.average_rating)+")\n              ")])],1)],1),e._v(" "),t("div",[t(d.a,{staticClass:"d-flex align-center justify-center"},[t(l.a,{staticClass:"d-flex align-center justify-center",attrs:{cols:"12"}},[t("h3",[e._v("科目: "+e._s(r.subject))])])],1)],1)]),e._v(" "),t(c.a,{staticStyle:{"margin-top":"10px"}},[t(d.a,[t(l.a,{attrs:{cols:"6"}},[t(_.a,[e._v("mdi-comment-text-outline")]),e._v("\n              レビュー: "+e._s(r.reviews_count)+"件\n            ")],1),e._v(" "),t(l.a,{attrs:{cols:"6"}},[t(_.a,[e._v("mdi-heart-multiple")]),e._v("\n              お気に入り ("+e._s(r.favorite_books_count)+")\n            ")],1)],1)],1)],1)]}}],null,!0)})})),1)],1)}),[],!1,null,null,null).exports,j=r(119),B=r(576),R=r(574),M=r(44),T={components:{TopPageEachBooks:$},mixins:[j.a,B.a,R.a],name:"IndexPage",asyncData:function(e){return Object(S.a)(regeneratorRuntime.mark((function t(){var r,o,n,c,l,_,h,v,d,f,k,m;return regeneratorRuntime.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return r=e.store,t.prev=1,o=null,(n=r.getters["auth/getCurrentUser"])&&n.id&&(o=n.id),c=[M.a.get("/pages/new_reviews"),M.a.get("/pages/popular_books")],null!==o?c.push(M.a.get("/pages/get_same_university_books",{params:{current_user_id:o}})):c.push(M.a.get("/pages/get_same_university_books",{params:{current_user_id:0}})),t.next=9,Promise.all(c);case 9:return l=t.sent,_=Object(w.a)(l,3),h=_[0],v=_[1],d=_[2],f=h.data,k=v.data,m=d.data,console.log(f),console.log(k),console.log(m),t.abrupt("return",{newReviews:f,popularBooks:k,firstChoiceSchoolBooks:m.first_choice_school_books,secondChoiceSchoolBooks:m.second_choice_school_books,thirdChoiceSchoolBooks:m.third_choice_school_books});case 23:throw t.prev=23,t.t0=t.catch(1),console.log(t.t0),t.t0;case 27:case"end":return t.stop()}}),t,null,[[1,23]])})))()},data:function(){return{user:"",error:"",newReviews:[],length:3,window:0,cypressUser:{}}},mounted:function(){this.$parent.showSpecialHeader=!0},created:function(){this.$store.commit("header/setShowSpecialHeader",!0)},beforeDestroy:function(){this.$store.commit("header/setShowSpecialHeader",!1)}},O=(r(796),Object(U.a)(T,(function(){var e=this,t=e._self._c;return t("div",[t("br"),t("br"),e._v(" "),e.currentUser?[t("h1",{staticStyle:{"text-align":"center"}},[e._v("Welcome To StudyShare!")]),e._v(" "),t("br"),t("br"),t("br"),t("br"),t("br"),t("br"),t("br"),t("br"),t("br"),t("br"),t("br"),t("br"),t("br"),t("br")]:[t("div",[t("h1",{staticStyle:{"text-align":"center"}},[e._v("Welcome To StudyShare!")]),e._v(" "),t("br"),e._v(" "),t("h2",[t(_.a,{attrs:{color:"green"}},[e._v("mdi-information-box-outline")]),e._v(" StudyShareは学習に関するあらゆる情報を共有できるサイトです")],1),e._v(" "),t("br"),t("br"),e._v(" "),t("h3",[t(_.a,{attrs:{color:"green"}},[e._v("mdi-information-box-outline")]),e._v(" 参考書へのレビューを投稿することができます")],1),e._v(" "),t("h4",[e._v("・自分が使ったことのある参考書へのレビューを投稿したり、他ユーザーのレビューを見たりして、自分に合った最高の参考書を見つけましょう!")]),e._v(" "),t("br"),t("br"),e._v(" "),t("h3",[t(_.a,{attrs:{color:"green"}},[e._v("mdi-information-box-outline")]),e._v(" 参考書への質問や科目別の質問、アンケートを投稿することができます")],1),e._v(" "),t("h4",[e._v("・参考書に対して気になることや、勉強をする中でわからないことがあればどんどん質問しましょう!")]),e._v(" "),t("h4",[e._v("・参考書選びや大学選びなどで迷うことがあれば、アンケートを作成して他ユーザーに意見を求めましょう!")]),e._v(" "),t("br"),t("br"),e._v(" "),t("h3",[t(_.a,{attrs:{color:"green"}},[e._v("mdi-information-box-outline")]),e._v(" 投稿されている質問で回答できるものがあれば、ぜひ回答してください")],1),e._v(" "),t("h4",[e._v("・質問に返信することは質問者を助けるだけでなく、アウトプットを通じてあなたの知識の整理にも必ず役立ちます!")]),e._v(" "),t("br"),t("br"),e._v(" "),t("h1",{staticStyle:{"text-align":"center"}},[t(_.a,{attrs:{color:"red"}},[e._v("mdi-fire")]),e._v(" StudyShareで賢く勉強を進め、志望する大学に合格しましょう! "),t(_.a,{attrs:{color:"red"}},[e._v("mdi-fire")])],1)])],e._v(" "),t("br"),e._v(" "),t("h2",[e._v("新着レビュー")]),e._v(" "),t("hr"),t("br"),e._v(" "),t(f.a,{staticClass:"mx-auto"},[t(k.b,{staticStyle:{"background-color":"#edebe8"},attrs:{"center-active":"","show-arrows":""}},e._l(e.newReviews,(function(r){return t(m.a,{key:r.id,scopedSlots:e._u([{key:"default",fn:function(f){var k=f.toggle;return[t(n.a,{staticClass:"ma-4",attrs:{height:"330",width:"450",outlined:"",raised:"",shaped:""},on:{click:k}},[t(c.d,[t("nuxt-link",{staticStyle:{color:"black"},attrs:{to:"/books/".concat(r.book_id,"/reviews/").concat(r.id)}},[e._v(e._s(e.$truncate(r.title,15)))])],1),e._v(" "),t(c.b,[t(d.a,{staticClass:"d-flex align-center"},[t(l.a,{attrs:{cols:"6"}},[t(v.a,{attrs:{readonly:!0,"background-color":"orange lighten-3",color:"orange",dense:"",large:""},model:{value:r.rating,callback:function(t){e.$set(r,"rating",t)},expression:"newReview.rating"}})],1),e._v(" "),t(l.a,{attrs:{cols:"2"}},[t("h2",[e._v("\n\n                  ("+e._s(r.rating)+")\n                ")])])],1)],1),e._v(" "),t(c.c,{staticStyle:{height:"135px"}},[t(y.a,{attrs:{value:r.content,readonly:"",filled:"",rounded:"",dense:"","no-resize":""}})],1),e._v(" "),t(c.a,[t(d.a,{staticClass:"d-flex justify-center align-center"},[t(l.a,{attrs:{cols:"6"}},[t("div",{staticStyle:{padding:"10px"},on:{click:function(t){return e.goToUser(r.user)}}},[t(o.a,[t(h.a,{attrs:{src:r.user.image}})],1),e._v(" "),t("span",{staticStyle:{"text-decoration":"underline"}},[e._v(e._s(e.$truncate(r.user.name,9)))])],1)]),e._v(" "),t(l.a,{attrs:{cols:"6"}},[t("nuxt-link",{attrs:{to:"/books/".concat(r.book.id)}},[t(_.a,[e._v("mdi-book-open-variant")]),e._v("\n                  "+e._s(e.$truncate(r.book.name,9))+"\n                ")],1)],1)],1)],1)],1)]}}],null,!0)})})),1)],1),e._v(" "),t("br"),e._v(" "),t("h2",[e._v("みんなが使っている参考書")]),e._v(" "),t("hr"),t("br"),e._v(" "),t("top-page-each-books",{attrs:{books:e.popularBooks}}),e._v(" "),t("br"),e._v(" "),e.currentUser?t("tepmlate",[e.currentUser.first_choice_school?[t("br"),e._v(" "),t("h2",[e._v(e._s(e.currentUser.first_choice_school)+"を志望している人が使っている参考書")]),e._v(" "),t("hr"),t("br"),e._v(" "),t("top-page-each-books",{attrs:{books:e.firstChoiceSchoolBooks}})]:e._e(),e._v(" "),e.currentUser.second_choice_school?[t("br"),e._v(" "),t("h2",[e._v(e._s(e.currentUser.second_choice_school)+"を志望している人が使っている参考書")]),e._v(" "),t("hr"),t("br"),e._v(" "),t("top-page-each-books",{attrs:{books:e.secondChoiceSchoolBooks}})]:e._e(),e._v(" "),e.currentUser.third_choice_school?[t("br"),e._v(" "),t("h2",[e._v(e._s(e.currentUser.third_choice_school)+"を志望している人が使っている参考書")]),e._v(" "),t("hr"),t("br"),e._v(" "),t("top-page-each-books",{attrs:{books:e.thirdChoiceSchoolBooks}})]:e._e(),e._v(" "),null===e.currentUser.first_choice_school||""===e.currentUser.first_choice_school&&null===e.currentUser.second_choice_school||""===e.currentUser.second_choice_school&&null===e.currentUser.third_choice_school||""===e.currentUser.third_choice_school?[t("h2",[e._v("あなたと同じ大学を志望している人が使っている参考書")]),e._v(" "),t("p",[e._v("志望大学を登録すると使用できます")])]:e._e()],2):[t("h2",[e._v("あなたと同じ大学を志望している人が使っている参考書")]),e._v(" "),t("p",[e._v("ログイン後に使用できます")])],e._v(" "),t("br"),e._v(" "),t(x.a,{attrs:{timeout:3e3,color:e.snackbarColor},model:{value:e.snackbar,callback:function(t){e.snackbar=t},expression:"snackbar"}},[e._v(e._s(e.flashMessage))])],2)}),[],!1,null,null,null));t.default=O.exports}}]);