{:original-user
 {:plugins [[lein-ancient "1.0.0-RC3"]
            [lein-exec "0.3.7"]
            [lein-pprint "1.3.2"]
            [lein-localrepo "0.5.4"]]
  :dependencies []
  :injections [(require '[clojure.repl :refer :all])
               (require '[clojure.pprint :refer :all])]}

 :user
 {:plugins [[lein-ancient "1.0.0-RC3"]
            [lein-exec "0.3.7"]
            [lein-pprint "1.3.2"]
            [lein-localrepo "0.5.4"]
            ;;[refactor-nrepl/refactor-nrepl "3.9.0"]
            [cider/cider-nrepl "0.39.1"]]
  :middleware []
  :dependencies [[org.clojure/algo.generic "0.1.3"]
                 [org.clojure/algo.monads "0.1.6"]
                 [org.clojure/core.async "1.6.681"]
                 [org.clojure/core.cache "1.0.225"]
                 [org.clojure/core.logic "1.0.1"]
                 [org.clojure/core.match "1.0.1"]
                 [org.clojure/core.memoize "1.0.257"]
                 [org.clojure/core.rrb-vector "0.1.2"]
                 [org.clojure/core.unify "0.5.7"]
                 [org.clojure/data.avl "0.1.0"]
                 [org.clojure/data.codec "0.1.1"]
                 [org.clojure/data.csv "1.0.1"]
                 [org.clojure/data.finger-tree "0.0.3"]
                 [org.clojure/data.fressian "1.0.0"]
                 [org.clojure/data.int-map "1.2.1"]
                 [org.clojure/data.json "2.4.0"]
                 [org.clojure/data.priority-map "1.1.0"]
                 [org.clojure/data.xml "0.2.0-alpha6"]
                 [org.clojure/data.zip "1.0.0"]
                 [org.clojure/java.classpath "1.0.0"]
                 [org.clojure/java.data "1.0.95"]
                 [org.clojure/java.jdbc "0.7.12"]
                 [org.clojure/java.jmx "1.0.0"]
                 [org.clojure/math.combinatorics "0.2.0"]
                 [org.clojure/math.numeric-tower "0.0.5"]
                 [org.clojure/test.check "1.1.1"]
                 [org.clojure/tools.analyzer "1.1.1"]
                 [org.clojure/tools.analyzer.jvm "1.2.3"]
                 [org.clojure/tools.cli "1.0.219"]
                 [org.clojure/tools.deps.alpha "0.15.1254"]
                 [org.clojure/tools.deps.graph "1.1.84"]
                 [org.clojure/tools.gitlibs "2.5.197"]
                 [org.clojure/tools.emitter.jvm "0.1.0-beta5"]
                 [org.clojure/tools.logging "1.2.4"]
                 [org.clojure/tools.macro "0.1.5"]
                 [org.clojure/tools.namespace "1.4.4"]
                 [org.clojure/tools.reader "1.3.6"]
                 [org.clojure/tools.trace "0.7.11"]
                 [org.clj-commons/pretty "2.2"]
                 [buddy/buddy-core "1.11.423"]
                 [buddy/buddy-auth "3.0.323"]
                 [buddy/buddy-hashers "2.0.167"]
                 [buddy/buddy-sign "3.5.351"]
                 [clj-commons/clj-yaml "1.0.27"]
                 [clj-glob "1.0.0"]
                 [clj-http "3.12.3"]
                 [clj-time "0.15.2"]
                 [clj-python/libpython-clj "2.025"]
                 [clojupyter "0.3.6"]
                 [com.github.seancorfield/honeysql "2.4.1078"]
                 [com.github.seancorfield/next.jdbc "1.3.894"]
                 [etaoin "1.0.40"]
                 [expresso "0.2.4"]
                 [hiccup "1.0.5"]
                 [hickory "0.7.1"]
                 [net.mikera/core.matrix "0.63.0"]
                 [nrepl "1.0.0"]
                 [org.clojure.typed/runtime.jvm "1.0.1"]
                 [org.clojure.typed/checker.jvm "1.0.1"]
                 [org.postgresql/postgresql "42.6.0"]
                 [org.tensorflow/tensorflow-core-platform "0.5.0"]
                 [rm-hull/infix "0.4.1"]
                 [com.fasterxml.jackson.dataformat/jackson-dataformat-yaml "2.15.2"]]
  :injections [(require '[clojure.walk :refer [keywordize-keys]])
               (require '[clojure.stacktrace :refer [print-stack-trace]])
               (require '[clojure.repl :refer :all])
               (require '[clojure.pprint :refer :all])
               (require '[clojure.core.match :refer [match]])
               (require '[clojure.data.csv :as csv])
               (require '[clojure.data.json :as json])
               (require '[clojure.math.numeric-tower :as math])
               (require '[clojure.math.combinatorics :as combo])
               (require '[clojure.set :as set])
               (require '[clojure.string :as str])
               (require '[clojure.tools.namespace.repl :refer [refresh]])
               (require '[clojure.tools.trace :refer :all])
               (require '[clj-http.client :as http-client])
               (require '[clj-time.core :as time])
               (require '[clj-time.format :as time-format])
               (require '[clj-time.local :as time-local])
               (require '[clojure.core.matrix :as mat])
               (require '[infix.macros :refer [infix $=]])
               (require '[hickory.core :as hickory])
               (require '[hickory.convert :refer [hickory-to-hiccup hiccup-to-hickory]])
               (require '[honey.sql :as sql])
               (require '[honey.sql.helpers :as sql-helpers])
               (require '[numeric.expresso.core :as ex])
               (require '[org.satta.glob :refer [glob]])
               (require '[libpython-clj2.python :refer [py. py.. py.-] :as py])
               (require '[libpython-clj2.require :refer [require-python]])]}}
