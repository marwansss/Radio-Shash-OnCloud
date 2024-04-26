pipeline{

  agent any

  stages{
    stage('Fitch last code updates'){
      steps{
        git(url: 'https://github.com/marwansss/Radio-Shash-OnCloud.git', branch: 'test')
      }
    }


    stage('build Image'){
      steps{
        sh "docker build -t maro4299311/radioshash:${env.BUILD_NUMBER} App_Sourcecode/."                    
        withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                  
                  sh "docker login -u $USERNAME -p $PASSWORD"
                  //sh "docker push maro4299311/radioshash:${env.BUILD_NUMBER}"
                     
        }
      }
    }

    stage('update k8s files'){
      steps{
        sh "sed -i \'s/image*/image: maro4299311/radioshash:${env.BUILD_NUMBER}/\' Kubernetes/deployment.yml"
      }
    }



  }
}

