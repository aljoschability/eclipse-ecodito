package com.aljoschability.eclipse.grecoto.ui.properties;

import java.util.regex.Pattern;

import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.EcorePackage;

import com.aljoschability.eclipse.core.properties.graphiti.GraphitiElementAdapter;
import com.aljoschability.eclipse.core.ui.properties.State;
import com.aljoschability.eclipse.core.ui.properties.sections.AbstractTextSection;

public class ENamedElementNameSection extends AbstractTextSection {
	public ENamedElementNameSection() {
		super(GraphitiElementAdapter.get());
	}

	@Override
	protected EStructuralFeature getFeature() {
		return EcorePackage.Literals.ENAMED_ELEMENT__NAME;
	}

	@Override
	protected State validate(String value) {
		// empty
		if (value == null || value.isEmpty()) {
			return State.error("The element's name must not be empty!");
		}

		// check name "[A-Za-z\\_][A-Za-z0-9\\_\\$]*[A-Za-z\\_\\$][A-Za-z0-9\\_\\$]*"
		String pattern = "[A-Za-z\\_][A-Za-z0-9\\_\\$]*";
		Pattern compile = Pattern.compile(pattern);

		if (!compile.matcher(value).matches()) {
			return State.error("The element's name seems not to be valid!");
		}

		// hints for the common usage
		EObject element = getElement();
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

	@Override
	protected void postExecute() {
		refreshTitle();
	}
}
