
import UIKit
import RealmSwift

class CalendarViewController: UIViewController, UITableViewDelegate {
    // MARK: - Properties
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var daysOutSwitch: UISwitch!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var shouldShowDaysOut = true
    var animationFinished = true
    
    var isCalendarShown = true
    
    // constrains for animations
    @IBOutlet weak var weekViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var weekViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var monthViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var monthViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var monthViewHeightConstraint: NSLayoutConstraint!
    
    
    // model
    // each day is a section
    struct DayInMonth {
        var date: CVDate
        var activities = [Activity]()
        
        init(date:NSDate) {
            self.date = CVDate(date: date)
        }
        
        var formattedDate: String {
            let day = cvDayToDay[date.weekday]!
            return "\(day.description.capitalized) \(ordinalNumberFormat(date.day))"
        }
        
        // TODO: Would maths be better here?
        private var cvDayToDay = [
            1: Day.sunday,
            2: Day.monday,
            3: Day.tuesday,
            4: Day.wednesday,
            5: Day.thursday,
            6: Day.friday,
            7: Day.saturday,
        ]
    }
    var currentDate = CVDate(date: NSDate())
    var daysForMonth = [DayInMonth]()
    
    // interface to Realm
    var notificationToken: NotificationToken?
    let meetingActivities = Realm().objects(MeetingActivity.self)
    let communityActivities = Realm().objects(CommunityActivity.self)
    
    func populateMonth() {
        daysForMonth.removeAll(keepCapacity: true)

        // TODO: not sure if this is the most effective way of doing this
        let meetings = Array(meetingActivities.generate())
        let community = Array(communityActivities.generate())
        
        let dates = calendarView.manager.datesInMonth(currentDate.date)
        for date in dates {
            var day = DayInMonth(date: date)
            day.activities += meetings.mapFilter {
                $0.includeOnDate(date) ? $0 : nil as Activity?
            }
            day.activities += community.mapFilter {
                $0.includeOnDate(date) ? $0 : nil as Activity?
            }
            daysForMonth.append(day)
        }
    }
    
    func activityForIndexPath(indexPath: NSIndexPath) -> Activity {
        return daysForMonth[indexPath.section].activities[indexPath.row]
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        self.navigationItem.title = CVDate(date: NSDate()).globalDescription
        
        notificationToken = Realm().addNotificationBlock { [unowned self] note, realm in
            self.refresh()
        }
        
        //calendarView.hidden = true
        //hideCalendar()
    }
    
    var toggling = false // This is a bit of hack - make calendar hidden
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /*
        if !toggling {
            if isCalendarShown {
                showCalendar()
            } else {
                hideCalendar()
            }
        }*/
        refresh()
    }
    
    func refresh() {
        populateMonth()
        tableView.reloadData()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
        
        calendarView.changeDaysOutShowingState(true)
        shouldShowDaysOut = false
        
        scrollToDate(currentDate)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMeetingDetails" {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            let activity = activityForIndexPath(indexPath)
            let dest = segue.destinationViewController as! ActivityDetailsViewController
            dest.activity = activity
        }
    }
}

// MARK: - CVCalendarViewDelegate

extension CalendarViewController: CVCalendarViewDelegate
{
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView
    {
        let π = M_PI
        
        let ringSpacing: CGFloat = 3.0
        let ringInsetWidth: CGFloat = 1.0
        let ringVerticalOffset: CGFloat = 1.0
        var ringLayer: CAShapeLayer!
        let ringLineWidth: CGFloat = 4.0
        let ringLineColour: UIColor = .blueColor()
        
        var newView = UIView(frame: dayView.bounds)
        
        let diameter: CGFloat = (newView.bounds.width) - ringSpacing
        let radius: CGFloat = diameter / 2.0
        
        let rect = CGRectMake(newView.frame.midX-radius, newView.frame.midY-radius-ringVerticalOffset, diameter, diameter)
        
        ringLayer = CAShapeLayer()
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.CGColor
        
        var ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
        let ringRect: CGRect = CGRectInset(rect, ringLineWidthInset, ringLineWidthInset)
        let centrePoint: CGPoint = CGPointMake(ringRect.midX, ringRect.midY)
        let startAngle: CGFloat = CGFloat(-π/2.0)
        let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
        let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        ringLayer.path = ringPath.CGPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool
    {
        return false
    }
}


extension CalendarViewController: CVCalendarViewDelegate {
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    func didSelectDayView(dayView: CVCalendarDayView) {
        currentDate = dayView.date
        println("\(calendarView.presentedDate.commonDescription) is selected!")
        refresh()
        scrollToDate(currentDate)
    }
    
