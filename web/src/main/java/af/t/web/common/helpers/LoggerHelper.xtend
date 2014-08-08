package af.t.web.common.helpers

import org.slf4j.LoggerFactory
import ch.qos.logback.classic.Logger
import static extension ch.qos.logback.classic.Level.*

class LoggerHelper {
	package val LOG = LoggerFactory.getLogger(this.class)

	static val LOGGER = LoggerFactory.getLogger(Logger.ROOT_LOGGER_NAME) as Logger

	new() {
	}

	def setLevel(String targetLevel) {

		//set the root logger's level to the specified level or leave it alone
		LOGGER.level = targetLevel.toLevel(getLevel)
		if(!getLevel.toString.equalsIgnoreCase(targetLevel)) {
			LOG.error(
				"Invalid target log level {} was specified, {} logging is still in effect",
				targetLevel, LOGGER.level.toString)
		}
	}

	def setLevel(Object instance, String targetLevel) {
		instance.class.setLevel(targetLevel)
	}

	def setLevel(Class<?> targetClass, String targetLevel) {
		val logger = targetClass.loggerForClass

		//set the target class' log level to the specified level or leave it alone
		logger.level = targetLevel.toLevel(targetClass.level)
		if(!logger.getLevel.toString.equalsIgnoreCase(targetLevel)) {
			LOG.error(
				"Invalid target log level {} was specified for {}, {} logging is still in effect",
				targetLevel, targetClass.simpleName, targetClass.level)
		}
	}

	package def getLevel() {
		LOGGER.level
	}

	package def getLevel(Class<?> clazz) {
		clazz.loggerForClass.level
	}

	package def getLevel(Object instance) {
		instance.class.getLevel
	}

	private def getLoggerForClass(Class<?> targetClass) {
		LoggerFactory.getLogger(targetClass) as Logger
	}

	package def checkLevels() {
		LOG.error("At log level {}, ERROR logged", LOGGER.level)
		LOG.info("At log level {}, INFO logged", LOGGER.level)
		LOG.debug("At log level {}, DEBUG logged", LOGGER.level)
		LOG.trace("At log level {}, TRACE logged", LOGGER.level)
	}

	package def getALL() {
		ALL
	}

	package def getTRACE() {
		TRACE
	}

	package def getDEBUG() {
		DEBUG
	}

	package def getINFO() {
		INFO
	}

	package def getERROR() {
		ERROR
	}

}
