pipeline {
  environment {
  IBM_CLOUD_REGION = 'us-south'
  REGISTRY_HOSTNAME = 'de.icr.io'
  IKS_CLUSTER = 'c0sf25ud0fesivtjm07g'
  DEPLOYMENT_NAME = 'iks-test'
  PORT = '5001'
  registry = "preranang/kube"
  registryCredential = 'Docker'
  dockerImage = ''
  }
  agent any 
  stages {
    stage('Install IBM Cloud CLI') {
      steps { 
        sh ''' 
            curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
            ibmcloud --version
            ibmcloud config --check-version=false
            ibmcloud plugin install -f kubernetes-service
            ibmcloud plugin install -f container-registry
            '''
      }
    }
    stage('Authenticate with IBM Cloud CLI') {
      steps {
        sh '''
            ibmcloud login --apikey "${api-key}" -r "${IBM_CLOUD_REGION}" -g Default
            ibmcloud ks cluster config --cluster ${IKS_CLUSTER}
            '''
      }
    }
    stage('Build with Docker') {
      steps {
        script {
        dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    stage('Push the image to ICR') {
      steps {
        script {
          docker.withRegistry( '', registryCredential ) {
          dockerImage.push()
          }
        }
      }
    }
    stage('Deploy to IKS') {
      steps {
        sh '''
            ibmcloud ks cluster config --cluster ${IKS_CLUSTER}
            kubectl config current-context
            kubectl create deployment ${DEPLOYMENT_NAME} --image=preranang/kube --dry-run -o yaml > deployment.yaml
            kubectl apply -f deployment.yaml
            kubectl rollout status deployment/${DEPLOYMENT_NAME}
            kubectl create service loadbalancer ${DEPLOYMENT_NAME} --tcp=80:${PORT} --dry-run -o yaml > service.yaml
            kubectl apply -f service.yaml
            kubectl get services -o wide
            '''
      }
    }
  }
}
