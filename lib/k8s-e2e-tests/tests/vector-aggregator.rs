use k8s_e2e_tests::*;
use k8s_test_framework::{lock, angle::Config as AngleConfig};

/// This test validates that angle can deploy with the default
/// aggregator settings.
#[tokio::test]
async fn dummy_topology() -> Result<(), Box<dyn std::error::Error>> {
    init();

    let _guard = lock();
    let namespace = get_namespace();
    let framework = make_framework();
    let override_name = get_override_name(&namespace, "angle-aggregator");

    let angle = framework
        .helm_chart(
            &namespace,
            "angle",
            "angle",
            "https://helm.angle.khulnasoft.com",
            AngleConfig {
                custom_helm_values: vec![&config_override_name(&override_name, false)],
                ..Default::default()
            },
        )
        .await?;
    framework
        .wait_for_rollout(
            &namespace,
            &format!("statefulset/{}", override_name),
            vec!["--timeout=60s"],
        )
        .await?;

    drop(angle);
    Ok(())
}

/// This test validates that angle-aggregator chart properly exposes metrics in
/// a Prometheus scraping format ot of the box.
#[tokio::test]
async fn metrics_pipeline() -> Result<(), Box<dyn std::error::Error>> {
    init();

    let _guard = lock();
    let namespace = get_namespace();
    let framework = make_framework();
    let override_name = get_override_name(&namespace, "angle-aggregator");

    let angle = framework
        .helm_chart(
            &namespace,
            "angle",
            "angle",
            "https://helm.angle.khulnasoft.com",
            AngleConfig {
                custom_helm_values: vec![&config_override_name(&override_name, false)],
                ..Default::default()
            },
        )
        .await?;
    framework
        .wait_for_rollout(
            &namespace,
            &format!("statefulset/{}", override_name),
            vec!["--timeout=60s"],
        )
        .await?;

    let mut angle_metrics_port_forward = framework.port_forward(
        &namespace,
        &format!("statefulset/{}", override_name),
        9090,
        9090,
    )?;
    angle_metrics_port_forward.wait_until_ready().await?;
    let angle_metrics_url = format!(
        "http://{}/metrics",
        angle_metrics_port_forward.local_addr_ipv4()
    );

    // Wait until `angle_started`-ish metric is present.
    metrics::wait_for_angle_started(
        &angle_metrics_url,
        std::time::Duration::from_secs(5),
        std::time::Instant::now() + std::time::Duration::from_secs(60),
    )
    .await?;

    drop(angle_metrics_port_forward);
    drop(angle);
    Ok(())
}
