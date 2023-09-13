
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

describe("質問一覧", () => {

  it("質問が3件投稿されている参考書の詳細にアクセスすると、3件の質問が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("サンプル参考書1").should("be.visible").click()

    cy.get(".v-tabs").contains("質問").click()

    cy.contains("サンプル質問タイトル1")

    cy.contains("サンプル質問タイトル2")

    cy.contains("サンプル質問タイトル3")
  })

})

describe("全質問一覧", () => {

  it("質問が3件投稿されている状態で質問一覧ページにアクセスすると、3件の質問が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.contains("サンプル質問タイトル1")

    cy.contains("サンプル質問タイトル2")

    cy.contains("サンプル質問タイトル3")
  })
})

describe("質問の検索機能", () => {

  context("質問タイトルで検索", () => {

    it("質問一覧ページで質問を質問タイトルで検索すると、キーワードが完全一致する質問が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click()

      cy.contains("質問一覧").click()

      cy.get("[data-cy=search-questions-field]").type("英語の質問1")

      cy.get("[data-cy=search-questions-button]").click()

      cy.contains("検索結果1件")

      cy.contains("英語の質問1")
    })

    it("質問一覧ページで質問を質問タイトルで検索すると、キーワードが部分一致する質問が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click()

      cy.contains("質問一覧").click()

      cy.get("[data-cy=search-questions-field]").type("英語の質問")

      cy.get("[data-cy=search-questions-button]").click()

      cy.contains("検索結果")

      cy.contains("英語の質問1")

      cy.contains("英語の質問2")

      cy.contains("英語の質問3")

      cy.contains("英語の質問4")
    })

  })
  context("質問本文で検索", () => {

    it("質問一覧ページで質問を質問本文で検索すると、キーワードが完全一致する質問が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click()

      cy.contains("質問一覧").click()

      cy.get("[data-cy=search-questions-field]").type("to不定詞の使い方を教えてください")

      cy.get("[data-cy=search-questions-button]").click()

      cy.contains("検索結果1件")

      cy.contains("英語の質問1")
    })

    it("質問一覧ページで質問を質問本文で検索すると、キーワードが部分一致する質問が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click()

      cy.contains("質問一覧").click()

      cy.get("[data-cy=search-questions-field]").type("教えてください")

      cy.get("[data-cy=search-questions-button]").click()

      cy.contains("検索結果")

      cy.contains("英語の質問1")

      cy.contains("英語の質問2")

      cy.contains("英語の質問3")

      cy.contains("英語の質問4")
    })

  })
  context("質問科目で検索", () => {

    it("質問一覧ページで質問を質問科目で検索すると、キーワードが完全一致する質問が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click()

      cy.contains("質問一覧").click()

      cy.get("[data-cy=search-questions-field]").type("英文法")

      cy.get("[data-cy=search-questions-button]").click()

      cy.contains("検索結果")

      cy.contains("英語の質問1")

      cy.contains("英語の質問2")

      cy.contains("英語の質問3")

      cy.contains("英語の質問4")
    })

    it("質問一覧ページで質問を質問科目で検索すると、キーワードが部分一致する質問が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click()

      cy.contains("質問一覧").click()

      cy.get("[data-cy=search-questions-field]").type("文法")

      cy.get("[data-cy=search-questions-button]").click()

      cy.contains("検索結果")

      cy.contains("英語の質問1")

      cy.contains("英語の質問2")

      cy.contains("英語の質問3")

      cy.contains("英語の質問4")
    })

  })

})

describe("質問の並べ替え機能", () => {

  it("質問を「新着順」で並び替えると、新着順に質問が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.get("[data-cy=sort-questions-select]").click()

    cy.contains("新着順").click()

    cy.get("[data-cy=each-questions]").first().contains("サンプル質問タイトル1")
  })

  it("質問を「投稿順」で並び替えると、投稿順に質問が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.get("[data-cy=sort-questions-select]").click()

    cy.contains("投稿順").click()

    cy.get("[data-cy=each-questions]").first().contains("サンプル質問タイトル1")
  })

  it("質問を「いいね!が多い順」で並び替えると、いいねが多い順に質問が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.get("[data-cy=sort-questions-select]").click()

    cy.contains("いいね!が多い順").click()

    cy.get("[data-cy=each-questions]").first().contains("英語の質問2")
  })

  it("質問を「返信が多い順」で並び替えると、返信が多い順に質問が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.get("[data-cy=sort-questions-select]").click()

    cy.contains("返信が多い順").click()

    cy.get("[data-cy=each-questions]").first().contains("英語の質問1")
  })

})

