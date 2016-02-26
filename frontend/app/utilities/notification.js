export function processNotifications(nextProps) {
  const currentNotify = this.props.notification || {};
  const nextNotify = nextProps.notification || {};

  if (currentNotify.date !== nextNotify.date) {
    this.refs.notificationSystem.addNotification({
      message: nextProps.notification.text,
      level: nextProps.notification.type,
    });
  }
}
