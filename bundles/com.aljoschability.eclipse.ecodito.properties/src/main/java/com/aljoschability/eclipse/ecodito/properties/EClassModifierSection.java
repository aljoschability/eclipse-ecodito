package com.aljoschability.eclipse.ecodito.properties;

import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.EcorePackage;

import com.aljoschability.eclipse.core.properties.graphiti.GraphitiElementAdapter;
import com.aljoschability.eclipse.core.ui.properties.sections.AbstractCheckboxSection;

public class EClassModifierSection extends AbstractCheckboxSection {
	public EClassModifierSection() {
		super(GraphitiElementAdapter.get());
	}

	@Override
	protected EStructuralFeature getFeature() {
		return EcorePackage.Literals.ECLASS__ABSTRACT;
	}
}
