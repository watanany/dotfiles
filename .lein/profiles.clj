{:user
 {:plugins [[lein-ancient "0.6.15"]
            [lein-exec "0.3.7"]
            [lein-pprint "1.3.2"]
            ]
  :dependencies [[org.clojure/tools.namespace "1.1.0"]
                 [org.clojure/data.json "1.0.0"]
                 [hashp "0.2.0"]
                 [clj-http "3.12.0"]
                 [rhizome "0.2.9"]
                 ]
  :injections [(require '[clojure.tools.namespace.repl :refer [refresh]])
               (require 'hashp.core)
               ]}}
