package com.aljoschability.eclipse.ecodito.properties.sections

import com.aljoschability.eclipse.core.properties.graphiti.GraphitiElementAdapter
import com.aljoschability.eclipse.core.ui.properties.sections.AbstractTextSection
import org.eclipse.emf.ecore.EcorePackage

class EPackageNsPrefixSection extends AbstractTextSection {
	new() {
		super(GraphitiElementAdapter::get())
	}

	override protected getFeature() {
		return EcorePackage.Literals::EPACKAGE__NS_PREFIX
	}
}
