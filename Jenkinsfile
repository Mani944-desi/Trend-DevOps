pipeline {
  agent any

  environment {
    DOCKER_USER  = 'mani944desi'
    IMAGE_NAME   = "${DOCKER_USER}/trend-frontend"
    AWS_REGION   = "us-west-2"
    CLUSTER_NAME = "trend-eks"
    KUBECONFIG   = "/var/jenkins_home/.kube/config"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
      }
    }

    stage('Login to DockerHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                          usernameVariable: 'DH_USER',
                                          passwordVariable: 'DH_PASS')]) {
          sh "echo $DH_PASS | docker login -u $DH_USER --password-stdin"
        }
      }
    }

    stage('Push Image') {
      steps {
        sh "docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
      }
    }

    stage('Deploy to EKS') {
      steps {
        sh """
        export KUBECONFIG=${KUBECONFIG}

        # Update image tag in manifest
        sed -i 's#image: .*#image: ${IMAGE_NAME}:${BUILD_NUMBER}#' k8s/deployment.yaml

        # Apply to cluster
        kubectl apply -f k8s/deployment.yaml

        # Wait for rollout
        kubectl rollout status deployment/trend-frontend
        """
      }
    }
  }
}
