**MaBOOK App**

Welcome on my first full-sized pet project! 
This one still in progress so some features may be unavailable.
So stay tuned!

**Technologies:**
- UIKit, Combine
- MVVM pattern
- NodeJS/Nest for BE

**List of implemented modules:**

Auth:
  - Login via email
  - Sign up via email
  - Full onboarding flow
    
Home:
  - Home feed with sections
  - Home search flow
  - Books list flow for categories/sections frome Home
  - Books list filters && sorting flow
  - Books list infinite scroll when paginating
  - Books details view for selected book
  - Add to cart/Whole cart flow
    
Profile [WIP]:
  - Main Profile view
  - Avatar section f-lity

Exchange Book - TBD

**HOW TO INSTALL:**
- use 'pod install' before launch

**Known Issues:**
- TextFields in auth flow are unstable: avoid double tapping on text - causes undefined retain cycle
- Empty sections state on Home page feed isn't implemented yet, so sections may be empty. Will be done sooner.
