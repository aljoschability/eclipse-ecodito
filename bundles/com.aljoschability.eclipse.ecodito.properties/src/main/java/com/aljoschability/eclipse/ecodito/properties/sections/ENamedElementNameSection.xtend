package com.aljoschability.eclipse.ecodito.properties.sections;

import com.aljoschability.eclipse.core.properties.graphiti.GraphitiElementAdapter
import com.aljoschability.eclipse.core.properties.sections.AbstractTextSection
import com.aljoschability.eclipse.core.ui.properties.State
import java.util.regex.Pattern
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EcorePackage

class ENamedElementNameSection extends AbstractTextSection {
	new() {
		super(GraphitiElementAdapter.get());
	}

	override protected getFeature() {
		return EcorePackage.Literals.ENAMED_ELEMENT__NAME;
	}

	override protected validate(String value) {

		// empty
		if (value == null || value.isEmpty()) {
			return State.error("The element's name must not be empty!");
		}

		// check name "[A-Za-z\\_][A-Za-z0-9\\_\\$]*[A-Za-z\\_\\$][A-Za-z0-9\\_\\$]*"
		val pattern = "[A-Za-z\\_][A-Za-z0-9\\_\\$]*";
		val compile = Pattern.compile(pattern);

		if (!compile.matcher(value).matches()) {
			return State.error("The element's name seems not to be valid!");
		}

		// hints for the common usage
		val element = getElement();
		if (element instanceof EPackage) {

			// all lower
			if (!value.equals(value.toLowerCase())) {
				return State.warning("The name of an EPackage is normally in lower case.");
			}
		} else if (element instanceof EClassifier) {

			// first upper
			if (!Character.isUpperCase(value.charAt(0))) {
				return State.warning("The name of an EClass normally starts in upper case.");
			}
		}

		return State.info("The name of the element.");
	}

	override protected postExecute() {
		refreshTitle();
	}
}
