**MaBOOK App**

Welcome to my first full-sized pet project! 
This one is still in progress so some features may be unavailable.
So stay tuned!

**Technologies:**
- UIKit, Combine
- MVVM/POP/OOP patterns
- NodeJS/Nest for BE

**List of implemented modules:**

Auth:
  - Login via email
  - Sign up via email
  - Full onboarding flow
    
Home:
  - Home feed with sections
  - Books list flow for categories/sections from Home
  - Books list filters && sorting flow
  - Books list infinite scroll when paginating
  - Books details view for selected book
  - Add to cart/Whole cart flow
  - Book "in cart" UI logic handling

Search:
  - Base search f-lity
  - Recent searches list logic
  - Clear History of Recent searches
  - Redirection to Details page from search results
  - [TBD] See all books from search results
    
Profile [WIP]:
  - Main Profile view
  - Avatar section f-lity

Exchange Book - TBD

**HOW TO INSTALL:**
- use 'pod install' before launch

**Known Issues:**
- TextFields in auth flow are unstable: avoid double tapping on text - causes undefined retain cycle
- Empty sections state on the Home page feed isn't implemented yet so that sections may be empty. Will be done sooner.

**Different Codestyle**
Separate modules can be written with different approaches. 
It was expected - I'm trying different logic, patterns, approaches, data handling, etc.
I'm sorry for this mess. Will be cleaned ASAP :)