describe("質問の絞り込み機能", () => {

  it("質問を「英文法」の科目で絞り込むと、科目が英文法の質問のみが表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.get("[data-cy=filter-questions-select]").click()

    cy.get(".v-menu__content").contains("英文法").click()

    cy.contains("英語の質問1")

    cy.contains("英語の質問2")

    cy.contains("英語の質問3")

    cy.contains("英語の質問4")

    cy.contains("サンプル質問タイトル").should("not.exist")
  })

})

describe("質問の絞り込み=>並び替え機能", () => {

  it("質問を「英文法」の科目で絞り込み、「新着順」で並び替えると、科目が英文法の質問のみが新着順で表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.get("[data-cy=filter-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("英文法").click()

    cy.get("[data-cy=sort-questions-select]").scrollIntoView().click({ force: true })

    cy.contains("新着順").click()

    cy.get("[data-cy=each-questions]").first().contains("英語の質問1")

    cy.contains("サンプル質問タイトル").should("not.exist")
  })

  it("質問を「英文法」の科目で絞り込み、「投稿順」で並び替えると、科目が英文法の質問のみが投稿順で表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.get("[data-cy=filter-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("英文法").click()

    cy.get("[data-cy=sort-questions-select]").scrollIntoView().click({ force: true })

    cy.contains("投稿順").click()

    cy.get("[data-cy=each-questions]").first().contains("英語の質問1")

    cy.contains("サンプル質問タイトル").should("not.exist")
  })

  it("質問を「英文法」の科目で絞り込み、「いいね!が多い順」で並び替えると、科目が英文法の質問のみがいいねが多い順で表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.get("[data-cy=filter-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("英文法").click()

    cy.get("[data-cy=sort-questions-select]").scrollIntoView().click({ force: true })

    cy.contains("いいね!が多い順").click()

    cy.get("[data-cy=each-questions]").first().contains("英語の質問2")

    cy.contains("サンプル質問タイトル").should("not.exist")
  })

  it("質問を「英文法」の科目で絞り込み、「返信が多い順」で並び替えると、科目が英文法の質問のみが返信が多い順で表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.get("[data-cy=filter-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("英文法").click()

    cy.get("[data-cy=sort-questions-select]").scrollIntoView().click({ force: true })

    cy.contains("返信が多い順").click()

    cy.get("[data-cy=each-questions]").first().contains("英語の質問1")

    cy.contains("サンプル質問タイトル").should("not.exist")
  })

})


describe("質問詳細", () => {

it("質問詳細ページにアクセスすると、質問の詳細情報が表示される", () => {
  cy.visit("/")

  cy.get("[data-cy=menu-button]").click()

  cy.contains("参考書一覧").click()

  cy.contains("サンプル参考書1").should("be.visible").click()

  cy.get(".v-tabs").contains("質問").click()

  cy.contains("サンプル質問タイトル1").should("be.visible").click({ force: true })

  cy.contains("質問詳細")

  cy.contains("サンプル質問タイトル1")

  cy.get("[data-cy=question-detail]").find("textarea").should("have.value", "サンプル質問本文1")

  cy.get("[data-cy=favorite-section]").contains("いいね!")

  cy.get("[data-cy=favorite-section]").contains("1")

  cy.get("[data-cy=reply-section]").contains("返信")

  cy.get("[data-cy=reply-section]").contains("2")
})

  it("質問詳細ページにアクセスすると、質問に関連する参考書情報が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("サンプル参考書1").should("be.visible").click()

    cy.get(".v-tabs").contains("質問").click()

    cy.contains("サンプル質問タイトル1").should("be.visible").click({ force: true })

    cy.contains("質問詳細")

    cy.contains("サンプル参考書1")

    cy.contains("現代文")

    cy.contains("サンプル著者1")

    cy.contains("サンプル出版社1")

    cy.get("[data-cy=book-review-section]").contains("レビュー")

    cy.get("[data-cy=book-review-section]").contains("3件")

    cy.get("[data-cy=book-question-section]").contains("質問")

    cy.get("[data-cy=book-question-section]").contains("3件")

    cy.get("[data-cy=book-favorite-section]").contains("お気に入り")

    cy.get("[data-cy=book-favorite-section]").contains("1")
  })

})


