package af.t.web.common.helpers

import af.t.web.resources.instancepopulator.FieldsStringOnly
import af.t.web.resources.instancepopulator.FieldsBooleanOnly
import af.t.web.resources.instancepopulator.FieldsIntegerOnly
import af.t.web.resources.instancepopulator.FieldsDoubleOnly
import af.t.web.resources.instancepopulator.FieldsMixed

describe InstancePopulator {
	context "populate an object" {
		fact "with only String type properties"{
			val map = newHashMap("a" -> "a from instance", "b" -> "b from instance", "c" -> "c from instance")
			val object = new FieldsStringOnly
			object.a should be null
			object.b should be null
			object.c should be null

			subject.populate(object, map)
			object.a should be "a from instance"
			object.b should be "b from instance"
			object.c should be "c from instance"
		}

		fact "with only boolean type properties"{
			val map = newHashMap("a" -> "true", "b" -> "false")
			val object = new FieldsBooleanOnly
			object.a should be false
			object.b should be false

			subject.populate(object, map)
			object.a should be true
			object.b should be false
		}

		fact "with only integer type properties"{
			val map = newHashMap("a" -> "999", "b" -> "888")
			val object = new FieldsIntegerOnly
			object.a should be 0
			object.b should be 0

			subject.populate(object, map)
			object.a should be 999
			object.b should be 888
		}

		fact "with only double type properties"{
			val map = newHashMap("a" -> "999", "b" -> "888")
			val object = new FieldsDoubleOnly
			object.a should be 0.0
			object.b should be 0.0

			subject.populate(object, map)
			object.a should be 999.0
			object.b should be 888.0
		}

		fact "with mixed types of properties"{
			val map = newHashMap(
				"booleanField" -> "true",
				"integerField" -> "999",
				"doubleField" -> "888",
				"stringField" -> "a from instance"
			)

			val object = new FieldsMixed
			object.booleanField should be false
			object.integerField should be 0
			object.doubleField should be 0.0
			object.stringField should be null

			subject.populate(object, map)
			object.booleanField should be true
			object.integerField should be 999
			object.doubleField should be 888.0
			object.stringField should be "a from instance"
		}
	}

	context "populate a new instance from class" {
		fact "with only String type properties"{
			val map = newHashMap("a" -> "a from class", "b" -> "b from class", "c" -> "c from class")

			val object = subject.create(FieldsStringOnly, map) as FieldsStringOnly
			object.a should be "a from class"
			object.b should be "b from class"
			object.c should be "c from class"
		}

		fact "with only boolean type properties"{
			val map = newHashMap("a" -> "false", "b" -> "true")

			val object = subject.create(
				FieldsBooleanOnly,
				map
			) as FieldsBooleanOnly
			object.a should be false
			object.b should be true
		}

		fact "with only integer type properties"{
			val map = newHashMap("a" -> "999", "b" -> "888")
			val object = subject.create(FieldsIntegerOnly, map) as FieldsIntegerOnly
			object.a should be 999
			object.b should be 888
		}

		fact "with only double type properties"{
			val map = newHashMap("a" -> "999", "b" -> "888")
			val object = subject.create(FieldsDoubleOnly, map) as FieldsDoubleOnly
			object.a should be 999.0
			object.b should be 888.0
		}

		fact "with mixed types of properties"{
			val map = newHashMap(
				"booleanField" -> "true",
				"integerField" -> "999",
				"doubleField" -> "888",
				"stringField" -> "a from instance"
			)

			val object = subject.create(FieldsMixed, map) as FieldsMixed
			object.booleanField should be true
			object.integerField should be 999
			object.doubleField should be 888.0
			object.stringField should be "a from instance"
		}
	}
}
