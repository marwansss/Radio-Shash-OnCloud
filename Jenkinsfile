pipeline{

  agent any

  stages{
    stage('Fitch last code updates'){
      steps{
        git(url: 'https://github.com/marwansss/Radio-Shash-OnCloud.git', branch: 'test')
        sh "scp maro@192.168.1.6:/home/maro/Desktop/Radio-Shash-OnCloud/Terraform/model_2 (3).h5 ./App_Sourcecode "
      }
    }


    stage('build Image'){
      steps{
        sh '''
        cd App_Sourcecode
        sudo docker build -t maro4299311/radioshash:${env.BUILD_NUMBER} .
           '''                    
        withCredentials([usernamePassword(credentialsId: 'dockerusername&password', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                   sh '''
                   sudo docker login -u $USERNAME -p $PASSWORD
                   sudo docker push maro4299311/radioshash:${env.BUILD_NUMBER}
                      '''
        }
      }
    }

    stage('update k8s files'){
      steps{
        cd ../Kubernetes
        sh "sed -i "s|image:.*|image: maro4299311/radioshash:${env.BUILD_NUMBER}|g" deployment.yml"
      }
    }



  }
}

