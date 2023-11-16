//! The Azure Monitor Logs [`angle_lib::sink::AngleSink`]
//!
//! This module contains the [`angle_lib::sink::AngleSink`] instance that is responsible for
//! taking a stream of [`angle_lib::event::Event`] instances and forwarding them to the Azure
//! Monitor Logs service.

mod config;
mod service;
mod sink;
#[cfg(test)]
mod tests;

pub use config::AzureMonitorLogsConfig;
