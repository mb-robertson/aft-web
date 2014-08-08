package af.t.web.resources.loggerhelper

import org.slf4j.LoggerFactory

class InstanceLogLevels {
	val LOG = LoggerFactory.getLogger(this.class)

	new() {
	}

	def traceMethod() {
		LOG.trace("trace message")
	}

	def debugMethod() {
		LOG.debug("debug message")
	}

	def infoMethod() {
		LOG.info("info message")
	}

	def errorMethod() {
		LOG.error("error message")
	}

}
