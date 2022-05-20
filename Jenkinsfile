pipeline {
  agent {
    node {
      label 'runner'
    }
  }
  stages {
    stage('gpuCI/parallel/miniforge') {
      parallel {
        stage('gpuCI/build/miniforge-cuda') {
          steps {
            retry(1) {
              build(
                job: 'gpuci/gpuci-build-environment-jobs/miniforge-cuda',
                wait: true,
                propagate: true,
                parameters: [
                  string(name: 'GIT_URL', value: env.GIT_URL),
                  string(name: 'PR_ID', value: (env.CHANGE_ID == null) ? 'BRANCH' : env.CHANGE_ID),
                  string(name: 'COMMIT_HASH', value: (env.CHANGE_ID == null) ? env.GIT_BRANCH : 'origin/pr/'+env.CHANGE_ID+'/merge')
                ]
              )
            }
          }
        }
        stage('gpuCI/build/miniforge-cuda-arm64') {
          steps {
            retry(1) {
              build(
                job: 'gpuci/gpuci-build-environment-jobs/miniforge-cuda-arm64',
                wait: true,
                propagate: true,
                parameters: [
                  string(name: 'GIT_URL', value: env.GIT_URL),
                  string(name: 'PR_ID', value: (env.CHANGE_ID == null) ? 'BRANCH' : env.CHANGE_ID),
                  string(name: 'COMMIT_HASH', value: (env.CHANGE_ID == null) ? env.GIT_BRANCH : 'origin/pr/'+env.CHANGE_ID+'/merge')
                ]
              )
            }
          }
        }
        stage('gpuCI/build/miniforge-cuda-l4t') {
          steps {
            retry(1) {
              build(
                job: 'gpuci/gpuci-build-environment-jobs/miniforge-cuda-l4t',
                wait: true,
                propagate: true,
                parameters: [
                  string(name: 'GIT_URL', value: env.GIT_URL),
                  string(name: 'PR_ID', value: (env.CHANGE_ID == null) ? 'BRANCH' : env.CHANGE_ID),
                  string(name: 'COMMIT_HASH', value: (env.CHANGE_ID == null) ? env.GIT_BRANCH : 'origin/pr/'+env.CHANGE_ID+'/merge')
                ]
              )
            }
          }
        }
      }
    }
    stage('gpuCI/parallel/miniforge-driver'){
      parallel {
        stage('gpuCI/build/miniforge-cuda-driver') {
          steps {
            retry(1) {
              build(
                job: 'gpuci/gpuci-build-environment-jobs/miniforge-cuda-driver',
                wait: true,
                propagate: true,
                parameters: [
                  string(name: 'GIT_URL', value: env.GIT_URL),
                  string(name: 'PR_ID', value: (env.CHANGE_ID == null) ? 'BRANCH' : env.CHANGE_ID),
                  string(name: 'COMMIT_HASH', value: (env.CHANGE_ID == null) ? env.GIT_BRANCH : 'origin/pr/'+env.CHANGE_ID+'/merge')
                ]
              )
            }
          }
        }
        stage('gpuCI/build/miniforge-cuda-driver-arm64') {
          steps {
            retry(1) {
              build(
                job:
                'gpuci/gpuci-build-environment-jobs/miniforge-cuda-driver-arm64',
                wait: true,
                propagate: true,
                parameters: [
                  string(name: 'GIT_URL', value: env.GIT_URL),
                  string(name: 'PR_ID', value: (env.CHANGE_ID == null) ? 'BRANCH' : env.CHANGE_ID),
                  string(name: 'COMMIT_HASH', value: (env.CHANGE_ID == null) ? env.GIT_BRANCH : 'origin/pr/'+env.CHANGE_ID+'/merge')
                ]
              )
            }
          }
        }
      }
    }
    stage('gpuCI/parallel/rapidsai') {
      parallel {
        stage('gpuCI/build/rapidsai') {
          steps {
            retry(1) {
              build(
                job: 'gpuci/gpuci-build-environment-jobs/rapidsai',
                wait: true,
                propagate: true,
                parameters: [
                  string(name: 'GIT_URL', value: env.GIT_URL),
                  string(name: 'PR_ID', value: (env.CHANGE_ID == null) ? 'BRANCH' : env.CHANGE_ID),
                  string(name: 'COMMIT_HASH', value: (env.CHANGE_ID == null) ? env.GIT_BRANCH : 'origin/pr/'+env.CHANGE_ID+'/merge')
                ]
              )
            }
          }
        }
        stage('gpuCI/build/rapidsai-arm64') {
          steps {
            retry(1) {
              build(
                job: 'gpuci/gpuci-build-environment-jobs/rapidsai-arm64',
                wait: true,
                propagate: true,
                parameters: [
                  string(name: 'GIT_URL', value: env.GIT_URL),
                  string(name: 'PR_ID', value: (env.CHANGE_ID == null) ? 'BRANCH' : env.CHANGE_ID),
                  string(name: 'COMMIT_HASH', value: (env.CHANGE_ID == null) ? env.GIT_BRANCH : 'origin/pr/'+env.CHANGE_ID+'/merge')
                ]
              )
            }
          }
        }
        stage('gpuCI/build/rapidsai-l4t') {
          steps {
            retry(1) {
              build(
                job: 'gpuci/gpuci-build-environment-jobs/rapidsai-l4t',
                wait: true,
                propagate: true,
                parameters: [
                  string(name: 'GIT_URL', value: env.GIT_URL),
                  string(name: 'PR_ID', value: (env.CHANGE_ID == null) ? 'BRANCH' : env.CHANGE_ID),
                  string(name: 'COMMIT_HASH', value: (env.CHANGE_ID == null) ? env.GIT_BRANCH : 'origin/pr/'+env.CHANGE_ID+'/merge')
                ]
              )
            }
          }
        }
      }
    }
    stage('gpuCI/parallel/rapidsai-driver') {
      parallel {
        stage('gpuCI/build/rapidsai-driver') {
          steps {
            retry(1) {
              build(
                job: 'gpuci/gpuci-build-environment-jobs/rapidsai-driver',
                wait: true,
                propagate: true,
                parameters: [
                  string(name: 'GIT_URL', value: env.GIT_URL),
                  string(name: 'PR_ID', value: (env.CHANGE_ID == null) ? 'BRANCH' : env.CHANGE_ID),
                  string(name: 'COMMIT_HASH', value: (env.CHANGE_ID == null) ? env.GIT_BRANCH : 'origin/pr/'+env.CHANGE_ID+'/merge')
                ]
              )
            }
          }
        }
        stage('gpuCI/build/rapidsai-driver-arm64') {
          steps {
            retry(1) {
              build(
                job: 'gpuci/gpuci-build-environment-jobs/rapidsai-driver-arm64',
                wait: true,
                propagate: true,
                parameters: [
                  string(name: 'GIT_URL', value: env.GIT_URL),
                  string(name: 'PR_ID', value: (env.CHANGE_ID == null) ? 'BRANCH' : env.CHANGE_ID),
                  string(name: 'COMMIT_HASH', value: (env.CHANGE_ID == null) ? env.GIT_BRANCH : 'origin/pr/'+env.CHANGE_ID+'/merge')
                ]
              )
            }
          }
        }
      }
    }
  }
}
