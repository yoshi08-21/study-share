
before(() => {
  cy.exec("cd ../ && cd backend && RAILS_ENV=test bundle exec rake db:reset db:seed")
});

beforeEach(() => {
  cy.visit("/")

  cy.wait(1000)

  cy.get("body").then(body => {
    if (body[0].querySelector("[data-cy=header-user-menu]")) {
        cy.get("[data-cy=header-user-menu]").click();
        cy.get("[data-cy=header-logout-button]").should("be.visible").click();
    }
  });
})

after(() => {
  cy.visit("/")

  cy.wait(1000)

  cy.get("body").then(body => {
    if (body[0].querySelector("[data-cy=header-user-menu]")) {
        cy.get("[data-cy=header-user-menu]").click();
        cy.get("[data-cy=header-logout-button]").should("be.visible").click();
    }
  });
})


describe("全科目別質問一覧", () => {

  it("科目別質問が3件投稿されている状態で科目別質問一覧ページにアクセスすると、3件の科目別質問が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.contains("サンプル科目別質問タイトル1")

    cy.contains("サンプル科目別質問タイトル2")

    cy.contains("サンプル科目別質問タイトル3")
  })
})

describe("科目別質問の検索機能", () => {

  context("科目別質問タイトルで検索", () => {

    it("科目別質問一覧ページで科目別質問を科目別質問タイトルで検索すると、キーワードが完全一致する科目別質問が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click()

      cy.contains("科目別質問一覧").click()

      cy.get("[data-cy=search-subject-questions-field]").type("英語の科目別質問1")

      cy.get("[data-cy=search-subject-questions-button]").click()

      cy.contains("検索結果1件")

      cy.contains("英語の科目別質問1")
    })

    it("科目別質問一覧ページで科目別質問を科目別質問タイトルで検索すると、キーワードが部分一致する科目別質問が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click()

      cy.contains("科目別質問一覧").click()

      cy.get("[data-cy=search-subject-questions-field]").type("英語の科目別質問")

      cy.get("[data-cy=search-subject-questions-button]").click()

      cy.contains("検索結果")

      cy.contains("英語の科目別質問1")

      cy.contains("英語の科目別質問2")

      cy.contains("英語の科目別質問3")

      cy.contains("英語の科目別質問4")
    })

  })
  context("科目別質問本文で検索", () => {

    it("科目別質問一覧ページで科目別質問を科目別質問本文で検索すると、キーワードが完全一致する科目別質問が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click()

      cy.contains("科目別質問一覧").click()

      cy.get("[data-cy=search-subject-questions-field]").type("to不定詞の使い方を教えてください")

      cy.get("[data-cy=search-subject-questions-button]").click()

      cy.contains("検索結果1件")

      cy.contains("英語の科目別質問1")
    })

    it("科目別質問一覧ページで科目別質問を科目別質問本文で検索すると、キーワードが部分一致する科目別質問が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click()

      cy.contains("科目別質問一覧").click()

      cy.get("[data-cy=search-subject-questions-field]").type("教えてください")

      cy.get("[data-cy=search-subject-questions-button]").click()

      cy.contains("検索結果")

      cy.contains("英語の科目別質問1")

      cy.contains("英語の科目別質問2")

      cy.contains("英語の科目別質問3")

      cy.contains("英語の科目別質問4")
    })

  })
  context("質問科目で検索", () => {

    it("科目別質問一覧ページで科目別質問を質問科目で検索すると、キーワードが完全一致する科目別質問が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click()

      cy.contains("科目別質問一覧").click()

      cy.get("[data-cy=search-subject-questions-field]").type("英文法")

      cy.get("[data-cy=search-subject-questions-button]").click()

      cy.contains("検索結果")

      cy.contains("英語の科目別質問1")

      cy.contains("英語の科目別質問2")

      cy.contains("英語の科目別質問3")

      cy.contains("英語の科目別質問4")
    })

    it("科目別質問一覧ページで科目別質問を質問科目で検索すると、キーワードが部分一致する科目別質問が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click()

      cy.contains("科目別質問一覧").click()

      cy.get("[data-cy=search-subject-questions-field]").type("文法")

      cy.get("[data-cy=search-subject-questions-button]").click()

      cy.contains("検索結果")

      cy.contains("英語の科目別質問1")

      cy.contains("英語の科目別質問2")

      cy.contains("英語の科目別質問3")

      cy.contains("英語の科目別質問4")
    })

  })

})

