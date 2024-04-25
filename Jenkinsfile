pipeline{

  agent any

  stages{
    stage('build'){
      steps{
        git(url: 'https://github.com/marwansss/Radio-Shash-OnCloud.git', branch: 'test')
        cd App_SourceCode/
        docker build -t maro4299311/radioshash:1.0 .
        docker login -u $USER -p $PASS
        docker push maro4299311/radioshash:1.0
      }
    }


    stage('test'){
      steps{
        sh '''
        docker run -d -p 5000:5000 --name radioshash maro4299311/radioshash:1.0
        curl localhost:5000
        if [ $? -eq 0 ]; then
           echo "container has successfuly deployed"
           docker rm radioshash
        else
           echo "container has failed to deployed"
        fi
        '''
      }
    }


  stage('deploy'){
      steps{
        cd var/lib/jenkins/workspace/radioshash/Kubernetes
        kubectl create -f deployment.yml
        kubectl create -f service.yml
      }
    }


  }
}


