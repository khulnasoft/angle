use metrics::counter;
use metrics::gauge;
use angle_lib::internal_event::InternalEvent;
use angle_lib::internal_event::{error_stage, error_type};

use crate::{built_info, config};

#[derive(Debug)]
pub struct AngleStarted;

impl InternalEvent for AngleStarted {
    fn emit(self) {
        info!(
            target: "angle",
            message = "Angle has started.",
            debug = built_info::DEBUG,
            version = built_info::PKG_VERSION,
            arch = built_info::TARGET_ARCH,
            revision = built_info::ANGLE_BUILD_DESC.unwrap_or(""),
        );
        gauge!(
            "build_info",
            1.0,
            "debug" => built_info::DEBUG,
            "version" => built_info::PKG_VERSION,
            "rust_version" => built_info::RUST_VERSION,
            "arch" => built_info::TARGET_ARCH,
            "revision" => built_info::ANGLE_BUILD_DESC.unwrap_or("")
        );
        counter!("started_total", 1);
    }
}

#[derive(Debug)]
pub struct AngleReloaded<'a> {
    pub config_paths: &'a [config::ConfigPath],
}

impl InternalEvent for AngleReloaded<'_> {
    fn emit(self) {
        info!(
            target: "angle",
            message = "Angle has reloaded.",
            path = ?self.config_paths
        );
        counter!("reloaded_total", 1);
    }
}

#[derive(Debug)]
pub struct AngleStopped;

impl InternalEvent for AngleStopped {
    fn emit(self) {
        info!(
            target: "angle",
            message = "Angle has stopped."
        );
        counter!("stopped_total", 1);
    }
}

#[derive(Debug)]
pub struct AngleQuit;

impl InternalEvent for AngleQuit {
    fn emit(self) {
        info!(
            target: "angle",
            message = "Angle has quit."
        );
        counter!("quit_total", 1);
    }
}

#[derive(Debug)]
pub struct AngleReloadError;

impl InternalEvent for AngleReloadError {
    fn emit(self) {
        error!(
            message = "Reload was not successful.",
            error_code = "reload",
            error_type = error_type::CONFIGURATION_FAILED,
            stage = error_stage::PROCESSING,
            internal_log_rate_limit = true,
        );
        counter!(
            "component_errors_total", 1,
            "error_code" => "reload",
            "error_type" => error_type::CONFIGURATION_FAILED,
            "stage" => error_stage::PROCESSING,
        );
    }
}

#[derive(Debug)]
pub struct AngleConfigLoadError;

impl InternalEvent for AngleConfigLoadError {
    fn emit(self) {
        error!(
            message = "Failed to load config files, reload aborted.",
            error_code = "config_load",
            error_type = error_type::CONFIGURATION_FAILED,
            stage = error_stage::PROCESSING,
            internal_log_rate_limit = true,
        );
        counter!(
            "component_errors_total", 1,
            "error_code" => "config_load",
            "error_type" => error_type::CONFIGURATION_FAILED,
            "stage" => error_stage::PROCESSING,
        );
    }
}

#[derive(Debug)]
pub struct AngleRecoveryError;

impl InternalEvent for AngleRecoveryError {
    fn emit(self) {
        error!(
            message = "Angle has failed to recover from a failed reload.",
            error_code = "recovery",
            error_type = error_type::CONFIGURATION_FAILED,
            stage = error_stage::PROCESSING,
            internal_log_rate_limit = true,
        );
        counter!(
            "component_errors_total", 1,
            "error_code" => "recovery",
            "error_type" => error_type::CONFIGURATION_FAILED,
            "stage" => error_stage::PROCESSING,
        );
    }
}