describe("科目別質問の並べ替え機能", () => {

  it("科目別質問を「新着順」で並び替えると、新着順に科目別質問が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=sort-subject-questions-select]").scrollIntoView().click()

    cy.contains("新着順").click()

    cy.get("[data-cy=each-subject-questions]").first().contains("英語の科目別質問4")
  })

  it("科目別質問を「投稿順」で並び替えると、投稿順に科目別質問が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=sort-subject-questions-select]").scrollIntoView().click()

    cy.contains("投稿順").click()

    cy.get("[data-cy=each-subject-questions]").first().contains("サンプル科目別質問タイトル1")
  })

  it("科目別質問を「いいね!が多い順」で並び替えると、いいねが多い順に科目別質問が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=sort-subject-questions-select]").scrollIntoView().click()

    cy.contains("いいね!が多い順").click()

    cy.get("[data-cy=each-subject-questions]").first().contains("英語の科目別質問2")
  })

  it("科目別質問を「返信が多い順」で並び替えると、返信が多い順に科目別質問が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=sort-subject-questions-select]").scrollIntoView().click()

    cy.contains("返信が多い順").click()

    cy.get("[data-cy=each-subject-questions]").first().contains("英語の科目別質問3")
  })

})

describe("科目別質問の絞り込み機能", () => {

  it("科目別質問を「英文法」の科目で絞り込むと、科目が英文法の科目別質問のみが表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").contains("英文法").click()

    cy.contains("英語の科目別質問1")

    cy.contains("英語の科目別質問2")

    cy.contains("英語の科目別質問3")

    cy.contains("英語の科目別質問4")

    cy.contains("サンプル科目別質問").should("not.exist")
  })

})

describe("科目別質問の絞り込み=>並び替え機能", () => {

  it("科目別質問を「英文法」の科目で絞り込み、「新着順」で並び替えると、科目が英文法の科目別質問のみが新着順で表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("英文法").click()

    cy.get("[data-cy=sort-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.contains("新着順").click()

    cy.get("[data-cy=each-subject-questions]").first().contains("英語の科目別質問4")

    cy.contains("サンプル科目別質問").should("not.exist")
  })

  it("科目別質問を「英文法」の科目で絞り込み、「投稿順」で並び替えると、科目が英文法の科目別質問のみが投稿順で表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("英文法").click()

    cy.get("[data-cy=sort-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.contains("投稿順").click()

    cy.get("[data-cy=each-subject-questions]").first().contains("英語の科目別質問1")

    cy.contains("サンプル科目別質問").should("not.exist")
  })

  it("科目別質問を「英文法」の科目で絞り込み、「いいね!が多い順」で並び替えると、科目が英文法の科目別質問のみがいいねが多い順で表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("英文法").click()

    cy.get("[data-cy=sort-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.contains("いいね!が多い順").click()

    cy.get("[data-cy=each-subject-questions]").first().contains("英語の科目別質問2")

    cy.contains("サンプル科目別質問").should("not.exist")
  })

  it("科目別質問を「英文法」の科目で絞り込み、「返信が多い順」で並び替えると、科目が英文法の科目別質問のみが返信が多い順で表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("英文法").click()

    cy.get("[data-cy=sort-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.contains("返信が多い順").click()

    cy.get("[data-cy=each-subject-questions]").first().contains("英語の科目別質問3")

    cy.contains("サンプル科目別質問").should("not.exist")
  })

})


describe("科目別質問詳細", () => {

  it("科目別質問詳細ページにアクセスすると、科目別質問の詳細情報が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.contains("サンプル科目別質問タイトル1").click()

    cy.contains("質問詳細(科目別)")

    cy.contains("サンプル科目別質問タイトル1")

    cy.contains("科目")

    cy.contains("リスニング")

    cy.get("[data-cy=subject-question-detail]").find("textarea").should("have.value", "サンプル科目別質問本文1")

    cy.get("[data-cy=favorite-section]").contains("いいね!")

    cy.get("[data-cy=favorite-section]").contains("1")

    cy.get("[data-cy=subject-question-reply-section]").contains("返信")

    cy.get("[data-cy=subject-question-reply-section]").contains("2")
  })

})


describe("科目別質問投稿", () => {

  it("ログイン状態で科目別質問を投稿すると、科目別質問の投稿に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.contains("新しい質問を投稿する").click()

    cy.contains("質問を投稿する")

    cy.contains("科目を選択する(必須)").click()

    cy.get("[data-cy=select-subject-group]").find(".v-label").first().click()

    cy.get("[data-cy=close-select-subject-dialog]").click()

    cy.contains("選択された科目:現代文")

    cy.get("[data-cy=create-title-field]").type("新規サンプル科目別質問タイトル")

    cy.get("[data-cy=create-content-field]").type("新規サンプル科目別質問本文")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("質問の投稿が完了しました")

    cy.contains("質問詳細(科目別)")

    cy.contains("新規サンプル科目別質問タイトル")

    cy.contains("科目")

    cy.contains("現代文")

    cy.get("[data-cy=subject-question-detail]").find("textarea").should("have.value", "新規サンプル科目別質問本文")
  })

  it("未ログイン状態で科目別質問を投稿すると、ログインページにリダイレクトする", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.contains("新しい質問を投稿する").click()

    cy.url().should("include", "/auth/login")

    cy.contains("ログインが必要です")
  })

  it("ログイン状態で不正なパラメーターで科目別質問を投稿すると、科目別質問投稿に失敗する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.contains("新しい質問を投稿する").click()

    cy.contains("質問を投稿する")

    cy.get("[data-cy=create-title-field]").click().blur()

    cy.contains("タイトルを入力してください")

    cy.get("[data-cy=create-content-field]").click().blur()

    cy.contains("本文を入力してください")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("質問を投稿できませんでした")
  })

})

