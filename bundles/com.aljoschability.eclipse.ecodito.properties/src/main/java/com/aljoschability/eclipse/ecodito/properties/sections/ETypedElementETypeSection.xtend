package com.aljoschability.eclipse.ecodito.properties.sections;

import com.aljoschability.eclipse.core.properties.graphiti.GraphitiElementAdapter
import com.aljoschability.eclipse.core.ui.properties.sections.AbstractComboSection
import java.util.Collections
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.EcorePackage

class ETypedElementETypeSection extends AbstractComboSection<EClassifier> {
	new() {
		super(GraphitiElementAdapter.get());
	}

	override protected getFeature() {
		return EcorePackage.Literals.ETYPED_ELEMENT__ETYPE;
	}

	override protected getItems() {
		return Collections.emptyList();
	}
}
