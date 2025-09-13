pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root
	property real memTotal
	property real memUsed
	property real diskUsed
	property real diskTotal
	property real cpuPerc: 0
	property real lastCpuIdle: 0
	property real lastCpuTotal: 0
	property bool initialized: false

	FileView {
		id: meminfo

		path: "/proc/meminfo"
		onLoaded: {
			const data = text();
			const memTotalMatch = data.match(/MemTotal:\s+(\d+)/);
			const memAvailableMatch = data.match(/MemAvailable:\s+(\d+)/);
			if (memTotalMatch && memAvailableMatch) {
				root.memTotal = parseInt(memTotalMatch[1], 10);
				root.memUsed = root.memTotal - parseInt(memAvailableMatch[1], 10);
			}
		}
	}

	// Thx caelestia
	Process {
		id: diskinfo

		command: ["sh", "-c", "df | grep '^/dev/' | awk '{print $1, $3, $4}'"]
		stdout: StdioCollector {
			onStreamFinished: {
				const deviceMap = new Map();

				for (const line of text.trim().split("\n")) {
					if (line.trim() === "")
						continue;

					const parts = line.trim().split(/\s+/);
					if (parts.length >= 3) {
						const device = parts[0];
						const used = parseInt(parts[1], 10) || 0;
						const avail = parseInt(parts[2], 10) || 0;

						// Only keep the entry with the largest total space for each device
						if (!deviceMap.has(device) || (used + avail) > (deviceMap.get(device).used + deviceMap.get(device).avail)) {
							deviceMap.set(device, {
								used: used,
								avail: avail
							});
						}
					}
				}

				let totalUsed = 0;
				let totalAvail = 0;

				for (const [device, stats] of deviceMap) {
					totalUsed += stats.used;
					totalAvail += stats.avail;
				}

				root.diskUsed = totalUsed;
				root.diskTotal = totalUsed + totalAvail;
			}
		}
	}

	FileView {
		id: stat

		path: "/proc/stat"
		onLoaded: {
			const data = text();
			const match = data.match(/^cpu\s+(\d+)(?:\s+(\d+))?(?:\s+(\d+))?(?:\s+(\d+))?(?:\s+(\d+))?(?:\s+(\d+))?(?:\s+(\d+))?(?:\s+(\d+))?(?:\s+(\d+))?(?:\s+(\d+))?/m);

			if (match) {
				const stats = match.slice(1).filter(val => val !== undefined).map(n => parseInt(n, 10));

				if (stats.length >= 4) {
					const total = stats.reduce((a, b) => a + b, 0);
					const idle = stats[3] + (stats[4] || 0);

					if (!root.initialized) {
						root.lastCpuTotal = total;
						root.lastCpuIdle = idle;
						root.initialized = true;
					} else {
						const totalDiff = total - root.lastCpuTotal;
						const idleDiff = idle - root.lastCpuIdle;

						if (totalDiff > 0) {
							const cpuUsage = Math.max(0, Math.min(1, (totalDiff - idleDiff) / totalDiff));
							root.cpuPerc = Math.round(cpuUsage * 100);
						}

						root.lastCpuTotal = total;
						root.lastCpuIdle = idle;
					}
				}
			}
		}
	}

	Timer {
		running: true
		interval: 1000
		repeat: true
		triggeredOnStart: true
		onTriggered: {
			stat.reload();
			meminfo.reload();
			diskinfo.running = true;
		}
	}
}
