Feature: sample karate test script
  for help, see: https://github.com/karatelabs/karate/wiki/IDE-Support

  Background:
    * url 'https://jsonplaceholder.typicode.com'

  Scenario: Obtener todos los usuarios y tomar el primero
    Given path 'users'
    When method get
    Then status 200

    * def first = response[0]

    Given path 'users', first.id
    When method get
    Then status 200:

  Scenario: Crear un usuario
    * def user =
      """
      {
        "name": "Test User",
        "username": "testuser",
        "email": "test@user.com",
        "address": {
          "street": "Has No Name",
          "suite": "Apt. 123",
          "city": "Electri",
          "zipcode": "54321-6789"
        }
      }
      """

    Given path 'https://jsonplaceholder.typicode.com/users'
    And request user
    When method post
    Then status 201
    * def nameExpected = user.name
    * def emailExpected = user.email

    And match response.name == nameExpected
    And match response.email == emailExpected

  Scenario: Obtener un usuario por Id
    * def responseExpected =
    """
      {
        "id": 8,
        "name": "Nicholas Runolfsdottir V",
        "username": "Maxime_Nienow",
        "email": "Sherwood@rosamond.me",
        "address": {
          "street": "Ellsworth Summit",
          "suite": "Suite 729",
          "city": "Aliyaview",
          "zipcode": "45169",
          "geo": {
            "lat": "-14.3990",
            "lng": "-120.7677"
          }
        },
        "phone": "586.493.6943 x140",
        "website": "jacynthe.com",
        "company": {
          "name": "Abernathy Group",
          "catchPhrase": "Implemented secondary concept",
          "bs": "e-enable extensible e-tailers"
        }
      }
    """
    Given path 'users/8'
    When method get
    Then status 200
    And match response == responseExpected

    Scenario: Obtener todos los usuarios
      Given path '/users'
      When method get
      Then status 200
      * def len = response.length
      And assert len > 0

  Scenario: Actualizar un usuario con put
    * def userUpdate =
      """
      {
        "id": 8,
        "name": "Kevin Gomez",
        "username": "Maxime_Nienow",
        "email": "kgomez@rosamond.me",
        "address": {
          "street": "Ellsworth Summit",
          "suite": "Suite 729",
          "city": "Aliyaview",
          "zipcode": "45169",
          "geo": {
            "lat": "-14.3990",
            "lng": "-120.7677"
          }
        },
        "phone": "586.493.6943 x140",
        "website": "jacynthe.com",
        "company": {
          "name": "Abernathy Group",
          "catchPhrase": "Implemented secondary concept",
          "bs": "e-enable extensible e-tailers"
        }
      }
      """
    Given path '/users/8'
    When method put
    Then status 200

  Scenario: Actualizar un usuario con patch
    * def update =
      """
        {
          "username":"GomezRkevinM"
        }
      """

    Given path '/users/8'
    When method patch
    Then status 200
    And path '/users/8'
    When method get
    Then status 200

  Scenario: Eliminar un usuario
    Given path '/users/10'
    When method delete
    Then status 200