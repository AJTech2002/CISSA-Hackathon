# App Built for the CISSA Hackathon 2021

## Project Description

Health Comply is an app that allows you to rate a location based on how COVID safe it is for you, your friends and your family to spend time at this place. Unlike other rating apps, Health Comply has a strict focus on public health, allowing you to rate locations based on three criteria: cleanliness, social distancing and staff COVID compliance. 

You can also look at existing ratings from other users, scouting out your next lunch destination using our search algorithm that recommends locations based on their rating and their distance to you. Found a unique location that no one else talks about? Be the first to let everyone know how safe it is by creating a brand new destination near you. Health Comply does the hard work for you, so that you can feel a little safer in your next going out.

## Core Technologies

- GPS Technology to find location and compare distances
- Geocoding to find address given cartographic coordinates
- Firebase for Database
- GitHub for Version Control
- Flutter for UI/UX
- Mapbox for Map Display

## File Overview

The core files are located within the `./lib` folder. 

- `base.dart`: Contains our core classes that were used as a foundation through the different systems to integrate the flow of data through the application, the database is also modelled off this data.
- `gpsCalculator.dart`: Contains functions that identify the position of the user, do reverse geocoding on the lat/lon to return address strings.
-  `search.dart`: Contains the core logic for the search function that develops a score taking into account distance, social distancing, cleanliness, staff compliance etc. and returns sorted information.
-  `firebase.dart`: Contains all the logic for saving/retrieving information from firebase in an organized manner.
-  `main.dart`: Contains all the UI Logic and utilises the previously mentioned files to integrate all the logic into one cohesive experience.


## Git Workflow

The workflow was split evenly between members of the group with 4 branches of development:

- Database
- Search
- GPS
- UI

Each of the branches used the `base.dart` to model their functions, this splitting of work onto seperate branches ensured there were no dependencies in development also allowing for maximum extensibility in future.

Everytime a major function was completed for example the `getUserPosition()` in the `gpsCalculator.dart` a Pull Request was submitted which was reviewed by all members of the team then submitted into the main branch. The main branch was constantly tested manually to ensure previous features and new features worked properly.
