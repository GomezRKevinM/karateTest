Feature: Probando karate para interactuar con posts

  Background:
    * url 'https://jsonplaceholder.typicode.com'

  Scenario: Obtener todos los posts
    Given path 'posts'
    When method get
    Then status 200
    And assert response.length > 0


  Scenario: Crear un post
    * def new_post =
    """
      {
        "userID": 1,
        "title": "Nuevo post",
        "body": "Post creado desde la prueba"
      }
    """
    Given path 'posts'
    And request new_post
    When method post
    Then status 201
    And match response.userID == new_post.userID
    And match response.title == new_post.title
    And match response.body == new_post.body
    And match response.id != null

  Scenario: Obtener un post por id
    * def postExpected =
    """
    {
      "userId": 1,
      "id": 2,
      "title": "qui est esse",
      "body": "est rerum tempore vitae\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\nqui aperiam non debitis possimus qui neque nisi nulla"
    }
    """
    Given path '/posts/2'
    When method get
    Then status 200
    And match response == postExpected

    Scenario: Obtener todos los comentarios de un post
      Given path '/comments'
      And param postsId = 2
      When method get
      Then status 200
      * def len = response.length
      And assert len == 500

    Scenario: Eliminar un post
      Given path '/posts/9'
      When method delete
      Then status 200