# AMExercise

Changes I have made: 

- Replaced storyboard cell and collection view with programmatic, to improve reusability
- Add request cancelling in case we scroll very fast and cell get reused before we downloaded an image
- Add cache to save already downloaded image, to avoid unnecessary network request
- Used smaller size images for cells, to lower network load
- Created detail view with custom presentation from bottom (tap cell to see, swipe down or tap outside to dismiss)
- Added pagination to collectionView layout
- Fix code according to code style

Points of improvement: 
- CollectionView performance still can be improved, since target for the project was set to 12.0 I assumed that is one of the project requirements, otherwise I would use DiffableDataSource to avoid constant reloading of the whole table
- Some more advanced architecture solutions, like MVVM or MVP
- To achive desired layout I had to use .scaleToFill for the images, but some of them do not look good scaled.
- I could round the imageView cornes, but It might be affecting performance, so I decided to just pass the rounded image to the cell imageView

<img width="351" alt="image" src="https://user-images.githubusercontent.com/25434871/196060808-8ae7c693-b0dd-4949-ba1f-892234c4d5b0.png">
<img width="354" alt="image" src="https://user-images.githubusercontent.com/25434871/196060846-6f793416-bd90-464d-9972-611341c4af35.png">

