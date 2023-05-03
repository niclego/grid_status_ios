import Core
import GridStatusCommonUI

extension ISOViewItem {
    init(iso: ISO) {
        self.init(
            name: iso.iso,
            primarySource: iso.latestPrimaryPowerSource,
            load: iso.latestLoad,
            price: iso.latestLmp,
            updatedTimes: (lmpTimeUtc: iso.lmpTimeUtc, loadTimeUtc: iso.loadTimeUtc, primaryPowerSourceTimeUtc: iso.primaryPowerSourceTimeUtc)
        )
    }
}
