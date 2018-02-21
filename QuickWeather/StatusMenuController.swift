import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var weatherView: WeatherView!
    var weatherMenuItem: NSMenuItem!

    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let weatherAPI = WeatherAPI()
    
    override func awakeFromNib() {
        statusItem.menu = statusMenu
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        
        weatherMenuItem = statusMenu.item(withTitle: "Weather")
        weatherMenuItem.view = weatherView
        
        updateWeather()
    }
    
    func updateWeather() {
        weatherAPI.fetchWeather("Denver") { weather in
            self.weatherView.update(weather)
        }
    }
    
    @IBAction func updateClicked(_ sender: NSMenuItem) {
        updateWeather()
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
