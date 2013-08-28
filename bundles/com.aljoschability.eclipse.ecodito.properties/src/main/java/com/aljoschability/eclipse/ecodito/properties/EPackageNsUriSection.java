package com.aljoschability.eclipse.ecodito.properties;

import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.EcorePackage;

import com.aljoschability.eclipse.core.properties.graphiti.GraphitiElementAdapter;
import com.aljoschability.eclipse.core.ui.properties.sections.AbstractTextSection;

public class EPackageNsUriSection extends AbstractTextSection {
	public EPackageNsUriSection() {
		super(GraphitiElementAdapter.get());
	}

	@Override
	protected EStructuralFeature getFeature() {
		return EcorePackage.Literals.EPACKAGE__NS_URI;
	}
}
