default['reposerver'] = 'http://192.168.56.56'

default['startnodeno'] = 5
default['endnodeno'] = 9
default['cdh']['version'] = '5.4.2'
default['namenode']['hostname'] = 'node205'
default['namenode']['port'] = '8020'
default['secondarynamenode']['hostname'] = 'node206'

default['resourcemanager']['hostname'] = 'node206'

default['historyserver']['hostname'] = 'node206'
default['historyserver']['port'] = '10020'
default['historyserver']['webappport'] = '19888'

default['user']['hdfs'] = 'hdfs'
default['user']['yarn'] = 'yarn'
default['user']['storm'] = 'storm'
default['user']['oozie'] = 'oozie'

default['maxnodes'] = 2

default['group']['zookeeper'] = 'zookeeper'
default['user']['zookeeper'] = 'zookeeper'

default['neo4j']['version'] = 'community-2.3.1'
default['redis']['version'] = '3.0.5'

default['conf']['core-site.xml']['hostname'] = ''
default['conf']['core-site.xml']['path'] = ''
default['conf']['hdfs-site.xml']['hostname'] = ''
default['conf']['hdfs-site.xml']['path'] = ''
default['conf']['hive-site.xml']['hostname'] = ''
default['conf']['hive-site.xml']['path'] = ''
default['conf']['hbase-site.xml']['hostname'] = ''
default['conf']['hbase-site.xml']['path'] = ''
