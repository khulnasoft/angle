###################
# ANGLE TILTFILE #
###################

load('ext://helm_resource', 'helm_resource', 'helm_repo')

docker_build(
    ref='timberio/angle',
    context='.',
    build_args={'RUST_VERSION': '1.72.1'},
    dockerfile='tilt/Dockerfile'
    )

helm_repo(name='angledotdev', url='https://helm.khulnasoft.com')
helm_resource(
    name='angle',
    chart='angledotdev/angle',
    image_deps=['timberio/angle'],
    image_keys=[('image.repository', 'image.tag')],
    flags=[
        '--set', 'role=Agent',
        '--set', 'env[0].name=ANGLE_LOG',
        '--set', 'env[0].value=trace'
        ]
    )

k8s_resource(workload='angle', port_forwards=9090)
