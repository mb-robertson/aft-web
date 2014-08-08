package af.t.web.resources.loggerhelper

import org.slf4j.LoggerFactory

class ClassLogLevels {
	static val LOG = LoggerFactory.getLogger(ClassLogLevels)

	static def traceMethod() {
		LOG.trace("trace message")
	}

	static def debugMethod() {
		LOG.debug("debug message")
	}

	static def infoMethod() {
		LOG.info("info message")
	}

	static def errorMethod() {
		LOG.error("error message")
	}

}
