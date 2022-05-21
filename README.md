# FruitDiary

The existing entries should be presented through a list of some sort and a specific entry should
be viewable through a detail view. Each row in the entries list should present the date of the
entry, the number of fruits and the total number of vitamins in the eaten fruits that date.


About APP
 ------------------------
 1. Force protrait orientation
 2. Show weekly calendar
 3. Show half screen popup when add/update eaten fruit amout
 4. Request EntryList API when add/update eaten fruit amout
 5. Request FruitList API just when app loaded
 6. App has no locally store.
 
 
### >Model
    WeekDaysModel.swift : weekly calendar
    FruitModel.swift : Fruit list resqest/response/mapView
    EntryModel.swift : Entry list request/Response/MapView
### >View
    ### >>FruitDiary<br />
        >>>DashboardView.swift : Landing Page / call DailyFruitView.swift<br />
        >>>DailyFruitView.swift : Add new entry button / add new eaten fruit amount / call FruitEatenListView.swift<br />
        >>>FruitEatenFormView.swift : Half view for eaten fruit form<br />
        >>>AboutView.swift : App information<br />
        >>>FruitEatenListView.swift : Daily fruit list<br />
    #### >> ShareView<br />
        >>>ButtonWithText.swift : Text button<br />
        >>>HalfSheetView.swift : Half sheet view<br />
        >>>TabSlideBarView.swift : sliderbar menu button<br />
        >>>IconButton.swift : Icon button<br />
    #### >> WeeklyCalendar<br />
        >>>WeeklyCalendaerHeaderView.swift : Previous and next icon<br />
        >>>WeeklyCalendarView.swift : Weekly calendar<br />
    >>ContentView.swift : call DashboardView.swift<br />
### >ViewModel
    >>WeekCalendarViewModel.swift : View model for calendar<br />
    >>DailyFruitViewModel.swift : View model for API and all process<br />
### >Utility
    #### >>Storage<br />
        >>>UserDefaultManager.swift : For locally storeage<br />
        >>>StorageKey.swift : locally storeage keys<br />
    #### >>APIs<br />
        >>>AlmofireManager.swift : AlmofireConfig<br />
        >>>ServiceAPI.swift : API GET/POST/DELETE<br />
        >>>URLUtility.swift : All URLs for the project<br />
        >>>ErrorStruct.swift : Error<br />
        >>>JsonService.swift : Decode and Encode Structure <-> Json data (For locally storeage)<br />
    #### >>Modifier<br />
        >>>Modifier.swift : Style for UI<br />
    #### >>Extension<br />
        >>>Date+Extension.swift<br />
    >>Constant : Constant Values for the project<br />
    >>Device : Check Device<br />

## Screenshots
<kbd>
  <img src="https://raw.githubusercontent.com/waleerat/GitHub-Photos-Shared/main/WeeklyCalendar/05.png" width="40%" height="40%"> 

|
<img src="https://raw.githubusercontent.com/waleerat/GitHub-Photos-Shared/main/WeeklyCalendar/02.png"  width="40%" height="40%"> |
<img src="https://raw.githubusercontent.com/waleerat/GitHub-Photos-Shared/main/WeeklyCalendar/01.png"  width="40%" height="40%"> 


<img src="https://raw.githubusercontent.com/waleerat/GitHub-Photos-Shared/main/WeeklyCalendar/03.png" width="40%" height="40%"> |
<img src="https://raw.githubusercontent.com/waleerat/GitHub-Photos-Shared/main/WeeklyCalendar/04.png"  width="40%" height="40%"> 
  </kbd>


 
