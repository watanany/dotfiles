{:user
 {:plugins [[lein-ancient "0.6.15"]
            [lein-exec "0.3.7"]
            [lein-pprint "1.3.2"]
            ]
  :dependencies [[org.clojure/algo.generic "0.1.3"]
                 [org.clojure/algo.monads "0.1.6"]
                 [org.clojure/core.async "1.3.618"]
                 [org.clojure/core.cache "1.0.207"]
                 [org.clojure/core.logic "1.0.0"]
                 [org.clojure/core.match "1.0.0"]
                 [org.clojure/core.memoize "1.0.236"]
                 [org.clojure/core.rrb-vector "0.1.2"]
                 [org.clojure/core.typed "0.6.0"]
                 [org.clojure/core.unify "0.5.7"]
                 [org.clojure/data.avl "0.1.0"]
                 [org.clojure/data.codec "0.1.1"]
                 [org.clojure/data.csv "1.0.0"]
                 [org.clojure/data.finger-tree "0.0.3"]
                 [org.clojure/data.fressian "1.0.0"]
                 [org.clojure/data.int-map "1.0.0"]
                 [org.clojure/data.json "2.3.1"]
                 [org.clojure/data.priority-map "1.0.0"]
                 [org.clojure/data.xml "0.2.0-alpha6"]
                 [org.clojure/data.zip "1.0.0"]
                 [org.clojure/java.classpath "1.0.0"]
                 [org.clojure/java.data "1.0.86"]
                 [org.clojure/java.jdbc "0.7.12"]
                 [org.clojure/java.jmx "1.0.0"]
                 [org.clojure/math.combinatorics "0.1.6"]
                 [org.clojure/math.numeric-tower "0.0.4"]
                 [org.clojure/test.check "1.1.0"]
                 [org.clojure/tools.analyzer "1.0.0"]
                 [org.clojure/tools.analyzer.jvm "1.1.0"]
                 [org.clojure/tools.cli "1.0.206"]
                 [org.clojure/tools.deps.alpha "0.11.922"]
                 [org.clojure/tools.deps.graph "1.0.56"]
                 [org.clojure/tools.gitlibs "2.3.167"]
                 [org.clojure/tools.emitter.jvm "0.1.0-beta5"]
                 [org.clojure/tools.logging "1.1.0"]
                 [org.clojure/tools.macro "0.1.5"]
                 [org.clojure/tools.namespace "1.1.0"]
                 [org.clojure/tools.reader "1.3.5"]
                 [org.clojure/tools.trace "0.7.11"]
                 [clj-http "3.12.0"]
                 [clj-time "0.15.2"]
                 [expresso "0.2.2"]
                 [hiccup "1.0.5"]
                 [hickory "0.7.1"]
                 [net.mikera/core.matrix "0.62.0"]
                 [org.tensorflow/tensorflow-core-platform "0.3.1"]
                 [rm-hull/infix "0.3.3"]
                 ]
  :injections [(require '[clojure.core.match :refer [match]])
               (require '[clojure.data.csv :as csv])
               (require '[clojure.data.json :as json])
               (require '[clojure.math.numeric-tower :as math])
               (require '[clojure.math.combinatorics :as combo])
               (require '[clojure.set :as set])
               (require '[clojure.string :as string])
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
               (require '[numeric.expresso.core :as ex])
               ]}}
