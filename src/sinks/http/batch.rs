//! Batch settings for the `http` sink.

use angle_lib::codecs::encoding::Framer;
use angle_lib::stream::batcher::limiter::ItemBatchSize;
use angle_lib::{event::Event, ByteSizeOf, EstimatedJsonEncodedSizeOf};

use crate::codecs::Encoder;

/// Uses the configured encoder to determine batch sizing.
#[derive(Default)]
pub(super) struct HttpBatchSizer {
    pub(super) encoder: Encoder<Framer>,
}

impl ItemBatchSize<Event> for HttpBatchSizer {
    fn size(&self, item: &Event) -> usize {
        match self.encoder.serializer() {
            angle_lib::codecs::encoding::Serializer::Json(_)
            | angle_lib::codecs::encoding::Serializer::NativeJson(_) => {
                item.estimated_json_encoded_size_of().get()
            }
            _ => item.size_of(),
        }
    }
}
