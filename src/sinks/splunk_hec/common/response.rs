use angle_lib::event::EventStatus;
use angle_lib::request_metadata::GroupedCountByteSize;
use angle_lib::stream::DriverResponse;

pub struct HecResponse {
    pub event_status: EventStatus,
    pub events_count: usize,
    pub events_byte_size: GroupedCountByteSize,
}

impl AsRef<EventStatus> for HecResponse {
    fn as_ref(&self) -> &EventStatus {
        &self.event_status
    }
}

impl DriverResponse for HecResponse {
    fn event_status(&self) -> EventStatus {
        self.event_status
    }

    fn events_sent(&self) -> &GroupedCountByteSize {
        &self.events_byte_size
    }
}
