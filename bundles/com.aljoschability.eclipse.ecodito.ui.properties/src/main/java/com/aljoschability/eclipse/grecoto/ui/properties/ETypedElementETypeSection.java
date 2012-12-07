package com.aljoschability.eclipse.grecoto.ui.properties;

import java.util.Collections;
import java.util.List;

import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.EcorePackage;

import com.aljoschability.eclipse.core.properties.graphiti.GraphitiElementAdapter;
import com.aljoschability.eclipse.core.ui.properties.sections.AbstractComboSection;

public class ETypedElementETypeSection extends AbstractComboSection<EClassifier> {
	public ETypedElementETypeSection() {
		super(GraphitiElementAdapter.get());
	}

	@Override
	protected EStructuralFeature getFeature() {
		return EcorePackage.Literals.ETYPED_ELEMENT__ETYPE;
	}

	@Override
	protected List<EClassifier> getItems() {
		return Collections.emptyList();
	}
}
