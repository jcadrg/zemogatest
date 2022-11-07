# zemogatest
iOS technical interview test

This repo is a test for a coding interview

#How to use
To mark as favorite, swipe cell to the left, there you should see a "Favorite" option, tap and you've Faved a cell! There will be a star on the cell if the element is faved and be automatically placed on the top of the tableview. To Unfavorite, swipe left to reveal "Unfavorite", the star option should disappear and the cell will be placed below all faved content.
To delete a cell, swipe left the cell to delete or tap on the "Delete" option.
To delete all posts, tap the "Delete all unfav", all options not starred should be deleted
To call the api and populate all cells with the response from tha API, do a pull to refresh the tableview, an indicator with the text "Getting all posts" should appear.
Tap on the cell to be taken to the screen showing some data on the post's author, the comments and the title/description of the post.


The Architecture selected is MVC, with all the models placed in the MODELS, group, the view controllers are on the same place.
