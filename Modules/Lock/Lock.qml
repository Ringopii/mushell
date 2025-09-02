pragma ComponentBehavior: Bound

import qs.Data
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope {
	property alias lock: lock

	WlSessionLock {
		id: lock

		signal unlock

		LockSurface {
			id: surface

			lock: lock
			pam: pamInstance
		}
	}

	Pam {
		id: pamInstance

		lock: lock
	}

	IpcHandler {
		target: "lock"

		function lock(): void {
			lock.locked = true;
		}

		function unlock(): void {
			lock.unlock();
		}

		function isLocked(): bool {
			return lock.locked;
		}
	}
}