describe("科目別質問編集", () => {

  it("ログイン状態で自分の科目別質問を編集すると、科目別質問の編集に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get(".v-tabs").contains("投稿した科目別質問").click()

    cy.contains("編集用科目別質問").click()

    cy.contains("編集用科目別質問")

    cy.contains("科目")

    cy.contains("その他科目")

    cy.get("textarea").should("have.value", "編集前科目別質問本文")

    cy.contains("編集する").click({ force: true })

    cy.contains("科目を選択する(必須)").click()

    cy.get("[data-cy=select-subject-group]").find(".v-label").eq(1).click()

    cy.get("[data-cy=close-select-subject-dialog]").click()

    cy.contains("選択された科目:古文")

    cy.get("[data-cy=edit-title-field]").clear().type("編集後科目別質問タイトル")

    cy.get("[data-cy=edit-content-field]").clear().type("編集後科目別質問本文")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("質問の編集が完了しました")

    cy.contains("編集後科目別質問タイトル")

    cy.contains("科目")

    cy.contains("古文")

    cy.get("[data-cy=subject-question-detail]").find("textarea").should("have.value", "編集後科目別質問本文")
  })

  it("ログイン状態で自分の科目別質問を不正なパラメーターで編集すると、科目別質問の編集に失敗する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get(".v-tabs").contains("投稿した科目別質問").click()

    cy.contains("編集失敗用科目別質問").click()

    cy.contains("編集失敗用科目別質問")

    cy.contains("編集する").click({ force: true })

    cy.get("[data-cy=edit-title-field]").clear()

    cy.contains("タイトルを入力してください")

    cy.get("[data-cy=edit-content-field]").clear()

    cy.contains("本文を入力してください")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("質問を編集できませんでした")
  })

  it("ログイン状態で他人の科目別質問詳細ページにアクセスすると,質問編集ボタンが表示されない", () => {

    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get(".v-pagination").contains("2").click()

    cy.contains("他ユーザー投稿科目別質問タイトル").scrollIntoView().click({ force: true })

    cy.contains("質問詳細(科目別)")

    cy.contains("編集する").should("not.exist")
  })

  it("未ログイン状態だと、質問編集ボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.contains("編集失敗用科目別質問").scrollIntoView().click({ force: true })

    cy.contains("質問詳細(科目別)")

    cy.contains("編集する").should("not.exist")
  })

})

describe("科目別質問削除", () => {

  it("ログイン状態で自分の科目別質問を削除すると、科目別質問の削除に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get(".v-tabs").contains("投稿した科目別質問").click()

    cy.contains("削除用科目別質問").click()

    cy.contains("削除する").click({ force: true })

    cy.contains("質問を削除しますか？")

    cy.get("[data-cy=delete-confirm-button]").click()

    cy.contains("質問を削除しました")

    cy.visit("/mypage")

    cy.get(".v-tabs").contains("投稿した科目別質問").click()

    cy.contains("削除用科目別質問").should("not.exist")
  })

  it("ログイン状態で他人の科目別質問詳細ページにアクセスすると,科目別質問削除ボタンが表示されない", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("その他科目").click()

    cy.contains("他ユーザー投稿科目別質問タイトル").scrollIntoView().click({ force: true })

    cy.contains("質問詳細(科目別)")

    cy.contains("削除する").should("not.exist")
  })


  it("未ログイン状態だと、科目別質問の削除ボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("その他科目").click()

    cy.contains("削除失敗用科目別質問").scrollIntoView().click({ force: true })

    cy.contains("質問詳細(科目別)")

    cy.contains("削除する").should("not.exist")
  })

})

describe("コンテンツナビゲーター", () => {

  it("科目別質問詳細ページで「次の{同じ科目}の質問」「前の{同じ科目}の質問」のナビゲーション機能が動作する", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.contains("サンプル科目別質問タイトル1").scrollIntoView().click({ force: true })

    cy.contains("質問詳細(科目別)")

    cy.contains("サンプル科目別質問タイトル1")

    cy.contains("リスニング")

    cy.get("[data-cy=next-content-button]").scrollIntoView().click({ force: true })

    cy.contains("質問詳細(科目別)")

    cy.contains("サンプル科目別質問タイトル2")

    cy.contains("リスニング")

    cy.get("[data-cy=previous-content-button]").scrollIntoView().click({ force: true })

    cy.contains("質問詳細(科目別)")

    cy.contains("サンプル科目別質問タイトル1")

    cy.contains("リスニング")
  })

})





