




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

    cy.contains("サンプル参考書").should("not.exist")
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

    cy.contains("サンプル参考書").should("not.exist")
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

    cy.contains("サンプル参考書").should("not.exist")
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

    cy.contains("サンプル参考書").should("not.exist")
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

    cy.contains("サンプル参考書").should("not.exist")
  })

})

