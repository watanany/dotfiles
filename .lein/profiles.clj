{:user
 {:plugins [[lein-ancient "0.6.15"]
            [lein-exec "0.3.7"]
            [lein-pprint "1.3.2"]
            ]
  :dependencies [[org.clojure/tools.namespace "1.1.0"]
                 [org.clojure/tools.trace "0.7.11"]
                 [org.clojure/data.json "1.0.0"]
                 [clj-http "3.12.0"]
                 [clj-time "0.15.2"]
                 [rm-hull/infix "0.3.3"]
                 [rhizome "0.2.9"]
                 ]
  :injections [(require '[clojure.tools.namespace.repl :refer [refresh]])
               (require '[clojure.tools.trace :refer :all])
               (require '[clojure.set :as set])
               (require '[clojure.string :as str])
               (require '[clojure.data.json :as json])
               (require '[clj-time.core :as time])
               (require '[clj-time.format :as time-format])
               (require '[clj-time.local :as time-local])
               (require '[infix.macros :refer [infix $=]])
               ]}}