    func scrollToDate(date: CVDate) {
        // the day of the month is the section
        let section = date.day - 1 // sections are zero indexed, the days of the month are not.
        var sectionRect = tableView.rectForSection(section)
        sectionRect.size.height = tableView.frame.size.height;
        UIView.animateWithDuration(0.5) {
            self.tableView.scrollRectToVisible(sectionRect, animated:true)
        }
    }
    
    func presentedDateUpdated(date: CVDate) {
        if self.navigationItem.title != date.globalDescription && self.animationFinished {
            self.navigationItem.title = date.globalDescription
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        // TODO: this condition is only needed because of the setup order of things.
        // Perhaps it can be removed.
        /*
        if daysForMonth.count > 0 && currentDate.month == dayView.date.month {
            let idx = dayView.date.day - 1
            let day = daysForMonth[idx]
            return day.activities.count > 0
        } else {
            return false
        }
        */
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> UIColor {
        return aceColors[AceColor.Green]!
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
}

// MARK: - CVCalendarViewAppearanceDelegate

extension CalendarViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}

// MARK: - CVCalendarMenuViewDelegate

extension CalendarViewController: CVCalendarMenuViewDelegate {
    // firstWeekday() has been already implemented.
}

// MARK: - IB Actions



extension CalendarViewController {
    @IBAction func close(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func switchChanged(sender: UISwitch) {
        if sender.on {
            calendarView.changeDaysOutShowingState(false)
            shouldShowDaysOut = true
        } else {
            calendarView.changeDaysOutShowingState(true)
            shouldShowDaysOut = false
        }
    }
    
    @IBAction func todayMonthView() {
        calendarView.toggleCurrentDayView()
    }
    
    /// Switch to MonthView mode.
    /*
    @IBAction func toggleCalendarView(sender: AnyObject) {
        /*
        if calendarView.calendarMode == CalendarMode.WeekView {
            calendarView.changeMode(.MonthView)
        } else {
            calendarView.changeMode(.WeekView)
        }
        */
        
    }
    */
    
    @IBAction func toggleCalendarShown(sender: UIBarButtonItem) {
        //toggling = true
        if isCalendarShown {
            hideCalendar()
            sender.title = "Show"
        } else {
            showCalendar()
            sender.title = "Hide"
        }
        isCalendarShown = !isCalendarShown
        //toggling = false
    }
    
    func hideCalendar() {
        
        calendarView.contentController.updateHeight(0.0, animated: true)
        
        
        self.view.layoutIfNeeded()
        weekViewHeightConstraint.constant = 0
        weekViewTopConstraint.constant = 0
        monthViewTopConstraint.constant = 0
        monthViewBottomConstraint.constant = 0
        UIView.animateWithDuration(0.2) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func showCalendar() {
        
        calendarView.contentController.updateHeight(calendarView.contentController.presentedMonthView.potentialSize.height, animated: true)
        
        
        self.view.layoutIfNeeded()
        weekViewHeightConstraint.constant = 24
        weekViewTopConstraint.constant = 7
        monthViewTopConstraint.constant = 7
        monthViewBottomConstraint.constant = 7
        UIView.animateWithDuration(0.2) {
            self.view.layoutIfNeeded()
        }
        

    }

    @IBAction func loadPrevious(sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    
    @IBAction func loadNext(sender: AnyObject) {
        calendarView.loadNextView()
    }
}

// MARK: - Convenience API Demo

extension CalendarViewController {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        let calendar = NSCalendar.currentCalendar()
        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
}

// MARK: - UITableViewDataSource

extension CalendarViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return daysForMonth.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysForMonth[section].activities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("calendarReuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        let activity = activityForIndexPath(indexPath)
        cell.textLabel?.text = activity.name
        
        // set up the shading
        if activity.attending {
           let color = cell.textLabel?.textColor.colorWithAlphaComponent(1.0)
           cell.textLabel?.textColor = color
        } else {
            let color = cell.textLabel?.textColor.colorWithAlphaComponent(0.5)
            cell.textLabel?.textColor = color
        }
        
        return cell
    }
}

extension CalendarViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return daysForMonth[section].formattedDate
    }
}



















