Feature: Probar endpoints de usuarios en ReqRes
  Background:
    * url 'https://reqres.in/api'

  Scenario: Obtener usuarios de la pagina 2
    * def responseExpected =
    """
    {
      "page": 2,
      "per_page": 6,
      "total": 12,
      "total_pages": 2,
      "data": [
        {
          "id": 7,
          "email": "michael.lawson@reqres.in",
          "first_name": "Michael",
          "last_name": "Lawson",
          "avatar": "https://reqres.in/img/faces/7-image.jpg"
        },
        {
          "id": 8,
          "email": "lindsay.ferguson@reqres.in",
          "first_name": "Lindsay",
          "last_name": "Ferguson",
          "avatar": "https://reqres.in/img/faces/8-image.jpg"
        },
        {
          "id": 9,
          "email": "tobias.funke@reqres.in",
          "first_name": "Tobias",
          "last_name": "Funke",
          "avatar": "https://reqres.in/img/faces/9-image.jpg"
        },
        {
          "id": 10,
          "email": "byron.fields@reqres.in",
          "first_name": "Byron",
          "last_name": "Fields",
          "avatar": "https://reqres.in/img/faces/10-image.jpg"
        },
        {
          "id": 11,
          "email": "george.edwards@reqres.in",
          "first_name": "George",
          "last_name": "Edwards",
          "avatar": "https://reqres.in/img/faces/11-image.jpg"
        },
        {
          "id": 12,
          "email": "rachel.howell@reqres.in",
          "first_name": "Rachel",
          "last_name": "Howell",
          "avatar": "https://reqres.in/img/faces/12-image.jpg"
        }
      ],
      "support": {
        "url": "https://contentcaddy.io?utm_source=reqres&utm_medium=json&utm_campaign=referral",
        "text": "Tired of writing endless social media content? Let Content Caddy generate it for you."
      }
    }
    """
    Given path '/users'
    And param page = 2
    When method get
    Then status 200
    And match response == responseExpected

    Scenario: Login exitoso
      * def user_request =
      """
        {
          "email": "eve.holt@reqres.in",
          "password": "cityslicka"
        }
      """
      * def responseExpected =
      """
        {
          "token": "QpwL5tke4Pnpja7X4"
        }
      """
      Given path '/login'
      And request user_request
      And header x-api-key = 'reqres-free-v1'
      When method post
      Then status 200
      And match response == responseExpected

      * def token = response.token

      And print 'Token generado:',token

    Scenario: Registrar un usuario y buscarlo por ID generado
      * def user_register =
      """
      {
        "email": "eve.holt@reqres.in",
        "password": "pistol"
      }
      """
      Given path '/register'
      And request user_register
      And header x-api-key = 'reqres-free-v1'
      When method post
      Then status 200
      * def id = response.id
      And print 'Id del usuario registrado:',id

      # usando el id obtenido para buscar el usuario
      Given path '/users/'+id
      When method get
      Then status 200
      And print 'usuario registrado:',response.data