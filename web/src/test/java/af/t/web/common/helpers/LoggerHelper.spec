package af.t.web.common.helpers

import af.t.web.resources.loggerhelper.InstanceLogLevels
import af.t.web.resources.loggerhelper.ClassLogLevels
import java.util.Set
import ch.qos.logback.classic.Level

describe LoggerHelper {
	extension LoggerHelper = new LoggerHelper

	def should_contain(Set<Level> set, Level level) {
		set.contains(level)
	}

	def levelsTable{
		| input   | expected |
		| "ALL"   | ALL      |
		| "trace" | TRACE    |
		| "deBug" | DEBUG    |
		| "info"  | INFO     |
		| "ERROR" | ERROR    |
		| "DNE"   | DEBUG    |
	}

	context "for the Root Logger" {

		fact "provide the logging level"{
			val initialLevel = DEBUG
			subject.level should be initialLevel
		}

		fact "set the logging level" {
			levelsTable.forEach [
				DEBUG.toString.setLevel //reset
				input.setLevel
				val actual = level
				actual should be expected
			]

		}
	}

	context "for class instances" {
		val targetInstance = new InstanceLogLevels

		fact "provide the logging level"{
			#{null, DEBUG} should contain targetInstance.level
		}

		fact "set the logging level" {
			levelsTable.forEach [
				targetInstance.level = DEBUG.toString //reset
				targetInstance.level = input
				targetInstance.level should be expected
			]
		}
	}

	context "with a class" {
		val targetClass = ClassLogLevels

		fact "provide the logging level"{
			#{null, DEBUG} should contain targetClass.level
		}

		fact "set the logging level "{
			levelsTable.forEach [
				targetClass.level = DEBUG.toString //reset
				targetClass.level = input
				targetClass.level should be expected
			]
		}

	}
}