describe("質問投稿", () => {

  it("ログイン状態で質問を投稿すると、質問の投稿に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("サンプル参考書1").click()

    cy.get("[data-cy=question-dialog-button]").click({force: true})

    cy.get("[data-cy=question-title-form]").type("質問タイトル")

    cy.get("[data-cy=question-content-form]").type("質問本文")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("質問の投稿が完了しました")

    cy.contains("質問詳細")

    cy.contains("質問タイトル")

    cy.get("textarea").should("have.value", "質問本文")
  })

  it("未ログイン状態で質問を投稿すると、ログインページにリダイレクトする", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("サンプル参考書1").should("be.visible").click()

    cy.get("[data-cy=question-dialog-button]").click({force: true})

    cy.url().should("include", "/auth/login")

    cy.contains("ログインが必要です")
  })

  it("ログイン状態で不正なパラメーターで質問を投稿すると、質問投稿に失敗する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("サンプル参考書1").should("be.visible").click()

    cy.get("[data-cy=question-dialog-button]").click({force: true})

    cy.get("[data-cy=question-title-form]").click()

    cy.get("[data-cy=question-title-form]").blur()

    cy.contains("タイトルを入力してください")

    cy.get("[data-cy=question-content-form]").click()

    cy.get("[data-cy=question-content-form]").blur()

    cy.contains("本文を入力してください")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("質問を投稿できませんでした")
  })

})

describe("質問編集", () => {

  it("ログイン状態で自分の質問を編集すると、質問の編集に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get(".v-tabs").contains("投稿した質問").click()

    cy.contains("サンプル質問タイトル1").click()

    cy.contains("サンプル質問タイトル1")

    cy.get("textarea").should("have.value", "サンプル質問本文1")

    cy.contains("編集する").click({ force: true })

    cy.get("[data-cy=edit-title-field]").clear().type("編集後サンプル質問タイトル")

    cy.get("[data-cy=edit-content-field]").clear().type("編集後サンプル質問本文")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("質問の編集が完了しました")

    cy.contains("編集後サンプル質問タイトル")

    cy.get("textarea").should("have.value", "編集後サンプル質問本文")
  })

  it("ログイン状態で自分の質問を不正なパラメーターで編集すると、質問の編集に失敗する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get(".v-tabs").contains("投稿した質問").click()

    cy.contains("サンプル質問タイトル3").click()

    cy.contains("サンプル質問タイトル3")

    cy.contains("編集する").click({ force: true })

    cy.get("[data-cy=edit-title-field]").clear()

    cy.contains("タイトルを入力してください")

    cy.get("[data-cy=edit-content-field]").clear()

    cy.contains("本文を入力してください")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("質問を編集できませんでした")
  })

  it("ログイン状態で他人の質問詳細ページにアクセスすると,質問編集ボタンが表示されない", () => {

    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.contains("サンプル質問タイトル2").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.contains("編集する").should("not.exist")


  })

  it("未ログイン状態だと、質問の編集ボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("サンプル参考書1").should("be.visible").click()

    cy.get(".v-tabs").contains("質問").click()

    cy.contains("サンプル質問タイトル3").click()

    cy.contains("編集する").should("not.exist")
  })

})

describe("質問削除", () => {

  it("ログイン状態で自分の質問を削除すると、質問の削除に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get(".v-tabs").contains("投稿した質問").click()

    cy.contains("サンプル質問タイトル3").click()

    cy.contains("削除する").click({ force: true })

    cy.contains("質問を削除しますか？")

    cy.get("[data-cy=delete-confirm-button]").click()

    cy.contains("質問を削除しました")

    cy.visit("/mypage")

    cy.get(".v-tabs").contains("投稿した質問").click()

    cy.contains("サンプル質問タイトル3").should("not.exist")
  })

  it("ログイン状態で他人の質問詳細ページにアクセスすると,質問削除ボタンが表示されない", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.contains("サンプル質問タイトル2").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.contains("削除する").should("not.exist")
  })


  it("未ログイン状態だと、質問の削除ボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("サンプル参考書3").scrollIntoView().click()

    cy.get(".v-tabs").contains("質問").click()

    cy.contains("サンプル質問タイトル4").click()

    cy.contains("削除する").should("not.exist")
  })

})

describe("コンテンツナビゲーター", () => {

  it.only("質問詳細ページで「次の質問」「前の質問」のナビゲーション機能が動作する", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("サンプル参考書1").should("be.visible").click()

    cy.contains("参考書詳細")

    cy.get(".v-tabs").contains("質問").click()

    cy.contains("サンプル質問タイトル1").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.contains("サンプル質問タイトル1")

    cy.get("[data-cy=next-content-button]").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.contains("サンプル質問タイトル2")

    cy.get("[data-cy=previous-content-button]").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.contains("サンプル質問タイトル1")
  })

})





