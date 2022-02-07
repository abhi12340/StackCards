# StackCards
To give collection view power for stacking your UICollectionViewCell  as card.
# Demo videos

# First demo
https://user-images.githubusercontent.com/29311597/152820403-0d401849-fa55-4c50-8102-ce3a8195441f.mp4

# Second demo
https://user-images.githubusercontent.com/29311597/152820466-80af860d-de56-487a-a823-8fe4cf8854ce.mp4

# Using UICollectionViewLayout and UICollectionViewLayoutAttributes. 
  
  created StackCards as a SDK using the power of customization
  of UICollectionViewLayout to customize the layout of the collection view
  we can achive the stackedcard and by generating the frame and caching 
  it UICollectionViewLayoutAttributes speeds up the process.
  using to handle the position of the cell collapse and Expanded.
  
# Use this as famous cocoa pods
  latested available version 1.0.0
  ## Installation process is pretty simple using cocoapods
     1. pod init on your project directory
     2. open podfile
     3. add pod 'StackCards', '1.0.0' in your podfile
     4. pod install
     5. open xcworkspace.
  ## we are ready to use the StackCards.
  ## SDK supports iOS 13 and above.
  ## language support Swift
  
  ## There are few Delegate and Datasource need to be conform 
  ## before getting started and Stack your views 😀
     Delegate to get hooks to interaction over cells
    @objc public protocol StackCardsManagerDelegate {
        @objc optional func stack(tappded cell: UICollectionViewCell?,
                                  for indexPath: IndexPath?,
                                  state: CardsPosition)
    }

    Datasource to get hooks to recive the data from the UI
    @objc public protocol StackCardManagerDataSource: AnyObject {
        func stack(_ cardsCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        func stack(_ cardsCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        @objc optional func numberOfSectionsStackCard(in collectionView: UICollectionView) -> Int
    }
    
  ## Please make sure to Extend the StackCardCell protocol while creating your UICollectionviewCell 
  ## to provide your cells power of expand and collapse.
  ## with power here come some responsiblity need to set the value of the variables 😜
     pass your collection view instance to the StackCard and see the magic.
     var indexPath: IndexPath? { get set }
     var cellState: CardsPosition { get set }
     
  ## please find the Example Application in the repository.
      
     Thats it your collection view has power now enjoy 🎉🎉🎉🎉🎉
     
  ## please provide the feedback so that I can improve.
  
  # Thanks

