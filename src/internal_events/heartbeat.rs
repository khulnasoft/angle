use std::time::Instant;

use metrics::gauge;
use angle_lib::internal_event::InternalEvent;

#[derive(Debug)]
pub struct Heartbeat {
    pub since: Instant,
}

impl InternalEvent for Heartbeat {
    fn emit(self) {
        trace!(target: "angle", message = "Beep.");
        gauge!("uptime_seconds", self.since.elapsed().as_secs() as f64);
    }
}
