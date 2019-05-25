
import UIKit

class WidgetCell: UITableViewCell {
  
  private var showsMore = false
  @IBOutlet weak var widgetHeight: NSLayoutConstraint!

  weak var tableView: UITableView?
  var toggleHeightAnimator: UIViewPropertyAnimator?
  
  @IBOutlet weak var widgetView: WidgetView!
  
  var owner: WidgetsOwnerProtocol? {
    didSet {
      if let owner = owner {
        widgetView.owner = owner
      }
    }
  }
  
  @IBAction func toggleShowMore(_ sender: UIButton) {

    self.showsMore = !self.showsMore

    let animations = {
      self.widgetHeight.constant = self.showsMore ? 230 : 130
      if let tableView = self.tableView {
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.layoutIfNeeded()
      }
    }

    let textTransition = {
      UIView.transition(with: sender, duration: 0.25, options: .transitionCrossDissolve,
        animations: {
          sender.setTitle(self.showsMore ? "Show Less" : "Show More", for: .normal)
        },
        completion: nil
      )
    }

    if let toggleHeightAnimator = toggleHeightAnimator, toggleHeightAnimator.isRunning {
      toggleHeightAnimator.addAnimations(animations)
      toggleHeightAnimator.addAnimations(textTransition, delayFactor: 0.5)
    } else {
      let spring = UISpringTimingParameters(mass: 30, stiffness: 1000, damping: 300, initialVelocity: CGVector.zero)
      toggleHeightAnimator = UIViewPropertyAnimator(duration: 0.0, timingParameters: spring)
      toggleHeightAnimator?.addAnimations(animations)
      toggleHeightAnimator?.addAnimations(textTransition, delayFactor: 0.5)
      toggleHeightAnimator?.startAnimation()
    }

    widgetView.expanded = showsMore
    widgetView.reload()
  }

}
