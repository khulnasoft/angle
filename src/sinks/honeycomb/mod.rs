//! The Honeycomb [`angle_lib::sink::AngleSink`].
//!
//! This module contains the [`angle_lib::sink::AngleSink`] instance that is responsible for
//! taking a stream of [`angle_lib::event::Event`]s and forwarding them to the Honeycomb service.

mod config;
mod encoder;
mod request_builder;
mod service;
mod sink;

#[cfg(test)]
mod tests;
