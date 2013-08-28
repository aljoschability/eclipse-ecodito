package com.aljoschability.eclipse.ecodito.properties.sections;

import com.aljoschability.eclipse.core.properties.graphiti.GraphitiElementAdapter
import com.aljoschability.eclipse.core.properties.sections.AbstractCheckboxSection
import org.eclipse.emf.ecore.EcorePackage

class EClassModifierSection extends AbstractCheckboxSection {
	new() {
		super(GraphitiElementAdapter.get());
	}

	override protected getFeature() {
		return EcorePackage.Literals.ECLASS__ABSTRACT;
	}
}
