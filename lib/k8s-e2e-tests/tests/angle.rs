use indoc::{formatdoc, indoc};
use k8s_e2e_tests::*;
use k8s_test_framework::{
    lock, namespace, test_pod, angle::Config as AngleConfig, wait_for_resource::WaitFor,
};

fn helm_values_stdout_sink(agent_override_name: &str) -> String {
    formatdoc!(
        r#"
    role: Agent
    fullnameOverride: "{}"
    env:
    - name: ANGLE_REQUIRE_HEALTHY
      value: true
    customConfig:
      data_dir: "/angle-data-dir"
      api:
        enabled: true
        address: 127.0.0.1:8686
      sources:
        kubernetes_logs:
          type: kubernetes_logs
      sinks:
        angle:
          type: angle
          inputs: [kubernetes_logs]
          address: aggregator-angle:6000
          version: "2"
    "#,
        agent_override_name,
    )
}

fn helm_values_haproxy(agent_override_name: &str) -> String {
    formatdoc!(
        r#"
    role: Agent
    fullnameOverride: "{}"
    env:
    - name: ANGLE_REQUIRE_HEALTHY
      value: true
    customConfig:
      data_dir: "/angle-data-dir"
      api:
        enabled: true
        address: 127.0.0.1:8686
      sources:
        kubernetes_logs:
          type: kubernetes_logs
      sinks:
        angle:
          type: angle
          inputs: [kubernetes_logs]
          address: aggregator-angle-haproxy:6000
          version: "2"
    "#,
        agent_override_name,
    )
}

/// This test validates that angle picks up logs with an agent and
/// delivers them to the aggregator out of the box.
#[tokio::test]
async fn logs() -> Result<(), Box<dyn std::error::Error>> {
    let _guard = lock();
    init();

    let namespace = get_namespace();
    let pod_namespace = get_namespace_appended(&namespace, "test-pod");
    let framework = make_framework();
    let agent_override_name = get_override_name(&namespace, "angle-agent");

    let angle_aggregator = framework
        .helm_chart(
            &namespace,
            "angle",
            "aggregator",
            "https://helm.angle.khulnasoft.com",
            AngleConfig {
                ..Default::default()
            },
        )
        .await?;

    framework
        .wait_for_rollout(
            &namespace,
            &format!("statefulset/aggregator-angle"),
            vec!["--timeout=60s"],
        )
        .await?;

    let angle_agent = framework
        .helm_chart(
            &namespace,
            "angle",
            "agent",
            "https://helm.angle.khulnasoft.com",
            AngleConfig {
                custom_helm_values: vec![&helm_values_stdout_sink(&agent_override_name)],
                ..Default::default()
            },
        )
        .await?;

    framework
        .wait_for_rollout(
            &namespace,
            &format!("daemonset/{}", agent_override_name),
            vec!["--timeout=60s"],
        )
        .await?;

    let test_namespace = framework
        .namespace(namespace::Config::from_namespace(
            &namespace::make_namespace(pod_namespace.clone(), None),
        )?)
        .await?;

    let test_pod = framework
        .test_pod(test_pod::Config::from_pod(&make_test_pod(
            &pod_namespace,
            "test-pod",
            "echo MARKER",
            vec![],
            vec![],
        ))?)
        .await?;

    framework
        .wait(
            &pod_namespace,
            vec!["pods/test-pod"],
            WaitFor::Condition("initialized"),
            vec!["--timeout=60s"],
        )
        .await?;

    let mut log_reader = framework.logs(&namespace, &format!("statefulset/aggregator-angle"))?;
    smoke_check_first_line(&mut log_reader).await;

    // Read the rest of the log lines.
    let mut got_marker = false;
    look_for_log_line(&mut log_reader, |val| {
        if val["kubernetes"]["pod_namespace"] != pod_namespace {
            // A log from something other than our test pod, pretend we don't
            // see it.
            return FlowControlCommand::GoOn;
        }

        // Ensure we got the marker.
        assert_eq!(val["message"], "MARKER");

        if got_marker {
            // We've already seen one marker! This is not good, we only emitted
            // one.
            panic!("Marker seen more than once");
        }

        // If we did, remember it.
        got_marker = true;

        // Request to stop the flow.
        FlowControlCommand::Terminate
    })
    .await?;

    assert!(got_marker);

    drop(test_pod);
    drop(test_namespace);
    drop(angle_agent);
    drop(angle_aggregator);
    Ok(())
}

/// This test validates that angle picks up logs with an agent and
/// delivers them to the aggregator through an HAProxy load balancer.
#[tokio::test]
async fn haproxy() -> Result<(), Box<dyn std::error::Error>> {
    let _guard = lock();
    init();

    let namespace = get_namespace();
    let pod_namespace = get_namespace_appended(&namespace, "test-pod");
    let framework = make_framework();
    let agent_override_name = get_override_name(&namespace, "angle-agent");

    const CONFIG: &str = indoc! {r#"
        haproxy:
          enabled: true
    "#};

    let angle_aggregator = framework
        .helm_chart(
            &namespace,
            "angle",
            "aggregator",
            "https://helm.angle.khulnasoft.com",
            AngleConfig {
                custom_helm_values: vec![CONFIG],
                ..Default::default()
            },
        )
        .await?;

    framework
        .wait_for_rollout(
            &namespace,
            &format!("statefulset/aggregator-angle"),
            vec!["--timeout=60s"],
        )
        .await?;

    framework
        .wait_for_rollout(
            &namespace,
            &format!("deployment/aggregator-angle-haproxy"),
            vec!["--timeout=60s"],
        )
        .await?;

    let angle_agent = framework
        .helm_chart(
            &namespace,
            "angle",
            "agent",
            "https://helm.angle.khulnasoft.com",
            AngleConfig {
                custom_helm_values: vec![&helm_values_haproxy(&agent_override_name)],
                ..Default::default()
            },
        )
        .await?;

    framework
        .wait_for_rollout(
            &namespace,
            &format!("daemonset/{}", agent_override_name),
            vec!["--timeout=60s"],
        )
        .await?;

    let test_namespace = framework
        .namespace(namespace::Config::from_namespace(
            &namespace::make_namespace(pod_namespace.clone(), None),
        )?)
        .await?;

    let test_pod = framework
        .test_pod(test_pod::Config::from_pod(&make_test_pod(
            &pod_namespace,
            "test-pod",
            "echo MARKER",
            vec![],
            vec![],
        ))?)
        .await?;

    framework
        .wait(
            &pod_namespace,
            vec!["pods/test-pod"],
            WaitFor::Condition("initialized"),
            vec!["--timeout=60s"],
        )
        .await?;

    let mut log_reader = framework.logs(&namespace, &format!("statefulset/aggregator-angle"))?;
    smoke_check_first_line(&mut log_reader).await;

    // Read the rest of the log lines.
    let mut got_marker = false;
    look_for_log_line(&mut log_reader, |val| {
        if val["kubernetes"]["pod_namespace"] != pod_namespace {
            // A log from something other than our test pod, pretend we don't
            // see it.
            return FlowControlCommand::GoOn;
        }

        // Ensure we got the marker.
        assert_eq!(val["message"], "MARKER");

        if got_marker {
            // We've already seen one marker! This is not good, we only emitted
            // one.
            panic!("Marker seen more than once");
        }

        // If we did, remember it.
        got_marker = true;

        // Request to stop the flow.
        FlowControlCommand::Terminate
    })
    .await?;

    assert!(got_marker);

    drop(test_pod);
    drop(test_namespace);
    drop(angle_agent);
    drop(angle_aggregator);
    Ok(())
}
