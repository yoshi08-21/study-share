(window.webpackJsonp=window.webpackJsonp||[]).push([[36],{827:function(e,t,n){"use strict";n.r(t);var r=n(601),l=n(255),o=n(111),v=n(565),c=n(164),_=n(209),h=n(596),y=n(564),d=n(772),m=n(800),f=n(831),j=n(567),C=(n(35),n(26)),k=(n(55),n(82),n(605)),P=n(599),Q=n(606),x=n(600),R=n(607),w=n(603),S=n(44),T={components:{EachReviews:k.a,EachQuestions:P.a,EachReplies:Q.a,EachSubjectQuestions:x.a,EachSubjectQuestionReplies:R.a,EachSurveys:w.a},asyncData:function(e){return Object(C.a)(regeneratorRuntime.mark((function t(){var n,r;return regeneratorRuntime.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return n=e.params,t.prev=1,t.next=4,S.a.get("/users/show_other_user/".concat(n.id));case 4:return r=t.sent,console.log(r.data),t.abrupt("return",{user:r.data.user,myQuestions:r.data.my_questions,myReviews:r.data.my_reviews,myReplies:r.data.my_replies,mySubjectQuestions:r.data.my_subject_questions,mySubjectQuestionReplies:r.data.my_subject_question_replies,mySurveys:r.data.my_surveys,myFavoriteReviewsCount:r.data.my_favorite_reviews_count,myFavoriteQuestionsCount:r.data.my_favorite_questions_count,myFavoriteRepliesCount:r.data.my_favorite_replies_count,myFavoriteSubjectQuestionsCount:r.data.my_favorite_subject_questions_count,myFavoriteSubjectQuestionRepliesCount:r.data.my_favorite_subject_question_replies_count,myFavoriteSurveysCount:r.data.my_favorite_surveys_count});case 9:t.prev=9,t.t0=t.catch(1),console.log(t.t0);case 12:case"end":return t.stop()}}),t,null,[[1,9]])})))()},data:function(){return{tab:0,tabs:[{label:"投稿したレビュー"},{label:"投稿した質問"},{label:"投稿した科目別質問"},{label:"投稿した返信"},{label:"投稿した返信（科目別質問）"},{label:"作成したアンケート"}],perPage:10,page:1}},computed:{reviewsChunk:function(){var e=(this.page-1)*this.perPage,t=e+this.perPage;return this.myReviews.slice(e,t)},questionsChunk:function(){var e=(this.page-1)*this.perPage,t=e+this.perPage;return this.myQuestions.slice(e,t)},repliesChunk:function(){var e=(this.page-1)*this.perPage,t=e+this.perPage;return this.myReplies.slice(e,t)},subjectQuestionsChunk:function(){var e=(this.page-1)*this.perPage,t=e+this.perPage;return this.mySubjectQuestions.slice(e,t)},subjectQuestionRepliesChunk:function(){var e=(this.page-1)*this.perPage,t=e+this.perPage;return this.mySubjectQuestionReplies.slice(e,t)},surveysChunk:function(){var e=(this.page-1)*this.perPage,t=e+this.perPage;return this.mySurveys.slice(e,t)},reviewsTotalPages:function(){return Math.ceil(this.myReviews.length/this.perPage)},questionsTotalPages:function(){return Math.ceil(this.myQuestions.length/this.perPage)},repliesTotalPages:function(){return Math.ceil(this.myReplies.length/this.perPage)},subjectQuestionsTotalPages:function(){return Math.ceil(this.mySubjectQuestions.length/this.perPage)},subjectQuestionRepliesTotalPages:function(){return Math.ceil(this.mySubjectQuestionReplies.length/this.perPage)},surveysTotalPages:function(){return Math.ceil(this.mySurveys.length/this.perPage)}}},F=n(69),component=Object(F.a)(T,(function(){var e=this,t=e._self._c;return t("div",[t("br"),e._v(" "),t(y.a,{staticClass:"justify-center"},[t(v.a,{attrs:{cols:"8"}},[t(l.a,{staticStyle:{"border-radius":"20px"}},[t("div",{staticStyle:{"text-align":"center"}},[e._v("\n          プロフィール\n        ")]),e._v(" "),t("hr"),e._v(" "),t(o.d,[t(y.a,[t(v.a,{staticClass:"d-flex justify-center"},[e.user.image?t("div",[t(_.a,{attrs:{src:e.user.image,alt:"画像",contain:"","max-height":"150","max-width":"150"}})],1):e._e()])],1)],1),e._v(" "),t(o.b,{staticStyle:{"text-align":"center","margin-top":"10px"}},[t("h1",[e._v(e._s(e.user.name))])]),e._v(" "),t("br"),t("br"),e._v(" "),t(y.a,{staticClass:"justify-center"},[t(v.a,{attrs:{cols:"10"}},[t(l.a,{staticStyle:{border:"solid 0.1px"},attrs:{hover:"",light:""}},[t(o.d,{staticStyle:{"justify-content":"center"}},[e._v("\n                "+e._s(e.user.name)+"さんのアクティビティ\n              ")]),e._v(" "),t(o.c,[t(d.a,{scopedSlots:e._u([{key:"default",fn:function(){return[t("thead",[t("tr",[t("th",[e._v("アクティビティ")]),e._v(" "),t("th",[e._v("件数")]),e._v(" "),t("th",[e._v("獲得したいいね!")])])]),e._v(" "),t("tbody",[t("tr",[t("td",[e._v("投稿したレビュー")]),e._v(" "),t("td",[e._v(e._s(e.myReviews.length)+"件")]),e._v(" "),t("td",[t(c.a,[e._v("mdi-heart-multiple")]),e._v(" "+e._s(e.myFavoriteReviewsCount))],1)]),e._v(" "),t("tr",[t("td",[e._v("投稿した質問")]),e._v(" "),t("td",[e._v(e._s(e.myQuestions.length)+"件")]),e._v(" "),t("td",[t(c.a,[e._v("mdi-heart-multiple")]),e._v(" "+e._s(e.myFavoriteQuestionsCount))],1)]),e._v(" "),t("tr",[t("td",[e._v("投稿した質問(科目別)")]),e._v(" "),t("td",[e._v(e._s(e.mySubjectQuestions.length)+"件")]),e._v(" "),t("td",[t(c.a,[e._v("mdi-heart-multiple")]),e._v(" "+e._s(e.myFavoriteSubjectQuestionsCount))],1)]),e._v(" "),t("tr",[t("td",[e._v("投稿した返信")]),e._v(" "),t("td",[e._v(e._s(e.myReplies.length)+"件")]),e._v(" "),t("td",[t(c.a,[e._v("mdi-heart-multiple")]),e._v(" "+e._s(e.myFavoriteRepliesCount))],1)]),e._v(" "),t("tr",[t("td",[e._v("投稿した返信(科目別)")]),e._v(" "),t("td",[e._v(e._s(e.mySubjectQuestionReplies.length)+"件")]),e._v(" "),t("td",[t(c.a,[e._v("mdi-heart-multiple")]),e._v(" "+e._s(e.myFavoriteSubjectQuestionRepliesCount))],1)]),e._v(" "),t("tr",[t("td",[e._v("作成したアンケート")]),e._v(" "),t("td",[e._v(e._s(e.mySurveys.length)+"件")]),e._v(" "),t("td",[t(c.a,[e._v("mdi-heart-multiple")]),e._v(" "+e._s(e.myFavoriteSurveysCount))],1)])])]},proxy:!0}])})],1)],1),e._v(" "),t("br"),t("br"),e._v(" "),t("h4",[e._v("志望校")]),e._v(" "),t("hr"),t("br"),e._v(" "),t("h3",[e._v("第一志望: "+e._s(e.user.first_choice_school))]),e._v(" "),t("br"),e._v(" "),t("h3",[e._v("第二志望: "+e._s(e.user.second_choice_school))]),e._v(" "),t("br"),e._v(" "),t("h3",[e._v("第三志望: "+e._s(e.user.third_choice_school))]),e._v(" "),t("br"),t("br"),e._v(" "),t("h4",[e._v("自己紹介")]),e._v(" "),t("hr"),t("br"),e._v(" "),t(j.a,{attrs:{value:e.user.introduction,readonly:"",outlined:"",rounded:"",dense:"","auto-grow":""}}),e._v(" "),t("br")],1)],1)],1)],1)],1),e._v(" "),t("br"),t("br"),t("br"),e._v(" "),t(f.a,{attrs:{centered:""},model:{value:e.tab,callback:function(t){e.tab=t},expression:"tab"}},e._l(e.tabs,(function(n,r){return t(m.a,{key:r,on:{click:function(t){e.page=1}}},[e._v("\n      "+e._s(n.label)+"\n    ")])})),1),e._v(" "),t("div",{attrs:{"data-cy":"tab-content"}},[0===e.tab?[t("br"),t("br"),t("br"),e._v(" "),e.reviewsChunk.length>0?[t(h.a,{attrs:{length:e.reviewsTotalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}}),e._v(" "),t("br"),e._v(" "),t("each-reviews",{attrs:{reviews:e.reviewsChunk}}),e._v(" "),t("br"),e._v(" "),t(h.a,{attrs:{length:e.reviewsTotalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}})]:[t("br"),e._v(" "),t(y.a,[t(v.a,{staticClass:"d-flex justify-center"},[t(r.a,{attrs:{type:"info"}},[e._v("\n            レビューは投稿されていません\n            ")])],1)],1)]]:1===e.tab?[t("br"),t("br"),t("br"),e._v(" "),e.questionsChunk.length>0?[t(h.a,{attrs:{length:e.questionsTotalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}}),e._v(" "),t("br"),e._v(" "),t("each-questions",{attrs:{questions:e.questionsChunk}}),e._v(" "),t("br"),e._v(" "),t(h.a,{attrs:{length:e.questionsTotalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}})]:[t("br"),e._v(" "),t(y.a,[t(v.a,{staticClass:"d-flex justify-center"},[t(r.a,{attrs:{type:"info"}},[e._v("\n            質問は投稿されていません\n            ")])],1)],1)]]:2===e.tab?[t("br"),t("br"),t("br"),e._v(" "),e.subjectQuestionsChunk.length>0?[t(h.a,{attrs:{length:e.subjectQuestionsTotalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}}),e._v(" "),t("br"),e._v(" "),t("each-subject-questions",{attrs:{subjectQuestions:e.subjectQuestionsChunk}}),e._v(" "),t("br"),e._v(" "),t(h.a,{attrs:{length:e.subjectQuestionsTotalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}})]:[t("br"),e._v(" "),t(y.a,[t(v.a,{staticClass:"d-flex justify-center"},[t(r.a,{attrs:{type:"info"}},[e._v("\n            科目別質問は投稿されていません\n            ")])],1)],1)]]:3===e.tab?[t("br"),t("br"),t("br"),e._v(" "),e.repliesChunk.length>0?[t(h.a,{attrs:{length:e.repliesTotalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}}),e._v(" "),t("br"),e._v(" "),t("each-replies",{attrs:{replies:e.repliesChunk}}),e._v(" "),t("br"),e._v(" "),t(h.a,{attrs:{length:e.repliesTotalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}})]:[t("br"),e._v(" "),t(y.a,[t(v.a,{staticClass:"d-flex justify-center"},[t(r.a,{attrs:{type:"info"}},[e._v("\n            返信は投稿されていません\n            ")])],1)],1)]]:4===e.tab?[t("br"),t("br"),t("br"),e._v(" "),e.subjectQuestionRepliesChunk.length>0?[t(h.a,{attrs:{length:e.subjectQuestionRepliesTotalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}}),e._v(" "),t("br"),e._v(" "),t("each-subject-question-replies",{attrs:{subjectQuestionReplies:e.subjectQuestionRepliesChunk}}),e._v(" "),t("br"),e._v(" "),t(h.a,{attrs:{length:e.subjectQuestionRepliesTotalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}})]:[t("br"),e._v(" "),t(y.a,[t(v.a,{staticClass:"d-flex justify-center"},[t(r.a,{attrs:{type:"info"}},[e._v("\n            返信(科目別質問)は投稿されていません\n            ")])],1)],1)]]:5===e.tab?[t("br"),t("br"),t("br"),e._v(" "),e.surveysChunk.length>0?[t(h.a,{attrs:{length:e.surveysTotalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}}),e._v(" "),t("br"),e._v(" "),t("each-surveys",{attrs:{surveys:e.surveysChunk}}),e._v(" "),t("br"),e._v(" "),t(h.a,{attrs:{length:e.surveysTotalPages},model:{value:e.page,callback:function(t){e.page=t},expression:"page"}})]:[t("br"),e._v(" "),t(y.a,[t(v.a,{staticClass:"d-flex justify-center"},[t(r.a,{attrs:{type:"info"}},[e._v("\n            アンケートは作成されていません\n            ")])],1)],1)]]:e._e()],2)],1)}),[],!1,null,null,null);t.default=component.exports}}]);