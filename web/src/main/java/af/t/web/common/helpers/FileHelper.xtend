package af.t.web.common.helpers

import java.io.File
import java.util.List
import java.util.HashMap
import java.util.Map
import java.util.regex.Pattern
import org.slf4j.LoggerFactory
import org.reflections.Reflections
import org.reflections.util.ConfigurationBuilder
import org.reflections.scanners.ResourcesScanner
import org.reflections.util.ClasspathHelper
import static extension org.apache.commons.io.FileUtils.*
import java.util.Set
import org.slf4j.Logger

/**
 * @MONO_STATE
 * Handles common I/O tasks from a centralized class
 */
class FileHelper {
	package extension val Logger = LoggerFactory.getLogger(this.class)

	static val defaultClass = FileHelper
	static val defaultPattern = ".*(\\.csv|\\.conf|\\.txt|\\.xpi)"

	static var Set<String> resources = newHashSet("")
	static var Class<?> currentClass = defaultClass
	static var String currentPackageName = defaultClass.package.name
	static var String currentPattern = defaultPattern
	static var isInitialized = false;

	new() {
		this(currentClass, defaultPattern)
	}

	new(Class<?> clazz) {
		this(clazz, defaultPattern)
	}

	new(String pattern) {
		this(currentClass, pattern)
	}

	new(Class<?> clazz, String pattern) {
		info("attempting to initialize {}, using path: {}, pattern: {}", this.class, clazz, pattern)

		if (!isInitialized || !clazz.package.name.equals(currentPackageName) || !pattern.equals(currentPattern)) {
			info("{} was not previously initialized, or is about to change", this.class)
			currentPackageName = clazz.package.name
			currentPattern = pattern
			resources.addAll(
				new Reflections(
					new ConfigurationBuilder().setUrls(ClasspathHelper.forPackage(clazz.package.name)).
						setScanners(new ResourcesScanner())).getResources(Pattern.compile(pattern)))
			isInitialized = true
		} else {
			trace("{} was already in expected state", this.class)
		}

		trace("resources are: {}", resources.toString)
	}

	/**
	* FOR INTERNAL USE ONLY
	* gets the uri of resource
	* @Param the name of the resource file (expected to be on the classpath)
	* @Return the URI for the named resource
	*/
	package def getResourceUri(String resourceName) {
		info("getting URI for: {}", resourceName)

		//this class used as a guaranteed-to-exist reference point
		this.class.getResource(resourceName).toURI
	}

	/**
	* @param the name of the resource file (expected to be on the classpath)
	* @Return the File Located associated with that resource name
	*/
	def getResourceAsFile(String resourceName) {
		debug("getting resource as file: {}", resourceName)

		//Filter all resources to ones with requested resource's name
		var candidateResources = resources.filter [
			it.endsWith(resourceName)
		]

		if (candidateResources.empty) {
			error("requested resource: {} was not found among: {}", resourceName, resources)
			throw new IllegalArgumentException
		}

		//Get the resource that is closest to the currentClass
		var pathSegments = currentPackageName.split("\\.")
		var String foundCandidate

		//		var found = false
		while (!pathSegments.nullOrEmpty) {
			val checkPath = pathSegments.join(File.separator)
			pathSegments = pathSegments.take(pathSegments.length - 1)

			trace("checking if a resource is at {}", checkPath, pathSegments)

			foundCandidate = candidateResources.filter [
				it.contains(checkPath)
			].head
			if (!foundCandidate.nullOrEmpty) {
				pathSegments = null
			}
		}
		
		debug("foundCandidate is: {}", foundCandidate)

		if (foundCandidate.equals(null)) {
			error("requested resource: {} was not found in the resource path: {}", resourceName, currentPackageName)
			throw new IllegalArgumentException
		}

		val foundUri = (File.separator + foundCandidate).resourceUri
		info("uri found: {}", foundUri)
		val resourceFile = new File(foundUri)
		
		debug("{} was found at: {}", resourceName, resourceFile.canonicalPath)
		resourceFile

	}

	/**
	* FOR INTERNAL USE ONLY
	* @param a File to read
	* @return the file's contents as a list of lines
	*/
	package def List<String> asList(File file) {
		file.readLines.toList
	}

	/**
	* @param a resource to read
	* @return the file's contents as a list of lines
	*/
	def List<String> asList(String resourceName) {
		resourceName.resourceAsFile.asList
	}

	/**
	* FOR INTERNAL USE ONLY
	* @param a File to read
	* the file should have a header row and it should be tab-separated 
	* @return the file's contents as a mapped list of lines (header-row derived)
	*/
	package def List<Map<String, String>> asMapsList(File file) {
		trace("creating maps list from file: {} located at: {}", file.name, file.canonicalPath)
		val List<String> lines = file.asList
		val headerRow = lines.head.replaceAll(" ", "").toLowerCase.split('\t').toList

		val unfilteredElements = lines.map [ row |
			//skip header row and comments, capture all others
			if (row.equals(lines.head) || row.startsWith('//') || row.startsWith('#')) {
				return null
			} else {
				val cell = row.split('\t').toList

				//create a map: header(key), cell(value)
				val map = new HashMap<String, String>
				headerRow.forEach[map.put(it, cell.get(headerRow.indexOf(it)))]
				trace("the map: {}", map)

				//create an Element using the map
				map as Map<String, String>
			}
		]

		unfilteredElements.filterNull.toList

	}

	/**
	* @param a File to read
	* the file should have a header row and it should be tab-separated 
	* @return the file's contents as a mapped list of lines (header-row derived)
	*/
	def List<Map<String, String>> asMapsList(String resourceName) {
		resourceName.resourceAsFile.asMapsList
	}

}
