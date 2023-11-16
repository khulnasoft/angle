#![allow(clippy::clone_on_ref_ptr)]
#![allow(warnings, clippy::pedantic, clippy::nursery)]

tonic::include_proto!("angle");

pub use angle_client::AngleClient as Client;
pub use angle_server::{Angle as Service, AngleServer as Server};
